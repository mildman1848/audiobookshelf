# ./Dockerfile

# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
ARG AUDIOBOOKSHELF_RELEASE

LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Mildman1848"

# environment settings
ENV LANG="en_US.UTF-8" \
  LANGUAGE="en_US:de_DE" \
  LC_ALL="en_US.UTF-8" \
  TMPDIR=/run/audiobookshelf-temp \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    ffmpeg \
    nodejs \
    npm \
    git \
    curl \
    ca-certificates && \
  echo "**** install audiobookshelf ****" && \
  mkdir -p /app/audiobookshelf && \
  if [ -z ${AUDIOBOOKSHELF_RELEASE+x} ]; then \
    AUDIOBOOKSHELF_RELEASE=$(curl -sL "https://api.github.com/repos/advplyr/audiobookshelf/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'); \
  fi && \
  git clone --depth=1 --branch ${AUDIOBOOKSHELF_RELEASE} https://github.com/advplyr/audiobookshelf.git /app/audiobookshelf && \
  cd /app/audiobookshelf && \
  npm ci --omit=dev && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

# copy local files (s6-overlay service/init, etc.)
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
