# Audiobookshelf - LinuxServer.io Edition

🇩🇪 **German Version:** [README.DE.md](README.DE.md)

[![GitHub Release](https://img.shields.io/github/v/release/mildman1848/audiobookshelf?style=for-the-badge&logo=github&color=005AA4)](https://github.com/mildman1848/audiobookshelf/releases)
[![Docker Hub Pulls](https://img.shields.io/docker/pulls/mildman1848/audiobookshelf?style=for-the-badge&logo=docker&logoColor=fff&color=005AA4)](https://hub.docker.com/r/mildman1848/audiobookshelf)
[![Docker Image Size](https://img.shields.io/docker/image-size/mildman1848/audiobookshelf/latest?style=for-the-badge&logo=docker&logoColor=fff&color=005AA4)](https://hub.docker.com/r/mildman1848/audiobookshelf)
[![License](https://img.shields.io/github/license/mildman1848/audiobookshelf?style=for-the-badge&color=005AA4)](https://github.com/mildman1848/audiobookshelf/blob/main/LICENSE)

[![CI Status](https://img.shields.io/github/actions/workflow/status/mildman1848/audiobookshelf/ci.yml?branch=main&style=flat-square&logo=github&label=CI)](https://github.com/mildman1848/audiobookshelf/actions/workflows/ci.yml)
[![Security Scan](https://img.shields.io/github/actions/workflow/status/mildman1848/audiobookshelf/security.yml?branch=main&style=flat-square&logo=security&label=Security)](https://github.com/mildman1848/audiobookshelf/actions/workflows/security.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/mildman1848/audiobookshelf/codeql.yml?branch=main&style=flat-square&logo=github&label=CodeQL)](https://github.com/mildman1848/audiobookshelf/actions/workflows/codeql.yml)
[![Upstream Version](https://img.shields.io/badge/audiobookshelf-v2.30.0-blue?style=flat-square&logo=github)](https://github.com/advplyr/audiobookshelf/releases/tag/v2.30.0)

---

**Self-hosted audiobook and podcast server based on LinuxServer.io Alpine baseimage.**

## 📦 Available Registries

The audiobookshelf container is available on multiple registries:

```bash
# Docker Hub (recommended)
docker pull mildman1848/audiobookshelf:latest
docker pull mildman1848/audiobookshelf:2.30.0

# GitHub Container Registry
docker pull ghcr.io/mildman1848/audiobookshelf:latest
docker pull ghcr.io/mildman1848/audiobookshelf:2.30.0

# GitLab Container Registry
docker pull registry.gitlab.com/mildman1848/audiobookshelf:latest
docker pull registry.gitlab.com/mildman1848/audiobookshelf:2.30.0

# Codeberg Container Registry
docker pull codeberg.org/mildman1848/audiobookshelf:latest
docker pull codeberg.org/mildman1848/audiobookshelf:2.30.0
```

**Multi-Architecture Support:** All images support `linux/amd64` and `linux/arm64`

## Quick Start

```bash
# Complete setup (creates .env and generates secrets)
make setup

# Or manual setup:
mkdir -p data/audiobooks data/podcasts
cp .env.example .env
make secrets-generate

# Build and start
make build
make start
```

Access at: http://localhost:13378

## 🔐 Secret Management

This container follows LinuxServer.io best practices for secret management using the `FILE__` prefix pattern.

### Generate Secrets

```bash
# Generate all required secrets
make secrets-generate

# View secret information
make secrets-info

# Rotate secrets (creates backup)
make secrets-rotate

# Clean old backups (keeps last 5)
make secrets-clean
```

### Generated Secrets

- **JWT Secret** (512-bit): Authentication token signing
- **Session Secret** (256-bit): Session management
- **API Key** (256-bit): API authentication

### How FILE__ Secrets Work

The LinuxServer.io `init-secrets` service reads environment variables with the `FILE__` prefix:

```yaml
# In docker-compose.yml
environment:
  - FILE__TOKEN_SECRET=/run/secrets/audiobookshelf_jwt_secret
```

At container startup, the value from the file is read and made available as `TOKEN_SECRET` (without `FILE__` prefix).

⚠️ **Security**:
- Never commit `secrets/` directory to version control
- Secrets are generated with cryptographically secure random data
- Secret files have `600` permissions (owner read/write only)

## 🪟 Windows Docker Desktop Compatibility

**✅ WORKING**: Bind mounts are fully supported on Windows Docker Desktop!

The previous EPERM errors were caused by strict security options, not by bind mounts themselves. The solution:

- ✅ **Bind mount for `/config`** - Config directory is accessible on host
- ✅ **Migrations pre-copied** - Stored in `/defaults/migrations` and copied at startup
- ✅ **Security options adjusted** - `no-new-privileges` and capability restrictions disabled for Windows compatibility

**For Linux Production**: You may re-enable security hardening by uncommenting the options in `docker-compose.override.yml`:
```yaml
security_opt:
  - no-new-privileges:true
cap_drop:
  - ALL
cap_add:
  - CHOWN
  - SETUID
  - SETGID
```

## Build & Test

```bash
make build          # Build image
make test           # Test container
make validate       # Validate Dockerfile
make security-scan  # Security scan
```

## Make Targets

```bash
make help            # Show all available targets
make setup           # Complete initial setup
make env-setup       # Create .env from .env.example
make env-validate    # Validate environment configuration
make secrets-generate # Generate secure secrets
make secrets-info    # Show secret information
make build           # Build Docker image
make start           # Start container
make stop            # Stop container
make restart         # Restart container
make status          # Show container status and health
make logs            # Show container logs
make shell           # Get shell access to container
```

## Original Project

Based on [Audiobookshelf](https://github.com/advplyr/audiobookshelf) by advplyr (GPL-3.0)

- Documentation: https://www.audiobookshelf.org/docs
- Support: https://github.com/advplyr/audiobookshelf/issues

Container maintained by mildman1848
