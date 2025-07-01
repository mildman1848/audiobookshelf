# Audiobookshelf – LinuxServer.io Style Docker Build

**English | Deutsch unten**

---

## About

This repository builds a container for [Audiobookshelf](https://github.com/advplyr/audiobookshelf) using Alpine Linux, s6-overlay, and all linuxserver.io best practices. The upstream application source is downloaded during build. All secrets and service logic follow LSIO standards.

**Key features:**
- Clean, production-focused Dockerfile and `root/` structure.
- s6-overlay service/init management.
- User abc:abc, UID/GID 911 for container process.
- Docker Secrets support via `/etc/cont-init.d/10-secrets`.
- Multilingual preparation (EN/DE).
- No bundled app source; always latest or pinned release at build.

---

## Usage

1. Build the image:
   ```bash
   docker build -t audiobookshelf-lsio .
   ```
2. Run the container:
   ```bash
   docker run -d -p 13378:80 --name audiobookshelf audiobookshelf-lsio
   ```

---

## Customization

- To use a specific Audiobookshelf release, set `APP_VERSION` in the Dockerfile.
- Mount volumes for persistent config and media as needed.

---

## Directory Structure

- **Dockerfile**: Container build logic (LSIO best practice)
- **root/**: Init and service scripts for s6-overlay
  - `/etc/cont-init.d/10-secrets`: Docker Secrets loader
  - `/etc/cont-init.d/50-healthcheck`: Healthcheck script
  - `/etc/services.d/audiobookshelf/run`: Service start script
  - `/etc/services.d/audiobookshelf/finish`: Service finish script

---

## Branches

- **main/master**: Release, only deployment-relevant files
- **(optional) custom-mods**: Development and CI/CD files

---

## License

This project is MIT licensed.  
Original Audiobookshelf source: [MIT License](https://github.com/advplyr/audiobookshelf/blob/master/LICENSE)

---

## Deutsch

### Über dieses Repository

Dieses Repository baut einen Container für [Audiobookshelf](https://github.com/advplyr/audiobookshelf) nach den Best Practices von linuxserver.io – mit Alpine Linux, s6-overlay und LSIO-typischer Struktur.  
Der Anwendungscode wird während des Builds geladen (kein App-Source im Repo).  
Secrets und Service-Handling folgen LSIO-Standards.

### Merkmale

- Saubere, produktionsorientierte Dockerfile- und `root/`-Struktur
- Service/Init-Handling via s6-overlay
- User abc:abc, UID/GID 911 im Container
- Docker-Secrets-Support über `/etc/cont-init.d/10-secrets`
- Mehrsprachigkeitsvorbereitung (EN/DE)
- Kein App-Quellcode gebündelt, immer neuester oder festgelegter Release beim Build

### Nutzung

1. Image bauen:
   ```bash
   docker build -t audiobookshelf-lsio .
   ```
2. Container starten:
   ```bash
   docker run -d -p 13378:80 --name audiobookshelf audiobookshelf-lsio
   ```

### Struktur

- **Dockerfile**: Bauanleitung nach LSIO-Best Practice
- **root/**: Init- und Service-Skripte für s6-overlay

### Lizenz

Dieses Projekt steht unter MIT-Lizenz.  
Audiobookshelf-Source: MIT License

