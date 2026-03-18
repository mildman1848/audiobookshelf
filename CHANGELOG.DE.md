# Changelog

English: [CHANGELOG.md](CHANGELOG.md)

Alle wichtigen Änderungen am Audiobookshelf-Container werden in dieser Datei dokumentiert.

## Unveröffentlicht

- Routine-CI-Builds auf `linux/amd64` begrenzt, damit normale Push-Validierungen nicht mehr am derzeit instabilen ARM64-Testpfad scheitern.
- Trivy-Workflows auf `aquasecurity/trivy-action@0.35.0` aktualisiert und SARIF-Uploads gegen fehlende Ausgabedateien abgesichert.
- Den Maintenance-Workflow so angepasst, dass keine doppelten automatischen Security-Audit-Issues mehr erzeugt werden, wenn bereits ein passendes Issue offen ist.
