# Audiobookshelf Docker Image

> 📖 **[Deutsche Version](README.de.md)** | 🇬🇧 **English Version**

![Build Status](https://github.com/mildman1848/audiobookshelf/workflows/CI/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/mildman1848/audiobookshelf)
![Docker Image Size](https://img.shields.io/docker/image-size/mildman1848/audiobookshelf/latest)
![License](https://img.shields.io/github/license/mildman1848/audiobookshelf)

🐳 **[Docker Hub: mildman1848/audiobookshelf](https://hub.docker.com/r/mildman1848/audiobookshelf)**

A production-ready Docker image for [Audiobookshelf](https://www.audiobookshelf.org/) based on the LinuxServer.io Alpine baseimage with enhanced security features, automatic secret management, full LinuxServer.io compliance, and CI/CD integration.

## 🚀 Features

- ✅ **LinuxServer.io Alpine Baseimage 3.22** - Optimized and secure
- ✅ **S6 Overlay v3** - Professional process management
- ✅ **Full LinuxServer.io Compliance** - FILE__ secrets, Docker Mods, custom scripts
- ✅ **Enhanced Security Hardening** - Non-root execution, capability dropping, secure permissions
- ✅ **OCI Manifest Lists** - True multi-architecture support following OCI standard
- ✅ **LinuxServer.io Pipeline** - Architecture-specific tags + manifest lists
- ✅ **Multi-Platform Support** - AMD64, ARM64, ARMv7 with native performance
- ✅ **Advanced Health Checks** - Automatic monitoring with failover
- ✅ **Robust Secret Management** - 512-bit JWT, 256-bit API keys, secure rotation
- ✅ **Automated Build System** - Make + GitHub Actions CI/CD with manifest validation
- ✅ **Environment Validation** - Comprehensive configuration checks
- ✅ **Security Scanning** - Integrated vulnerability scans with Trivy
- ✅ **OCI Compliance** - Standard-compliant container labels and manifest structure

## 🚀 Quick Start

### Automated Setup (Recommended)

```bash
# Clone repository
git clone https://github.com/mildman1848/audiobookshelf.git
cd audiobookshelf

# Complete setup (environment + secrets)
make setup

# Start container
docker-compose up -d
```

### With Docker Compose (Manual)

```bash
# Clone repository
git clone https://github.com/mildman1848/audiobookshelf.git
cd audiobookshelf

# Configure environment
cp .env.example .env
# Adjust .env as needed

# Generate secure secrets
make secrets-generate

# Start container
docker-compose up -d
```

### With Docker Run

```bash
docker run -d \
  --name audiobookshelf \
  -p 13378:80 \
  -v /path/to/config:/config \
  -v /path/to/audiobooks:/audiobooks \
  -v /path/to/podcasts:/podcasts \
  -v /path/to/metadata:/metadata \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Berlin \
  --restart unless-stopped \
  mildman1848/audiobookshelf:latest
```

## 🛠️ Build & Development

### Makefile Targets

```bash
# Show help
make help

# Complete setup
make setup                   # Initial setup (env + secrets)
make env-setup               # Create environment from .env.example
make env-validate            # Validate environment

# Secret Management (Enhanced)
make secrets-generate        # Generate secure secrets (512-bit JWT, 256-bit API)
make secrets-rotate          # Rotate secrets (with backup)
make secrets-clean           # Clean up old secret backups
make secrets-info            # Show secret status

# Build & Test (Enhanced with OCI Manifest Lists)
make build                   # Build image for current platform
make build-multiarch         # Multi-architecture build (legacy)
make build-manifest          # LinuxServer.io style manifest lists (recommended)
make inspect-manifest        # Inspect manifest lists (multi-arch details)
make validate-manifest       # Validate OCI manifest compliance
make test                    # Test container (with health checks)
make security-scan           # Run security scan
make validate                # Validate Dockerfile

# Container Management
make start                   # Start container
make stop                    # Stop container
make restart                 # Restart container
make status                  # Show container status and health
make logs                    # Show container logs
make shell                   # Open shell in container

# Development
make dev                     # Start development container
make start-with-db           # Start with PostgreSQL database

# Release
make release                 # Complete release workflow
make push                    # Push image to registry
```

### Manual Build

```bash
# Build image
docker build -t mildman1848/audiobookshelf:latest .

# With specific arguments
docker build \
  --build-arg AUDIOBOOKSHELF_VERSION=v2.29.0 \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  -t mildman1848/audiobookshelf:latest .
```

## ⚙️ Configuration

### Environment File

Configuration is done via a `.env` file containing all environment variables:

```bash
# Create .env from template
cp .env.example .env

# Adjust values as needed
nano .env
```

The `.env.example` contains all available options with documentation and links to the official Audiobookshelf documentation.

### Important Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `Europe/Berlin` | Timezone |
| `PORT` | `80` | Internal container port |
| `EXTERNAL_PORT` | `13378` | External host port |
| `CONFIG_PATH` | `/config` | Configuration path in container |
| `METADATA_PATH` | `/metadata` | Metadata path in container |
| `LOG_LEVEL` | `info` | Log level (debug, info, warn, error) |

> 📖 **Full Documentation:** See [.env.example](.env.example) for all available options

### 🔐 Enhanced LinuxServer.io Secrets Management

**FILE__ Prefix (Recommended):**
The image supports the LinuxServer.io standard `FILE__` prefix for secure secret management:

```bash
# .env file - FILE__ prefix secrets
FILE__JWT_SECRET=/run/secrets/jwt_secret
FILE__API_KEY=/run/secrets/api_key
FILE__DB_PASSWORD=/run/secrets/db_password

# Docker Compose example
environment:
  - FILE__JWT_SECRET=/run/secrets/jwt_secret
```

**Enhanced Secret Generation:**

```bash
# Secure secret generation (improved algorithms)
make secrets-generate        # 512-bit JWT, 256-bit API keys

# Secret rotation with backup
make secrets-rotate

# Check secret status
make secrets-info
```

**Supported Secrets (Enhanced):**

| FILE__ Variable | Description | Security | Make Generated |
|----------------|-------------|----------|----------------|
| `FILE__JWT_SECRET` | JWT Secret Key (512-bit) | ✅ High | ✅ |
| `FILE__API_KEY` | API Key (256-bit hex) | ✅ High | ✅ |
| `FILE__DB_USER` | Database user | ✅ Standard | ✅ |
| `FILE__DB_PASSWORD` | Database password (256-bit) | ✅ High | ✅ |
| `FILE__SESSION_SECRET` | Session secret (256-bit) | ✅ High | ✅ |

> 📖 **LinuxServer.io Documentation:** [FILE__ Prefix](https://docs.linuxserver.io/FAQ)

### Volumes

| Container Path | Description |
|----------------|-------------|
| `/config` | Configuration files |
| `/audiobooks` | Audiobook library |
| `/podcasts` | Podcast library |
| `/metadata` | Metadata cache |

## 🔧 Enhanced LinuxServer.io S6 Overlay Services

The image uses S6 Overlay v3 with optimized services following LinuxServer.io standards:

- **init-branding** - Custom Mildman1848 ASCII art branding
- **init-mods-package-install** - Docker Mods installation
- **init-custom-files** - Custom scripts & UMASK setup
- **init-secrets** - Enhanced FILE__ prefix & legacy secret processing
- **init-audiobookshelf-config** - Audiobookshelf configuration with validation
- **audiobookshelf** - Main application with correct parameter passing

### Service Dependencies (Fixed)

```
init-branding → init-mods-package-install → init-custom-files → init-secrets → init-audiobookshelf-config → audiobookshelf
```

### Service Improvements
- ✅ **Secure Permissions** - Fallback methods for chmod issues
- ✅ **Enhanced Validation** - JSON config validation
- ✅ **Robust Error Handling** - Graceful fallbacks on errors
- ✅ **Security Hardening** - Path validation for FILE__ secrets

### LinuxServer.io Features

**Docker Mods Support:**
```bash
# Single mod
DOCKER_MODS=linuxserver/mods:universal-cron

# Multiple mods (separated by |)
DOCKER_MODS=linuxserver/mods:universal-cron|linuxserver/mods:audiobookshelf-flac2mp3
```

**Custom Scripts:**
```bash
# Scripts in /custom-cont-init.d are executed before services
docker run -v ./my-scripts:/custom-cont-init.d:ro mildman1848/audiobookshelf
```

**UMASK Support:**
```bash
# Default: 022 (files: 644, directories: 755)
UMASK=022
```

> 📖 **Available Mods:** [mods.linuxserver.io](https://mods.linuxserver.io/)

## 🔒 Enhanced Security

> 🛡️ **Security Policy**: See our [Security Policy](SECURITY.md) for reporting vulnerabilities and security guidelines

### Advanced Security Hardening

The image implements comprehensive security measures:

- ✅ **Non-root Execution** - Container runs as user `abc` (UID 911)
- ✅ **Capability Dropping** - ALL capabilities dropped, minimal required added
- ✅ **no-new-privileges** - Prevents privilege escalation
- ✅ **Secure File Permissions** - 750 for directories, 640 for files
- ✅ **Path Validation** - FILE__ secret path sanitization
- ✅ **Enhanced Error Handling** - Secure fallbacks for permission issues
- ✅ **tmpfs Mounts** - Temporary files in memory
- ✅ **Security Opt** - Additional kernel security features
- ✅ **Robust Secret Handling** - 512-bit encryption, secure rotation

### Security Scanning

```bash
# Automated security scan
make security-scan

# Manual Trivy scan
trivy image mildman1848/audiobookshelf:latest

# Dockerfile linting
make validate
```

### Best Practices

```bash
# 1. Use LinuxServer.io FILE__ secrets
FILE__JWT_SECRET=/run/secrets/jwt_secret
FILE__API_KEY=/run/secrets/api_key

# 2. Set host user IDs (LinuxServer.io standard)
export PUID=$(id -u)
export PGID=$(id -g)

# 3. UMASK for correct file permissions
export UMASK=022

# 4. Secure secret generation
make secrets-generate

# 5. Validate configuration
make env-validate

# 6. Use specific image tags
docker run mildman1848/audiobookshelf:v2.29.0  # instead of :latest

# 7. Monitor container health
make status  # Container status and health checks

# 8. Use enhanced secret management
make secrets-generate  # 512-bit JWT, 256-bit API keys
```

### OCI Manifest Lists & LinuxServer.io Pipeline

**OCI-compliant Multi-Architecture Support:**

```bash
# Automatic platform detection (Docker pulls the right image)
docker pull mildman1848/audiobookshelf:latest

# Platform-specific tags (LinuxServer.io style)
docker pull mildman1848/audiobookshelf:amd64-latest    # Intel/AMD 64-bit
docker pull mildman1848/audiobookshelf:arm64-latest    # ARM 64-bit (Apple M1, Pi 4)
docker pull mildman1848/audiobookshelf:arm-v7-latest   # ARM 32-bit (Pi 3)

# Inspect manifest lists
make inspect-manifest
docker manifest inspect mildman1848/audiobookshelf:latest
```

**Technical Details:**
- ✅ **OCI Image Manifest Specification v1.1.0** compliant
- ✅ **LinuxServer.io Pipeline Standards** - Architecture tags + manifest lists
- ✅ **Native Performance** - No emulation, real platform builds
- ✅ **Automatic Platform Selection** - Docker chooses optimal image
- ✅ **Backward Compatibility** - Works with all Docker clients

**Manifest Structure:**
```json
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.docker.distribution.manifest.list.v2+json",
  "manifests": [
    {
      "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
      "platform": { "architecture": "amd64", "os": "linux" }
    },
    {
      "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
      "platform": { "architecture": "arm64", "os": "linux" }
    }
  ]
}
```

### LinuxServer.io Compatibility

```bash
# Fully compatible with LinuxServer.io standards
# ✅ S6 Overlay v3
# ✅ FILE__ Prefix Secrets
# ✅ DOCKER_MODS Support
# ✅ Custom Scripts (/custom-cont-init.d)
# ✅ UMASK Support
# ✅ PUID/PGID Management
# ✅ Custom Branding (LinuxServer.io compliant)
# ✅ OCI Manifest Lists (2024 Pipeline Standard)
```

### 🎨 Container Branding

The container shows a **custom ASCII-art branding** for "Mildman1848" at startup:

```
███╗   ███╗██╗██╗     ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗ ██╗ █████╗ ██╗  ██╗ █████╗
████╗ ████║██║██║     ██╔══██╗████╗ ████║██╔══██╗████╗  ██║███║██╔══██╗██║  ██║██╔══██╗
██╔████╔██║██║██║     ██║  ██║██╔████╔██║███████║██╔██╗ ██║╚██║╚█████╔╝███████║╚█████╔╝
██║╚██╔╝██║██║██║     ██║  ██║██║╚██╔╝██║██╔══██║██║╚██╗██║ ██║██╔══██╗╚════██║██╔══██╗
██║ ╚═╝ ██║██║███████╗██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║ ██║╚█████╔╝     ██║╚█████╔╝
╚═╝     ╚═╝╚═╝╚══════╝╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═╝ ╚════╝      ╚═╝ ╚════╝
```

**Branding Features:**
- ✅ **LinuxServer.io Compliance** - Correct branding implementation
- ✅ **Custom ASCII Art** - Unique Mildman1848 representation
- ✅ **Version Information** - Build details and Audiobookshelf version
- ✅ **Support Links** - Clear references for help and documentation
- ✅ **Feature Overview** - Overview of implemented LinuxServer.io features

> ⚠️ **Note:** This container is **NOT** officially supported by LinuxServer.io

## Monitoring & Health Checks

### Health Check

The image includes automatic health checks:

```bash
# Check status
docker inspect --format='{{.State.Health.Status}}' audiobookshelf

# Show logs
docker logs audiobookshelf
```

### Prometheus Metrics (Optional)

Audiobookshelf can be monitored with Prometheus. See official documentation for details.

## 🔧 Troubleshooting

### Common Issues

<details>
<summary><strong>File Permissions</strong></summary>

```bash
# Adjust PUID/PGID to host user
export PUID=$(id -u)
export PGID=$(id -g)
docker-compose up -d

# Or set in .env
echo "PUID=$(id -u)" >> .env
echo "PGID=$(id -g)" >> .env
```
</details>

<details>
<summary><strong>Port Already in Use</strong></summary>

```bash
# Change port in .env
echo "EXTERNAL_PORT=13379" >> .env

# Or directly in docker-compose.yml
ports:
  - "13379:80"
```
</details>

<details>
<summary><strong>Container Won't Start</strong></summary>

```bash
# 1. Check logs
make logs

# 2. Health check status
docker inspect --format='{{.State.Health.Status}}' audiobookshelf

# 3. Validate environment
make env-validate

# 4. Debug shell
make shell
```
</details>

<details>
<summary><strong>Secrets Not Found</strong></summary>

```bash
# Use LinuxServer.io FILE__ secrets
echo "FILE__JWT_SECRET=/run/secrets/jwt_secret" >> .env

# Generate legacy secrets
make secrets-generate

# Check secret status
make secrets-info

# Manual FILE__ secret creation
mkdir -p secrets
openssl rand -base64 64 > secrets/jwt_secret.txt
echo "FILE__JWT_SECRET=$(pwd)/secrets/jwt_secret.txt" >> .env
```
</details>

### Debug Mode

```bash
# Development container with debug logging
echo "LOG_LEVEL=debug" >> .env
echo "DEBUG_MODE=true" >> .env
echo "VERBOSE_LOGGING=true" >> .env
make dev

# Shell access
make shell

# Container inspection
docker exec -it audiobookshelf /bin/bash
```

## 🤝 Contributing

### Development Workflow

1. **Fork & Clone**
   ```bash
   git clone https://github.com/yourusername/audiobookshelf.git
   cd audiobookshelf
   ```

2. **Setup Development Environment**
   ```bash
   make setup
   make dev
   ```

3. **Make Changes & Test**
   ```bash
   make validate      # Dockerfile linting
   make build         # Build image
   make test          # Run tests
   make security-scan # Security check
   ```

4. **Submit PR**
   - Create a feature branch
   - Test all changes
   - Create a pull request

> 🛡️ **Security Issues**: Please read our [Security Policy](SECURITY.md) before reporting security vulnerabilities

### CI/CD Pipeline

The project uses GitHub Actions for:
- ✅ **Automated Testing** - Dockerfile, container, integration tests
- ✅ **Security Scanning** - Trivy, Hadolint, SBOM generation
- ✅ **OCI Manifest Lists** - LinuxServer.io pipeline with architecture-specific tags
- ✅ **Multi-Architecture Builds** - AMD64, ARM64, ARMv7 with native performance
- ✅ **Manifest Validation** - OCI compliance and platform verification
- ✅ **Automated Releases** - Semantic versioning, Docker Hub/GHCR
- ✅ **Dependency Updates** - Dependabot integration

## License

This project is licensed under the GPL-3.0 License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- [Audiobookshelf](https://github.com/advplyr/audiobookshelf) - Original project
- [LinuxServer.io](https://www.linuxserver.io/) - Baseimage and best practices
- [S6 Overlay](https://github.com/just-containers/s6-overlay) - Process management