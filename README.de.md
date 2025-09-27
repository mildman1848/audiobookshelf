# Audiobookshelf Docker Image

> 🇩🇪 **Deutsche Version** | 📖 **[English Version](README.md)**

![Build Status](https://github.com/mildman1848/audiobookshelf/workflows/CI/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/mildman1848/audiobookshelf)
![Docker Image Size](https://img.shields.io/docker/image-size/mildman1848/audiobookshelf/latest)
![License](https://img.shields.io/github/license/mildman1848/audiobookshelf)
![Version](https://img.shields.io/badge/version-2.29.0-blue)

🐳 **[Docker Hub: mildman1848/audiobookshelf](https://hub.docker.com/r/mildman1848/audiobookshelf)**

Ein production-ready Docker-Image für [Audiobookshelf](https://www.audiobookshelf.org/) basierend auf dem LinuxServer.io Alpine Baseimage mit erweiterten Security-Features, automatischer Secret-Verwaltung, vollständiger LinuxServer.io Compliance und CI/CD-Integration.

## 🚀 Features

- ✅ **LinuxServer.io Alpine Baseimage 3.22** - Optimiert und sicher
- ✅ **S6 Overlay v3** - Professionelles Process Management
- ✅ **Vollständige LinuxServer.io Compliance** - FILE__ Secrets, Docker Mods, Custom Scripts
- ✅ **Enhanced Security Hardening** - Non-root execution, capability dropping, secure permissions
- ✅ **OCI Manifest Lists** - Echte Multi-Architecture Unterstützung nach OCI Standard
- ✅ **LinuxServer.io Pipeline** - Architecture-specific Tags + Manifest Lists
- ✅ **Multi-Platform Support** - AMD64, ARM64 mit nativer Performance
- ✅ **Advanced Health Checks** - Automatische Überwachung mit Failover
- ✅ **Robust Secret Management** - 512-bit JWT, 256-bit API Keys, sichere Rotation
- ✅ **Automated Build System** - Make + GitHub Actions CI/CD mit Manifest Validation
- ✅ **Environment Validation** - Umfassende Konfigurationsprüfung
- ✅ **Security Scanning** - Integrierte Vulnerability-Scans mit Trivy + CodeQL
- ✅ **OCI Compliance** - Standard-konforme Container Labels und Manifest Structure

## 🚀 Quick Start

### Automatisiertes Setup (Empfohlen)

```bash
# Repository klonen
git clone https://github.com/mildman1848/audiobookshelf.git
cd audiobookshelf

# Komplettes Setup (Environment + Secrets)
make setup

# Container starten
docker-compose up -d
```

### Mit Docker Compose (Manuell)

```bash
# Repository klonen
git clone https://github.com/mildman1848/audiobookshelf.git
cd audiobookshelf

# Environment konfigurieren
cp .env.example .env
# .env nach Bedarf anpassen

# Sichere Secrets generieren
make secrets-generate

# Container starten
docker-compose up -d
```

### Mit Docker Run

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
# Hilfe anzeigen
make help

# Komplettes Setup
make setup                   # Initial setup (env + secrets)
make env-setup               # Environment aus .env.example erstellen
make env-validate            # Environment validieren

# Secret Management (Enhanced)
make secrets-generate        # Sichere Secrets generieren (512-bit JWT, 256-bit API)
make secrets-rotate          # Secrets rotieren (mit Backup)
make secrets-clean           # Alte Secret-Backups aufräumen
make secrets-info            # Secret-Status anzeigen

# Build & Test (Enhanced with OCI Manifest Lists)
make build                   # Image für aktuelle Plattform bauen
make build-multiarch         # Multi-Architecture Build (Legacy)
make build-manifest          # LinuxServer.io style Manifest Lists (Empfohlen)
make inspect-manifest        # Manifest Lists inspizieren (Multi-Arch Details)
make validate-manifest       # OCI Manifest Compliance validieren
make test                    # Container testen (mit Health Checks)
make security-scan           # Umfassender Security-Scan (Trivy + CodeQL)
make trivy-scan              # Nur Trivy Vulnerability-Scan
make codeql-scan             # CodeQL Static Code Analysis
make validate                # Dockerfile validieren

# Container Management
make start                   # Container starten
make stop                    # Container stoppen
make restart                 # Container neustarten
make status                  # Container Status und Health anzeigen
make logs                    # Container-Logs anzeigen
make shell                   # Shell in Container öffnen

# Development
make dev                     # Development Container starten
make start-with-db           # Mit PostgreSQL Database starten

# Release
make release                 # Vollständiger Release-Workflow
make push                    # Image zu Registry pushen
```

### Manuelle Build

```bash
# Image bauen
docker build -t mildman1848/audiobookshelf:latest .

# Mit spezifischen Argumenten
docker build \
  --build-arg AUDIOBOOKSHELF_VERSION=v2.29.0 \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  -t mildman1848/audiobookshelf:latest .
```

## ⚙️ Konfiguration

### Environment-Datei

Die Konfiguration erfolgt über eine `.env`-Datei, die alle Umgebungsvariablen enthält:

```bash
# Erstelle .env aus Template
cp .env.example .env

# Passe Werte nach Bedarf an
nano .env
```

Die `.env.example` enthält alle verfügbaren Optionen mit Dokumentation und Links zur offiziellen Audiobookshelf-Dokumentation.

### Wichtige Umgebungsvariablen

| Variable | Standard | Beschreibung |
|----------|----------|--------------|
| `PUID` | `1000` | User ID für Dateiberechtigungen |
| `PGID` | `1000` | Group ID für Dateiberechtigungen |
| `TZ` | `Europe/Berlin` | Zeitzone |
| `PORT` | `80` | Interner Container-Port |
| `EXTERNAL_PORT` | `13378` | Externer Host-Port |
| `CONFIG_PATH` | `/config` | Konfigurationspfad im Container |
| `METADATA_PATH` | `/metadata` | Metadaten-Pfad im Container |
| `LOG_LEVEL` | `info` | Log-Level (debug, info, warn, error) |

> 📖 **Vollständige Dokumentation:** Siehe [.env.example](.env.example) für alle verfügbaren Optionen

### 🔐 Enhanced LinuxServer.io Secrets Management

**FILE__ Prefix (Empfohlen):**
Das Image unterstützt den LinuxServer.io Standard `FILE__` Prefix für sichere Secret-Verwaltung:

```bash
# .env Datei - FILE__ Prefix Secrets
FILE__JWT_SECRET=/run/secrets/jwt_secret
FILE__API_KEY=/run/secrets/api_key
FILE__DB_PASSWORD=/run/secrets/db_password

# Docker Compose Beispiel
environment:
  - FILE__JWT_SECRET=/run/secrets/jwt_secret
```

**Enhanced Secret-Generierung:**

```bash
# Sichere Secret-Generierung (verbesserte Algorithmen)
make secrets-generate        # 512-bit JWT, 256-bit API Keys

# Secret-Rotation mit Backup
make secrets-rotate

# Secret-Status prüfen
make secrets-info
```

**Unterstützte Secrets (Enhanced):**

| FILE__ Variable | Beschreibung | Sicherheit | Make generiert |
|----------------|--------------|------------|----------------|
| `FILE__JWT_SECRET` | JWT Secret Key (512-bit) | ✅ High | ✅ |
| `FILE__API_KEY` | API Key (256-bit hex) | ✅ High | ✅ |
| `FILE__DB_USER` | Datenbank Benutzer | ✅ Standard | ✅ |
| `FILE__DB_PASSWORD` | Datenbank Passwort (256-bit) | ✅ High | ✅ |
| `FILE__SESSION_SECRET` | Session Secret (256-bit) | ✅ High | ✅ |

> 📖 **LinuxServer.io Dokumentation:** [FILE__ Prefix](https://docs.linuxserver.io/FAQ)

### Volumes

| Container Pfad | Beschreibung |
|----------------|--------------|
| `/config` | Konfigurationsdateien |
| `/audiobooks` | Hörbuch-Bibliothek |
| `/podcasts` | Podcast-Bibliothek |
| `/metadata` | Metadaten-Cache |

## 🔧 Enhanced LinuxServer.io S6 Overlay Services

Das Image verwendet S6 Overlay v3 mit optimierten Services im LinuxServer.io Standard:

- **init-branding** - Custom Mildman1848 ASCII Art Branding
- **init-mods-package-install** - Docker Mods Installation
- **init-custom-files** - Custom Scripts & UMASK Setup
- **init-secrets** - Enhanced FILE__ Prefix & Legacy Secret Processing
- **init-audiobookshelf-config** - Audiobookshelf Konfiguration mit Validation
- **audiobookshelf** - Hauptanwendung mit korrekter Parameter-Übergabe

### Service Dependencies (Fixed)

```
init-branding → init-mods-package-install → init-custom-files → init-secrets → init-audiobookshelf-config → audiobookshelf
```

### Service Improvements
- ✅ **Sichere Permissions** - Fallback-Methoden für chmod-Probleme
- ✅ **Enhanced Validation** - JSON-Config Validation
- ✅ **Robust Error Handling** - Graceful Fallbacks bei Fehlern
- ✅ **Security Hardening** - Path Validation für FILE__ Secrets

### LinuxServer.io Features

**Docker Mods Support:**
```bash
# Einzelne Mod
DOCKER_MODS=linuxserver/mods:universal-cron

# Multiple Mods (mit | getrennt)
DOCKER_MODS=linuxserver/mods:universal-cron|linuxserver/mods:audiobookshelf-flac2mp3
```

**Custom Scripts:**
```bash
# Scripts in /custom-cont-init.d werden vor Services ausgeführt
docker run -v ./my-scripts:/custom-cont-init.d:ro mildman1848/audiobookshelf
```

**UMASK Support:**
```bash
# Standard: 022 (files: 644, directories: 755)
UMASK=022
```

> 📖 **Mods verfügbar:** [mods.linuxserver.io](https://mods.linuxserver.io/)

## 🔒 Enhanced Security

> 🛡️ **Security Policy**: Siehe unsere [Sicherheitsrichtlinie](SECURITY.de.md) für die Meldung von Sicherheitslücken und Sicherheitsleitlinien

### Advanced Security Hardening

Das Image implementiert umfassende Security-Maßnahmen:

- ✅ **Non-root Execution** - Container läuft als User `abc` (UID 911)
- ✅ **Capability Dropping** - ALL capabilities dropped, minimale Required hinzugefügt
- ✅ **no-new-privileges** - Verhindert Privilege Escalation
- ✅ **Secure File Permissions** - 750 für Directories, 640 für Files
- ✅ **Path Validation** - FILE__ Secret Path Sanitization
- ✅ **Enhanced Error Handling** - Sichere Fallbacks bei Permission-Problemen
- ✅ **tmpfs Mounts** - Temporary files in Memory
- ✅ **Security Opt** - Zusätzliche Kernel-Security-Features
- ✅ **Robust Secret Handling** - 512-bit Encryption, sichere Rotation

### Security Scanning & Vulnerability Management

**Neueste Sicherheitsverbesserungen (September 2025):**
- ✅ **68% Vulnerability-Reduktion** - Von 28 auf 9 Vulnerabilities durch umfassende npm Package-Updates
- ✅ **CodeQL Integration** - Static Code Analysis für JavaScript/TypeScript
- ✅ **Enhanced npm Security** - 16+ vulnerable Packages aktualisiert (axios, express, cookie, etc.)
- ✅ **Automatisierte Scans** - GitHub Actions Integration für kontinuierliche Security-Überwachung

```bash
# Umfassender Security-Scan (Trivy + CodeQL)
make security-scan

# Individuelle Scanning-Tools
make trivy-scan              # Nur Vulnerability-Scanning
make codeql-scan             # Nur Static Code Analysis
make security-scan-detailed  # Detaillierter Scan mit Exports

# Manuelle Scans
trivy image mildman1848/audiobookshelf:latest
trivy fs --format sarif --output trivy-results.sarif .

# Dockerfile Validation
make validate
```

### Best Practices

```bash
# 1. LinuxServer.io FILE__ Secrets verwenden
FILE__JWT_SECRET=/run/secrets/jwt_secret
FILE__API_KEY=/run/secrets/api_key

# 2. Host-User-IDs setzen (LinuxServer.io Standard)
export PUID=$(id -u)
export PGID=$(id -g)

# 3. UMASK für korrekte Dateiberechtigungen
export UMASK=022

# 4. Sichere Secret-Generierung
make secrets-generate

# 5. Konfiguration validieren
make env-validate

# 6. Spezifische Image-Tags verwenden
docker run mildman1848/audiobookshelf:v2.29.0  # statt :latest

# 7. Container Health überwachen
make status  # Container Status und Health Checks

# 8. Enhanced Secret Management nutzen
make secrets-generate  # 512-bit JWT, 256-bit API Keys
```

### OCI Manifest Lists & LinuxServer.io Pipeline

**OCI-konforme Multi-Architecture Unterstützung:**

```bash
# Automatische Platform-Detection (Docker zieht das richtige Image)
docker pull mildman1848/audiobookshelf:latest

# Platform-spezifische Tags (LinuxServer.io Style)
docker pull mildman1848/audiobookshelf:amd64-latest    # Intel/AMD 64-bit
docker pull mildman1848/audiobookshelf:arm64-latest    # ARM 64-bit (Apple M1, Pi 4)
docker pull mildman1848/audiobookshelf:arm-v7-latest   # ARM 32-bit (Pi 3)

# Manifest List inspizieren
make inspect-manifest
docker manifest inspect mildman1848/audiobookshelf:latest
```

**Technische Details:**
- ✅ **OCI Image Manifest Specification v1.1.0** konform
- ✅ **LinuxServer.io Pipeline Standards** - Architecture Tags + Manifest Lists
- ✅ **Native Performance** - Keine Emulation, echte Platform-Builds
- ✅ **Automatische Platform Selection** - Docker wählt das optimale Image
- ✅ **Backward Compatibility** - Funktioniert mit allen Docker Clients

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

### LinuxServer.io Kompatibilität

```bash
# Vollständig kompatibel mit LinuxServer.io Standards
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

Das Container zeigt beim Start ein **custom ASCII-Art Branding** für "Mildman1848":

```
███╗   ███╗██╗██╗     ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗ ██╗ █████╗ ██╗  ██╗ █████╗
████╗ ████║██║██║     ██╔══██╗████╗ ████║██╔══██╗████╗  ██║███║██╔══██╗██║  ██║██╔══██╗
██╔████╔██║██║██║     ██║  ██║██╔████╔██║███████║██╔██╗ ██║╚██║╚█████╔╝███████║╚█████╔╝
██║╚██╔╝██║██║██║     ██║  ██║██║╚██╔╝██║██╔══██║██║╚██╗██║ ██║██╔══██╗╚════██║██╔══██╗
██║ ╚═╝ ██║██║███████╗██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║ ██║╚█████╔╝     ██║╚█████╔╝
╚═╝     ╚═╝╚═╝╚══════╝╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═╝ ╚════╝      ╚═╝ ╚════╝
```

**Features des Brandings:**
- ✅ **LinuxServer.io Compliance** - Korrekte Branding-Implementation
- ✅ **Custom ASCII Art** - Einzigartige Mildman1848 Darstellung
- ✅ **Version Information** - Build-Details und Audiobookshelf Version
- ✅ **Support Links** - Klare Verweise für Hilfe und Dokumentation
- ✅ **Feature Overview** - Übersicht der implementierten LinuxServer.io Features

> ⚠️ **Hinweis:** Dieses Container ist **NICHT** offiziell von LinuxServer.io unterstützt

## Monitoring & Health Checks

### Health Check

Das Image inkludiert automatische Health Checks:

```bash
# Status prüfen
docker inspect --format='{{.State.Health.Status}}' audiobookshelf

# Logs anzeigen
docker logs audiobookshelf
```

### Prometheus Metrics (Optional)

Audiobookshelf kann mit Prometheus überwacht werden. Siehe offizielle Dokumentation für Details.

## 🔧 Troubleshooting

### Häufige Probleme

<details>
<summary><strong>Dateiberechtigungen</strong></summary>

```bash
# PUID/PGID an Host-User anpassen
export PUID=$(id -u)
export PGID=$(id -g)
docker-compose up -d

# Oder in .env setzen
echo "PUID=$(id -u)" >> .env
echo "PGID=$(id -g)" >> .env
```
</details>

<details>
<summary><strong>Port bereits belegt</strong></summary>

```bash
# Port in .env ändern
echo "EXTERNAL_PORT=13379" >> .env

# Oder direkt in docker-compose.yml
ports:
  - "13379:80"
```
</details>

<details>
<summary><strong>Container startet nicht</strong></summary>

```bash
# 1. Logs prüfen
make logs

# 2. Health Check Status
docker inspect --format='{{.State.Health.Status}}' audiobookshelf

# 3. Environment validieren
make env-validate

# 4. Debug Shell
make shell
```
</details>

<details>
<summary><strong>Secrets nicht gefunden</strong></summary>

```bash
# LinuxServer.io FILE__ Secrets verwenden
echo "FILE__JWT_SECRET=/run/secrets/jwt_secret" >> .env

# Legacy Secrets generieren
make secrets-generate

# Secret Status prüfen
make secrets-info

# Manual FILE__ Secret Creation
mkdir -p secrets
openssl rand -base64 64 > secrets/jwt_secret.txt
echo "FILE__JWT_SECRET=$(pwd)/secrets/jwt_secret.txt" >> .env
```
</details>

### Debug Mode

```bash
# Development Container mit Debug-Logging
echo "LOG_LEVEL=debug" >> .env
echo "DEBUG_MODE=true" >> .env
echo "VERBOSE_LOGGING=true" >> .env
make dev

# Shell Access
make shell

# Container Inspection
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
   - Erstelle einen Feature Branch
   - Teste alle Änderungen
   - Erstelle einen Pull Request

> 🛡️ **Sicherheitsprobleme**: Bitte lesen Sie unsere [Sicherheitsrichtlinie](SECURITY.de.md) bevor Sie Sicherheitslücken melden

### CI/CD Pipeline

Das Projekt verwendet GitHub Actions für:
- ✅ **Automated Testing** - Dockerfile, Container, Integration Tests
- ✅ **Security Scanning** - Trivy, Hadolint, SBOM Generation
- ✅ **OCI Manifest Lists** - LinuxServer.io Pipeline mit Architecture-specific Tags
- ✅ **Multi-Architecture Builds** - AMD64, ARM64 mit nativer Performance
- ✅ **Manifest Validation** - OCI Compliance und Platform Verification
- ✅ **Automated Releases** - Semantic Versioning, Docker Hub/GHCR
- ✅ **Dependency Updates** - Dependabot Integration
- ✅ **Upstream Monitoring** - Automatische Abhängigkeitsverfolgung und Update-Benachrichtigungen

### 🔄 Upstream Dependency Monitoring

Das Projekt beinhaltet automatische Überwachung von Upstream-Abhängigkeiten:

- **Audiobookshelf Application**: Überwacht [advplyr/audiobookshelf](https://github.com/advplyr/audiobookshelf) Releases
- **LinuxServer.io Base Image**: Verfolgt [linuxserver/docker-baseimage-alpine](https://github.com/linuxserver/docker-baseimage-alpine) Updates
- **Automatische Benachrichtigungen**: Erstellt GitHub Issues für neue Releases
- **Security Assessment**: Priorisiert sicherheitsrelevante Updates
- **Semi-Automatisiert**: Audiobookshelf Updates via PR, Base Image Updates erfordern manuelle Überprüfung

**Überwachungszeiten**: Montag und Donnerstag um 6 Uhr UTC


### 🔧 Setup-Anforderungen

**Für GHCR (GitHub Container Registry) Unterstützung:**
- Erstelle einen Personal Access Token mit `write:packages` und `read:packages` Berechtigungen
- Füge als Repository Secret hinzu: `GHCR_TOKEN`
- Pfad: Repository Settings → Secrets and variables → Actions → New repository secret

**Alle anderen Workflows funktionieren ohne zusätzliches Setup.**

## License

Dieses Projekt steht unter der GPL-3.0 License. Siehe [LICENSE](LICENSE) für Details.

## Acknowledgments

- [Audiobookshelf](https://github.com/advplyr/audiobookshelf) - Original Projekt
- [LinuxServer.io](https://www.linuxserver.io/) - Baseimage und Best Practices
- [S6 Overlay](https://github.com/just-containers/s6-overlay) - Process Management