# LinuxServer.io Compliance Guide

> 🇬🇧 **English Version** | 📖 **[Deutsche Version](LINUXSERVER.de.md)**

This document outlines how this Audiobookshelf Docker image fully complies with LinuxServer.io standards and best practices.

## ✅ Implemented LinuxServer.io Standards

### S6 Overlay v3
- **✅ Complete S6 v3 implementation**
- **✅ Proper service dependencies**
- **✅ Standard init process**

### FILE__ Prefix Secrets
- **✅ Full FILE__ environment variable support**
- **✅ Automatic secret processing**
- **✅ Backwards compatibility with legacy secrets**

### Docker Mods Support
- **✅ DOCKER_MODS environment variable**
- **✅ Multiple mod support (pipe-separated)**
- **✅ Standard mod installation process**

### Custom Scripts & Services
- **✅ /custom-cont-init.d support**
- **✅ /custom-services.d support**
- **✅ Proper execution order**

### User Management
- **✅ PUID/PGID support**
- **✅ abc user (UID 911)**
- **✅ Dynamic user ID changes**

### UMASK Support
- **✅ UMASK environment variable**
- **✅ Default UMASK=022**
- **✅ Applied to all file operations**

### Container Branding
- **✅ Custom branding file implementation**
- **✅ LSIO_FIRST_PARTY=false set**
- **✅ Clear distinction from official LinuxServer.io containers**
- **✅ Custom ASCII art for "Mildman1848"**
- **✅ Proper support channel references**

### OCI Manifest Lists & Multi-Architecture Pipeline
- **✅ OCI Image Manifest Specification v1.1.0 compliance**
- **✅ LinuxServer.io pipeline standards implementation**
- **✅ Architecture-specific tags (amd64-latest, arm64-latest, arm-v7-latest)**
- **✅ Native multi-platform builds (no emulation)**
- **✅ Automated manifest list creation and validation**
- **✅ GitHub Actions CI/CD with manifest support**

## 📋 Service Execution Order

```
1. base (LinuxServer.io baseimage)
2. init-branding (Custom branding setup)
3. init-mods-package-install (Docker Mods)
4. init-custom-files (Custom Scripts & UMASK)
5. init-secrets (FILE__ processing)
6. init-audiobookshelf-config (App configuration)
7. audiobookshelf (Main application)
```

## 🔐 Secrets Management

### FILE__ Prefix (Recommended)
```bash
# Environment Variables
FILE__JWT_SECRET=/run/secrets/jwt_secret
FILE__API_KEY=/run/secrets/api_key
FILE__DB_PASSWORD=/run/secrets/db_password

# Docker Compose
environment:
  - FILE__JWT_SECRET=/run/secrets/jwt_secret
```

### Legacy Docker Secrets (Backwards Compatible)
```yaml
secrets:
  - audiobookshelf_jwt_secret
  - audiobookshelf_api_key
```

## 🔧 Docker Mods Usage

### Single Mod
```bash
DOCKER_MODS=linuxserver/mods:universal-cron
```

### Multiple Mods
```bash
DOCKER_MODS=linuxserver/mods:universal-cron|linuxserver/mods:audiobookshelf-flac2mp3
```

### Available Mods
- [Universal Cron](https://github.com/linuxserver/docker-mods/tree/universal-cron)
- [Custom Mods](https://mods.linuxserver.io/)

## 📁 Custom Scripts

### Custom Init Scripts
Place executable scripts in `/custom-cont-init.d`:

```bash
# Mount custom scripts
volumes:
  - ./my-custom-scripts:/custom-cont-init.d:ro
```

Example script (`./my-custom-scripts/install-packages.sh`):
```bash
#!/bin/bash
# Install additional packages
apk add --no-cache rsync
echo "Custom packages installed"
```

### Custom Services
Place service definitions in `/custom-services.d`:

```bash
# Mount custom services
volumes:
  - ./my-custom-services:/custom-services.d:ro
```

## 🛡️ Security Compliance

### Non-Root Execution
- Runs as `abc` user (UID 911)
- No root processes after init
- Proper file permissions

### Capability Management
- Minimal capabilities
- no-new-privileges flag
- Security-opt configurations

### File System Security
- UMASK enforcement
- Proper ownership management
- Secure secret handling

## 🏗️ OCI Manifest Lists & Multi-Architecture Support

### LinuxServer.io Pipeline Implementation

**Architecture-Specific Tags (LinuxServer.io Style):**
```bash
# Pull specific architecture images
docker pull mildman1848/audiobookshelf:amd64-latest    # Intel/AMD 64-bit
docker pull mildman1848/audiobookshelf:arm64-latest    # ARM 64-bit (Apple M1, Pi 4)
docker pull mildman1848/audiobookshelf:arm-v7-latest   # ARM 32-bit (Pi 3)

# Automatic platform selection
docker pull mildman1848/audiobookshelf:latest          # Docker selects optimal image
```

**OCI Manifest List Structure:**
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
    },
    {
      "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
      "platform": { "architecture": "arm", "variant": "v7", "os": "linux" }
    }
  ]
}
```

**Build Process (2024 Pipeline Standards):**
```bash
# LinuxServer.io style manifest build
make build-manifest

# Inspect manifest lists
make inspect-manifest

# Validate OCI compliance
make validate-manifest
```

## 🧪 Testing LinuxServer.io Compliance

### Test Manifest Lists
```bash
# Test manifest list structure
docker manifest inspect mildman1848/audiobookshelf:latest

# Test platform-specific pulls
docker pull --platform linux/amd64 mildman1848/audiobookshelf:latest
docker pull --platform linux/arm64 mildman1848/audiobookshelf:latest
docker pull --platform linux/arm/v7 mildman1848/audiobookshelf:latest
```

### Test FILE__ Secrets
```bash
# Test FILE__ environment variable processing
docker run --rm -e FILE__TEST_VAR=/tmp/test mildman1848/audiobookshelf:latest \
  sh -c 'echo "test-value" > /tmp/test && env | grep TEST_VAR'
```

### Test Docker Mods
```bash
# Test mod installation (dry-run)
docker run --rm -e DOCKER_MODS=linuxserver/mods:universal-cron \
  mildman1848/audiobookshelf:latest echo "Mod test"
```

### Test Custom Scripts
```bash
# Test custom script execution
echo '#!/bin/bash\necho "Custom script executed"' > test-script.sh
chmod +x test-script.sh
docker run --rm -v $(pwd):/custom-cont-init.d:ro \
  mildman1848/audiobookshelf:latest
```

## 📚 References

- [LinuxServer.io Documentation](https://docs.linuxserver.io/)
- [LinuxServer.io Pipeline Project](https://www.linuxserver.io/blog/2019-02-21-the-lsio-pipeline-project)
- [FILE__ Prefix Documentation](https://docs.linuxserver.io/FAQ)
- [Docker Mods Repository](https://github.com/linuxserver/docker-mods)
- [Available Mods](https://mods.linuxserver.io/)
- [S6 Overlay Documentation](https://github.com/just-containers/s6-overlay)
- [OCI Distribution Specification](https://distribution.github.io/distribution/spec/manifest-v2-2/#manifest-list)
- [Docker Multi-Platform Images](https://docs.docker.com/build/building/multi-platform/)

## ✅ Compliance Checklist

### Core LinuxServer.io Standards
- [x] S6 Overlay v3 implementation
- [x] FILE__ prefix secret support
- [x] Docker Mods support (DOCKER_MODS)
- [x] Custom scripts (/custom-cont-init.d)
- [x] Custom services (/custom-services.d)
- [x] PUID/PGID user management
- [x] UMASK support
- [x] abc user (UID 911)
- [x] Non-root execution
- [x] Proper service dependencies
- [x] LinuxServer.io baseimage
- [x] Standard environment variables
- [x] Security best practices
- [x] Backwards compatibility

### Advanced Pipeline Standards (2024)
- [x] **OCI Image Manifest Specification v1.1.0 compliance**
- [x] **LinuxServer.io Pipeline multi-architecture support**
- [x] **Architecture-specific tags (amd64, arm64, arm-v7)**
- [x] **Manifest list creation and validation**
- [x] **Native platform builds (no emulation)**
- [x] **GitHub Actions CI/CD with manifest support**
- [x] **Custom container branding**
- [x] **LSIO_FIRST_PARTY=false setting**
- [x] **Clear support channel distinction**

**Status: ✅ FULLY COMPLIANT** with LinuxServer.io standards & 2024 Pipeline best practices