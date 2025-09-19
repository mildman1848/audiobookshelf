# LinuxServer.io Compliance Guide

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
- [FLAC to MP3 Converter](https://github.com/linuxserver/docker-mods/tree/audiobookshelf-flac2mp3)
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

## 🧪 Testing LinuxServer.io Compliance

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
- [FILE__ Prefix Documentation](https://docs.linuxserver.io/FAQ)
- [Docker Mods Repository](https://github.com/linuxserver/docker-mods)
- [Available Mods](https://mods.linuxserver.io/)
- [S6 Overlay Documentation](https://github.com/just-containers/s6-overlay)

## ✅ Compliance Checklist

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
- [x] **Custom container branding**
- [x] **LSIO_FIRST_PARTY=false setting**
- [x] **Clear support channel distinction**

**Status: ✅ FULLY COMPLIANT** with LinuxServer.io standards