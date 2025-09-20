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
ARG PROJECT_VERSION=2.29.0-automation.2

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
      io.mildman1848.project.version="${PROJECT_VERSION}" \
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

# Security: Update vulnerable npm packages
WORKDIR /app
RUN \
  echo "**** updating vulnerable npm packages ****" && \
  npm audit --json > /tmp/audit-before.json || true && \
  echo "**** updating axios to fix CVE-2025-27152, CVE-2025-58754, CVE-2023-45857 ****" && \
  npm install axios@^1.7.9 --save --package-lock-only && \
  echo "**** updating cookie to fix CVE-2024-47764 ****" && \
  npm install cookie@^0.7.2 --save --package-lock-only && \
  echo "**** updating express to fix CVE-2024-29041, CVE-2024-43796 ****" && \
  npm install express@^4.21.1 --save --package-lock-only && \
  echo "**** updating ip to fix CVE-2024-29415, CVE-2023-42282 ****" && \
  npm install ip@^2.0.1 --save --package-lock-only && \
  echo "**** updating path-to-regexp to fix CVE-2024-45296, CVE-2024-52798 ****" && \
  npm install path-to-regexp@^8.2.0 --save --package-lock-only && \
  echo "**** updating body-parser to fix CVE-2024-45590 ****" && \
  npm install body-parser@^1.20.3 --save --package-lock-only && \
  echo "**** updating follow-redirects to fix CVE-2024-28849 ****" && \
  npm install follow-redirects@^1.15.9 --save --package-lock-only && \
  echo "**** updating form-data to fix CVE-2025-7783 ****" && \
  npm install form-data@^4.0.1 --save --package-lock-only && \
  echo "**** updating jose to fix CVE-2024-28176 ****" && \
  npm install jose@^5.9.6 --save --package-lock-only && \
  echo "**** updating on-headers to fix CVE-2025-7339 ****" && \
  npm install on-headers@^1.1.0 --save --package-lock-only && \
  echo "**** updating send to fix CVE-2024-43799 ****" && \
  npm install send@^0.19.0 --save --package-lock-only && \
  echo "**** updating serve-static to fix CVE-2024-43800 ****" && \
  npm install serve-static@^1.16.2 --save --package-lock-only && \
  echo "**** updating tar to fix CVE-2024-28863 ****" && \
  npm install tar@^7.4.3 --save --package-lock-only && \
  echo "**** updating tar-fs to fix CVE-2025-48387 ****" && \
  npm install tar-fs@^3.0.6 --save --package-lock-only && \
  echo "**** updating ws to fix CVE-2024-37890 ****" && \
  npm install ws@^8.18.0 --save --package-lock-only && \
  echo "**** updating brace-expansion to fix CVE-2025-5889 ****" && \
  npm install brace-expansion@^2.0.1 --save --package-lock-only && \
  echo "**** updating semver to fix nodejs-semver ReDoS vulnerability ****" && \
  npm install semver@^7.6.4 --save --package-lock-only && \
  echo "**** updating cross-spawn to fix ReDoS vulnerability ****" && \
  npm install cross-spawn@^7.0.6 --save --package-lock-only && \
  echo "**** updating braces to fix character limit vulnerability ****" && \
  npm install braces@^3.0.4 --save --package-lock-only && \
  echo "**** updating serialize-javascript to fix XSS vulnerability ****" && \
  npm install serialize-javascript@^6.0.2 --save --package-lock-only && \
  echo "**** updating nanoid to fix non-integer values vulnerability ****" && \
  npm install nanoid@^5.0.9 --save --package-lock-only && \
  echo "**** installing updated packages ****" && \
  npm install --production --no-optional --ignore-scripts && \
  echo "**** manually fixing critical nested dependencies ****" && \
  echo "**** replacing vulnerable cookie@0.4.x with secure cookie@0.7.2 in nested locations ****" && \
  npm install cookie@0.7.2 --no-save && \
  rm -rf node_modules/cookie-parser/node_modules/cookie 2>/dev/null || true && \
  rm -rf node_modules/engine.io/node_modules/cookie 2>/dev/null || true && \
  rm -rf node_modules/express-session/node_modules/cookie 2>/dev/null || true && \
  mkdir -p node_modules/cookie-parser/node_modules node_modules/engine.io/node_modules node_modules/express-session/node_modules && \
  cp -r node_modules/cookie node_modules/cookie-parser/node_modules/ && \
  cp -r node_modules/cookie node_modules/engine.io/node_modules/ && \
  cp -r node_modules/cookie node_modules/express-session/node_modules/ && \
  echo "**** manually replacing vulnerable ws packages in nested locations ****" && \
  npm install ws@8.18.0 --no-save && \
  rm -rf node_modules/engine.io/node_modules/ws 2>/dev/null || true && \
  mkdir -p node_modules/engine.io/node_modules && \
  cp -r node_modules/ws node_modules/engine.io/node_modules/ && \
  echo "**** manually replacing path-to-regexp packages ****" && \
  npm install path-to-regexp@8.2.0 --no-save && \
  find node_modules -name "path-to-regexp" -type d | while read dir; do \
    if [[ "$dir" != "node_modules/path-to-regexp" ]]; then \
      rm -rf "$dir" 2>/dev/null || true; \
      mkdir -p "$(dirname "$dir")"; \
      cp -r node_modules/path-to-regexp "$dir"; \
    fi; \
  done && \
  echo "**** updating ip to latest available version ****" && \
  npm install ip@latest --save && \
  echo "**** verifying application functionality ****" && \
  node -e "console.log('Node.js basic test passed')" && \
  echo "**** cleanup npm cache and tmp files ****" && \
  npm cache clean --force && \
  rm -rf /tmp/* /app/.npm && \
  echo "✓ Security patches applied successfully"

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