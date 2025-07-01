# ./Dockerfile

# English: LSIO-style Dockerfile for Audiobookshelf – pulls app code at build time, uses Alpine + s6-overlay, Docker Secrets, abc user, EN/DE ready.
# Deutsch: LSIO-Style Dockerfile für Audiobookshelf – zieht App-Code beim Build, nutzt Alpine + s6-overlay, Docker Secrets, User abc, EN/DE-fähig.

FROM alpine:3.22

LABEL maintainer="Mildman1848 <mildman@mailbox.org>"
LABEL org.opencontainers.image.source="https://github.com/advplyr/audiobookshelf"
LABEL org.opencontainers.image.description="Audiobookshelf container (linuxserver.io style), Alpine + s6-overlay, Docker Secrets, EN/DE."

# --- Environment ---
ENV LANG="en_US.UTF-8" \
  LANGUAGE="en_US:de_DE" \
  LC_ALL="en_US.UTF-8" \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  PUID=911 \
  PGID=911 \
  APP_VERSION=v2.15.0 

# --- Install dependencies ---
RUN apk add --no-cache \
  nodejs \
  npm \
  ffmpeg \
  su-exec \
  curl \
  ca-certificates \
  bash \
  git \
  tzdata

# --- Install s6-overlay (v3) ---
ENV S6_OVERLAY_VERSION=v3.1.6.2

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
  tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
  rm -f /tmp/s6-overlay-*.tar.xz

# --- Add user/group abc ---
RUN addgroup -g 911 abc && adduser -D -u 911 -G abc abc

# --- Pull Audiobookshelf source code (GitHub Release, ohne Fork!) ---
WORKDIR /app
RUN git clone --depth=1 --branch ${APP_VERSION} https://github.com/advplyr/audiobookshelf.git . \
  && npm ci --omit=dev

# --- Copy LSIO-style init and service scripts ---
COPY ./root/ /

# --- Fix permissions for scripts (Windows/Git compatibility) ---
RUN chmod -R +x /etc/cont-init.d /etc/services.d || true

# --- Set permissions for app ---
RUN chown -R abc:abc /app

# --- Expose default port (as in upstream, Audiobookshelf listens on 80 by default) ---
EXPOSE 80

# --- Set working directory ---
WORKDIR /app

# --- Set s6-overlay as entrypoint (linuxserver.io style) ---
ENTRYPOINT ["/init"]

# --- Default user ---
USER abc
