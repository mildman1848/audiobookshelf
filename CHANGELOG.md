# CHANGELOG.md

## [2025-07-01] Initial release: LinuxServer.io style Audiobookshelf container

### Added
- Dockerfile based on Alpine Linux and s6-overlay (LSIO best practices)
- Secrets loader, healthcheck, service run/finish scripts in root/
- .dockerignore, .gitignore, .gitattributes for clean builds
- README.md and this CHANGELOG.md

### Changed
- No app source code in repo – always fetched at build time

---
