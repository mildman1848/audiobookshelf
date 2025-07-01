# ./Dockerfile

# syntax=docker/dockerfile:1

ARG AUDIOBOOKSHELF_RELEASE
ARG NUSQLITE3_DIR="/usr/local/lib/nusqlite3"
ARG NUSQLITE3_PATH="${NUSQLITE3_DIR}/libnusqlite3.so"

### STAGE 0: Build client ###
FROM node:20-alpine AS build-client

ARG AUDIOBOOKSHELF_RELEASE

WORKDIR /build
RUN apk add --no-cache git curl sed && \
    RELEASE="${AUDIOBOOKSHELF_RELEASE}" && \
    if [ -z "$RELEASE" ]; then \
      RELEASE=$(curl -sL "https://api.github.com/repos/advplyr/audiobookshelf/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'); \
    fi && \
    echo "Cloning audiobookshelf branch: $RELEASE" && \
    git clone --depth=1 --branch "$RELEASE" https://github.com/advplyr/audiobookshelf.git src
WORKDIR /client
RUN npm ci && npm cache clean --force
RUN npm run generate

### STAGE 1: Build server ###
FROM node:20-alpine AS build-server

ARG NUSQLITE3_DIR
ARG TARGETPLATFORM

ENV NODE_ENV=production

WORKDIR /build
RUN apk add --no-cache --update git curl make python3 g++ unzip sed && \
    RELEASE="${AUDIOBOOKSHELF_RELEASE}" && \
    if [ -z "$RELEASE" ]; then \
      RELEASE=$(curl -sL "https://api.github.com/repos/advplyr/audiobookshelf/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'); \
    fi && \
    echo "Cloning audiobookshelf branch: $RELEASE" && \
    git clone --depth=1 --branch "$RELEASE" https://github.com/advplyr/audiobookshelf.git src

WORKDIR /server
RUN case "$TARGETPLATFORM" in \
      "linux/amd64") curl -L -o /tmp/library.zip "https://github.com/mikiher/nunicode-sqlite/releases/download/v1.2/libnusqlite3-linux-musl-x64.zip" ;; \
      "linux/arm64") curl -L -o /tmp/library.zip "https://github.com/mikiher/nunicode-sqlite/releases/download/v1.2/libnusqlite3-linux-musl-arm64.zip" ;; \
      *) echo "Unsupported platform: $TARGETPLATFORM" && exit 1 ;; \
    esac && \
    unzip /tmp/library.zip -d $NUSQLITE3_DIR && \
    rm /tmp/library.zip

RUN npm ci --only=production

### STAGE 2: LSIO-Style Final Image ###
FROM ghcr.io/linuxserver/baseimage-alpine:3.22

LABEL maintainer="Mildman1848"
LABEL org.opencontainers.image.source="https://github.com/advplyr/audiobookshelf"
LABEL org.opencontainers.image.description="Audiobookshelf container (LSIO style) based on Alpine, with s6-overlay, abc user, Docker Secrets, EN/DE."

ARG NUSQLITE3_DIR
ARG NUSQLITE3_PATH

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:de_DE" \
    LC_ALL="en_US.UTF-8" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PORT=80 \
    NODE_ENV=production \
    CONFIG_PATH="/config" \
    METADATA_PATH="/metadata" \
    SOURCE="docker" \
    NUSQLITE3_DIR=${NUSQLITE3_DIR} \
    NUSQLITE3_PATH=${NUSQLITE3_PATH}

RUN apk add --no-cache --update tzdata ffmpeg tini su-exec

WORKDIR /app

# Copy compiled frontend and server from build stages
COPY --from=build-client /client/dist /app/client/dist
COPY --from=build-server /server /app
COPY --from=build-server ${NUSQLITE3_PATH} ${NUSQLITE3_PATH}

# Add s6-overlay service, secrets etc.
COPY root/ /

RUN chmod -R +x /etc/ || true \
    && find /etc/ -type f -exec dos2unix {} \; \
    && chown -R abc:abc /app

EXPOSE 80
VOLUME /config /metadata

ENV PORT=80
ENV NODE_ENV=production
ENV CONFIG_PATH="/config"
ENV METADATA_PATH="/metadata"
ENV SOURCE="docker"
ENV NUSQLITE3_DIR=${NUSQLITE3_DIR}
ENV NUSQLITE3_PATH=${NUSQLITE3_PATH}

USER abc
ENTRYPOINT ["/init"]
