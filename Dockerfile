# syntax=docker/dockerfile:1

# Use official audiobookshelf image as base
FROM advplyr/audiobookshelf:2.29.0 AS audiobookshelf-base

# Build our custom image based on LinuxServer.io
FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# Set version and security labels
ARG BUILD_DATE
ARG VERSION
ARG VCS_REF
ARG AUDIOBOOKSHELF_VERSION=v2.29.0

# Security: OCI-compliant labels
LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.source="https://github.com/mildman1848/audiobookshelf" \
      org.opencontainers.image.title="Audiobookshelf (Mildman1848 Build)" \
      org.opencontainers.image.description="Self-hosted audiobook and podcast server based on LinuxServer.io Alpine with enhanced security and Docker Secrets support" \
      org.opencontainers.image.vendor="mildman1848" \
      org.opencontainers.image.licenses="GPL-3.0" \
      org.opencontainers.image.authors="mildman1848" \
      org.opencontainers.image.url="https://github.com/mildman1848/audiobookshelf" \
      org.opencontainers.image.documentation="https://github.com/mildman1848/audiobookshelf/blob/main/README.md" \
      io.mildman1848.audiobookshelf.version="${AUDIOBOOKSHELF_VERSION}" \
      io.mildman1848.branding="custom" \
      io.linuxserver.baseimage="ghcr.io/linuxserver/baseimage-alpine:3.22" \
      io.linuxserver.s6-overlay="v3"

# LinuxServer.io standard environment variables
ENV HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    PUID=99 \
    PGID=100 \
    AUDIOBOOKSHELF_UID=911 \
    AUDIOBOOKSHELF_GID=911 \
    LSIO_FIRST_PARTY=false \
    VERSION=${VERSION:-latest} \
    BUILD_DATE=${BUILD_DATE:-unknown} \
    AUDIOBOOKSHELF_VERSION=${AUDIOBOOKSHELF_VERSION:-v2.29.0}

# Set shell for proper error handling and security
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3018
RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    curl \
    nodejs \
    npm \
    ffmpeg \
    shadow \
    su-exec && \
  echo "**** security: ensure abc user follows LinuxServer.io standards ****" && \
  groupmod -g 911 abc && \
  usermod -u 911 -d /config abc && \
  echo "**** create secure directory structure ****" && \
  mkdir -p \
    /app \
    /config \
    /defaults && \
  chmod 755 /app && \
  chmod 750 /config /defaults && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

# Copy audiobookshelf from official image with proper ownership
COPY --from=audiobookshelf-base --chown=abc:abc /app /app/
RUN chmod -R 755 /app && \
    test -f /app/index.js && \
    echo "✓ Audiobookshelf copied successfully"

# Copy S6 overlay services and scripts with proper ownership
COPY --chown=root:root root/ /

# Set proper permissions for S6 scripts (LinuxServer.io standard)
RUN find /etc/s6-overlay -name "run" -exec chmod 755 {} \; && \
    find /etc/s6-overlay -name "up" -exec chmod 755 {} \; && \
    find /etc/s6-overlay -name "finish" -exec chmod 755 {} \; && \
    chmod -R 755 /etc/s6-overlay/s6-rc.d

# Expose non-privileged port
EXPOSE 80

# Define volumes for persistent data
VOLUME ["/config", "/audiobooks", "/podcasts", "/metadata"]

# Enhanced health check following LinuxServer.io patterns
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:80/ping || curl -f http://localhost:80/ || exit 1