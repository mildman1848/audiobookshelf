# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG AUDIOBOOKSHELF_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="mildman1848"

# --- Environment ---
ENV HOME="/config" \
  PYTHONIOENCODING=utf-8

# --- Install dependencies ---
RUN \
  apk add --no-cache \
  nodejs \
  npm \
  ffmpeg \
  su-exec \
  curl \
  ca-certificates \
  bash \
  git \
  tzdata \
  dos2unix

# --- Pull Audiobookshelf source code (GitHub Release, ohne Fork!) ---
WORKDIR /app
RUN git clone --depth=1 --branch ${APP_VERSION} https://github.com/advplyr/audiobookshelf.git . \
  && npm ci --omit=dev

# --- Copy LSIO-style init and service scripts ---
COPY root/ /

# --- Fix permissions and convert to Unix line endings (Windows compatibility) ---
RUN chmod -R +x /etc/cont-init.d /etc/services.d || true && \
    find /etc/cont-init.d/ -type f -exec dos2unix {} \; && \
    find /etc/services.d/ -type f -exec dos2unix {} \;

# --- Expose default port (as in upstream, Audiobookshelf listens on 80 by default) ---
EXPOSE 80
VOLUME /config
