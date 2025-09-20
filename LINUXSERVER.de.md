# LinuxServer.io Compliance Guide

> 🇩🇪 **Deutsche Version** | 📖 **[English Version](LINUXSERVER.md)**

Dieses Dokument beschreibt, wie dieses Audiobookshelf Docker Image vollständig den LinuxServer.io Standards und Best Practices entspricht.

## ✅ Implementierte LinuxServer.io Standards

### S6 Overlay v3
- **✅ Vollständige S6 v3 Implementierung**
- **✅ Korrekte Service-Abhängigkeiten**
- **✅ Standard Init-Prozess**

### FILE__ Prefix Secrets
- **✅ Vollständige FILE__ Umgebungsvariablen-Unterstützung**
- **✅ Automatische Secret-Verarbeitung**
- **✅ Rückwärtskompatibilität mit Legacy Secrets**

### Docker Mods Support
- **✅ DOCKER_MODS Umgebungsvariable**
- **✅ Mehrfach-Mod-Unterstützung (Pipe-getrennt)**
- **✅ Standard Mod-Installationsprozess**

### Custom Scripts & Services
- **✅ /custom-cont-init.d Unterstützung**
- **✅ /custom-services.d Unterstützung**
- **✅ Korrekte Ausführungsreihenfolge**

### User Management
- **✅ PUID/PGID Unterstützung**
- **✅ abc User (UID 911)**
- **✅ Dynamische User ID Änderungen**

### UMASK Support
- **✅ UMASK Umgebungsvariable**
- **✅ Standard UMASK=022**
- **✅ Angewendet auf alle Dateioperationen**

### Container Branding
- **✅ Custom Branding Datei-Implementierung**
- **✅ LSIO_FIRST_PARTY=false gesetzt**
- **✅ Klare Unterscheidung von offiziellen LinuxServer.io Containern**
- **✅ Custom ASCII Art für "Mildman1848"**
- **✅ Korrekte Support-Kanal-Verweise**

### OCI Manifest Lists & Multi-Architecture Pipeline
- **✅ OCI Image Manifest Specification v1.1.0 Konformität**
- **✅ LinuxServer.io Pipeline Standards Implementierung**
- **✅ Architecture-spezifische Tags (amd64-latest, arm64-latest, arm-v7-latest)**
- **✅ Native Multi-Platform Builds (keine Emulation)**
- **✅ Automatisierte Manifest List Erstellung und Validierung**
- **✅ GitHub Actions CI/CD mit Manifest Support**

## 📋 Service Ausführungsreihenfolge

```
1. base (LinuxServer.io Baseimage)
2. init-branding (Custom Branding Setup)
3. init-mods-package-install (Docker Mods)
4. init-custom-files (Custom Scripts & UMASK)
5. init-secrets (FILE__ Verarbeitung)
6. init-audiobookshelf-config (App Konfiguration)
7. audiobookshelf (Hauptanwendung)
```

## 🔐 Secrets Management

### FILE__ Prefix (Empfohlen)
```bash
# Umgebungsvariablen
FILE__JWT_SECRET=/run/secrets/jwt_secret
FILE__API_KEY=/run/secrets/api_key
FILE__DB_PASSWORD=/run/secrets/db_password

# Docker Compose
environment:
  - FILE__JWT_SECRET=/run/secrets/jwt_secret
```

### Legacy Docker Secrets (Rückwärtskompatibel)
```yaml
secrets:
  - audiobookshelf_jwt_secret
  - audiobookshelf_api_key
```

## 🔧 Docker Mods Verwendung

### Einzelne Mod
```bash
DOCKER_MODS=linuxserver/mods:universal-cron
```

### Mehrere Mods
```bash
DOCKER_MODS=linuxserver/mods:universal-cron|linuxserver/mods:audiobookshelf-flac2mp3
```

### Verfügbare Mods
- [Universal Cron](https://github.com/linuxserver/docker-mods/tree/universal-cron)
- [Custom Mods](https://mods.linuxserver.io/)

## 📁 Custom Scripts

### Custom Init Scripts
Platziere ausführbare Scripts in `/custom-cont-init.d`:

```bash
# Custom Scripts mounten
volumes:
  - ./my-custom-scripts:/custom-cont-init.d:ro
```

Beispiel Script (`./my-custom-scripts/install-packages.sh`):
```bash
#!/bin/bash
# Zusätzliche Pakete installieren
apk add --no-cache rsync
echo "Custom Pakete installiert"
```

### Custom Services
Platziere Service-Definitionen in `/custom-services.d`:

```bash
# Custom Services mounten
volumes:
  - ./my-custom-services:/custom-services.d:ro
```

## 🛡️ Security Compliance

### Non-Root Ausführung
- Läuft als `abc` User (UID 911)
- Keine Root-Prozesse nach Init
- Korrekte Dateiberechtigungen

### Capability Management
- Minimale Capabilities
- no-new-privileges Flag
- Security-opt Konfigurationen

### File System Security
- UMASK Durchsetzung
- Korrektes Ownership Management
- Sichere Secret-Behandlung

## 🏗️ OCI Manifest Lists & Multi-Architecture Support

### LinuxServer.io Pipeline Implementierung

**Architecture-Spezifische Tags (LinuxServer.io Style):**
```bash
# Spezifische Architecture Images ziehen
docker pull mildman1848/audiobookshelf:amd64-latest    # Intel/AMD 64-bit
docker pull mildman1848/audiobookshelf:arm64-latest    # ARM 64-bit (Apple M1, Pi 4)
docker pull mildman1848/audiobookshelf:arm-v7-latest   # ARM 32-bit (Pi 3)

# Automatische Platform-Auswahl
docker pull mildman1848/audiobookshelf:latest          # Docker wählt optimales Image
```

**OCI Manifest List Struktur:**
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

**Build-Prozess (2024 Pipeline Standards):**
```bash
# LinuxServer.io Style Manifest Build
make build-manifest

# Manifest Lists inspizieren
make inspect-manifest

# OCI Compliance validieren
make validate-manifest
```

## 🧪 LinuxServer.io Compliance Testing

### Manifest Lists testen
```bash
# Manifest List Struktur testen
docker manifest inspect mildman1848/audiobookshelf:latest

# Platform-spezifische Pulls testen
docker pull --platform linux/amd64 mildman1848/audiobookshelf:latest
docker pull --platform linux/arm64 mildman1848/audiobookshelf:latest
docker pull --platform linux/arm/v7 mildman1848/audiobookshelf:latest
```

### FILE__ Secrets testen
```bash
# FILE__ Umgebungsvariablen-Verarbeitung testen
docker run --rm -e FILE__TEST_VAR=/tmp/test mildman1848/audiobookshelf:latest \
  sh -c 'echo "test-value" > /tmp/test && env | grep TEST_VAR'
```

### Docker Mods testen
```bash
# Mod Installation testen (Dry-Run)
docker run --rm -e DOCKER_MODS=linuxserver/mods:universal-cron \
  mildman1848/audiobookshelf:latest echo "Mod Test"
```

### Custom Scripts testen
```bash
# Custom Script Ausführung testen
echo '#!/bin/bash\necho "Custom Script ausgeführt"' > test-script.sh
chmod +x test-script.sh
docker run --rm -v $(pwd):/custom-cont-init.d:ro \
  mildman1848/audiobookshelf:latest
```

## 📚 Referenzen

- [LinuxServer.io Dokumentation](https://docs.linuxserver.io/)
- [LinuxServer.io Pipeline Projekt](https://www.linuxserver.io/blog/2019-02-21-the-lsio-pipeline-project)
- [FILE__ Prefix Dokumentation](https://docs.linuxserver.io/FAQ)
- [Docker Mods Repository](https://github.com/linuxserver/docker-mods)
- [Verfügbare Mods](https://mods.linuxserver.io/)
- [S6 Overlay Dokumentation](https://github.com/just-containers/s6-overlay)
- [OCI Distribution Specification](https://distribution.github.io/distribution/spec/manifest-v2-2/#manifest-list)
- [Docker Multi-Platform Images](https://docs.docker.com/build/building/multi-platform/)

## ✅ Compliance Checkliste

### Core LinuxServer.io Standards
- [x] S6 Overlay v3 Implementierung
- [x] FILE__ Prefix Secret Support
- [x] Docker Mods Support (DOCKER_MODS)
- [x] Custom Scripts (/custom-cont-init.d)
- [x] Custom Services (/custom-services.d)
- [x] PUID/PGID User Management
- [x] UMASK Support
- [x] abc User (UID 911)
- [x] Non-Root Ausführung
- [x] Korrekte Service-Abhängigkeiten
- [x] LinuxServer.io Baseimage
- [x] Standard Umgebungsvariablen
- [x] Security Best Practices
- [x] Rückwärtskompatibilität

### Advanced Pipeline Standards (2024)
- [x] **OCI Image Manifest Specification v1.1.0 Konformität**
- [x] **LinuxServer.io Pipeline Multi-Architecture Support**
- [x] **Architecture-spezifische Tags (amd64, arm64, arm-v7)**
- [x] **Manifest List Erstellung und Validierung**
- [x] **Native Platform Builds (keine Emulation)**
- [x] **GitHub Actions CI/CD mit Manifest Support**
- [x] **Custom Container Branding**
- [x] **LSIO_FIRST_PARTY=false Einstellung**
- [x] **Klare Support-Kanal-Unterscheidung**

**Status: ✅ VOLLSTÄNDIG KONFORM** mit LinuxServer.io Standards & 2024 Pipeline Best Practices