# Security Policy

> 🇩🇪 **Deutsche Version** | 🇬🇧 **[English Version](SECURITY.md)**

## Meldung von Sicherheitslücken

Wir nehmen die Sicherheit unseres Audiobookshelf Docker Images sehr ernst. Falls Sie eine Sicherheitslücke entdecken, helfen Sie uns bitte dabei, die Sicherheit unseres Projekts aufrechtzuerhalten, indem Sie diese verantwortungsvoll melden.

### 🔒 Wie Sie melden können

Erstellen Sie **KEINE** öffentliche GitHub Issue für Sicherheitslücken. Verwenden Sie stattdessen bitte einen der folgenden sicheren Kanäle:

#### GitHub Security Advisories (Bevorzugt)
1. Gehen Sie zum [Security Tab](https://github.com/mildman1848/audiobookshelf/security/advisories) dieses Repositories
2. Klicken Sie auf "Report a vulnerability"
3. Füllen Sie das Formular für Sicherheitslücken mit detaillierten Informationen aus
4. Senden Sie den Bericht ab

#### E-Mail Meldung
Falls GitHub Security Advisories nicht verfügbar sind, können Sie Sicherheitsberichte per E-Mail senden:
- **E-Mail**: [Erstellen Sie ein Issue](https://github.com/mildman1848/audiobookshelf/issues/new?template=security_report.md) mit `[SECURITY]` Präfix (wird privat gemacht)

### 📋 Anzugebende Informationen

Bei der Meldung einer Sicherheitslücke geben Sie bitte folgende Informationen an:

- **Typ der Sicherheitslücke**: (z.B. SQL Injection, XSS, Authentication Bypass, etc.)
- **Betroffene Komponente**: Geben Sie an, welcher Teil des Systems betroffen ist
  - Docker Image/Container
  - S6 Services
  - Konfigurationsdateien
  - Build-Prozess
  - Abhängigkeiten
- **Angriffsvektor**: Wie die Sicherheitslücke ausgenutzt werden kann
- **Auswirkungen**: Was ein Angreifer erreichen könnte
- **Proof of Concept**: Schritte zur Reproduktion (falls sicher möglich)
- **Lösungsvorschlag**: Falls Sie Ideen zur Behebung haben
- **Umgebungsdetails**:
  - Docker Image Version
  - Host-Betriebssystem
  - Container Runtime Version

### 🛡️ Geltungsbereich

Diese Sicherheitsrichtlinie umfasst Sicherheitslücken in:

#### ✅ Im Geltungsbereich
- **Docker Image Sicherheit**
  - Container Escape Sicherheitslücken
  - Privilege Escalation Probleme
  - Unsichere Standard-Konfigurationen
- **Anwendungssicherheit**
  - Authentifizierungs-/Autorisierungsfehler
  - Input-Validierungsprobleme
  - Secret-Exposition
- **Build-Prozess Sicherheit**
  - Supply Chain Angriffe
  - Bösartige Abhängigkeiten
  - Unsichere Build-Konfigurationen
- **S6 Overlay Services**
  - Service-Konfigurationsschwachstellen
  - Inter-Service-Kommunikationsprobleme
- **LinuxServer.io Compliance**
  - FILE__ Prefix Sicherheitsprobleme
  - Docker Mods Sicherheitslücken
  - Custom Script Injection

#### ❌ Außerhalb des Geltungsbereichs
- **Upstream Audiobookshelf Anwendung**
  - Bitte melden Sie an das [offizielle Audiobookshelf Repository](https://github.com/advplyr/audiobookshelf)
- **LinuxServer.io Base Image**
  - Bitte melden Sie an [LinuxServer.io](https://github.com/linuxserver/docker-baseimage-alpine)
- **Drittanbieter-Abhängigkeiten**
  - Melden Sie direkt an die jeweiligen Maintainer
- **Infrastruktur-Probleme**
  - Host-System-Sicherheitslücken
  - Netzwerk-Konfigurationsprobleme
  - Registry/Distribution-Sicherheitslücken

### ⏱️ Antwortzeiten

Wir streben an, auf Sicherheitsberichte gemäß folgender Zeitlinie zu antworten:

| Schweregrad | Erste Antwort | Untersuchung | Lösung |
|-------------|---------------|--------------|---------|
| **Kritisch** | Innerhalb 24 Stunden | Innerhalb 72 Stunden | Innerhalb 7 Tagen |
| **Hoch** | Innerhalb 48 Stunden | Innerhalb 5 Tagen | Innerhalb 14 Tagen |
| **Mittel** | Innerhalb 72 Stunden | Innerhalb 10 Tagen | Innerhalb 30 Tagen |
| **Niedrig** | Innerhalb 1 Woche | Innerhalb 2 Wochen | Nächstes Minor Release |

### 🔐 Sicherheitsmaßnahmen

Unser Docker Image implementiert verschiedene Sicherheitsmaßnahmen:

#### Container Sicherheit
- **Non-root Ausführung** - Läuft als User `abc` (UID 911)
- **Capability Dropping** - ALLE Capabilities entfernt, minimale erforderliche hinzugefügt
- **Security Hardening** - `no-new-privileges`, security-opt Konfigurationen
- **Read-only Dateisystem** - Wo möglich mit tmpfs für temporäre Dateien
- **UMASK Durchsetzung** - Korrekte Dateiberechtigungen (750/640)

#### Secret Management
- **LinuxServer.io FILE__ Prefix** - Sichere Secret-Behandlung
- **512-bit JWT Secrets** - Starke kryptographische Schlüssel
- **Pfad-Validierung** - Verhindert Path Traversal Angriffe
- **Automatische Rotation** - Eingebaute Secret-Rotationsfähigkeiten

#### Build Sicherheit
- **Multi-stage Builds** - Minimale Angriffsfläche
- **Dependency Scanning** - Automatisierte Sicherheitslücken-Scans mit Trivy
- **SBOM Generierung** - Software Bill of Materials für Transparenz
- **Provenance Attestation** - Build-Integritätsverifikation

#### Supply Chain Sicherheit
- **Base Image Verifikation** - Offizielles LinuxServer.io Alpine Base
- **Dependency Pinning** - Spezifische Versionen um Drift zu verhindern
- **Automatisierte Updates** - Dependabot für Sicherheitsupdates
- **CI/CD Sicherheit** - Signierte Commits und geschützte Workflows

### 🏆 Anerkennung

Wir glauben daran, Sicherheitsforscher anzuerkennen, die zur Verbesserung der Sicherheit unseres Projekts beitragen:

- **Anerkennung** - Wir werden Ihren Beitrag öffentlich anerkennen (mit Ihrer Erlaubnis)
- **Hall of Fame** - Anerkennung in unserer Sicherheits-Hall of Fame
- **Priority Support** - Schneller Support für Ihre Issues und Fragen

### 📚 Sicherheitsressourcen

#### Sichere Konfiguration
- Folgen Sie unserem [LinuxServer.io Compliance Guide](LINUXSERVER.de.md)
- Verwenden Sie empfohlene [Umgebungsvariablen](.env.example)
- Implementieren Sie [Best Practices](README.de.md#enhanced-security) aus unserer Dokumentation

#### Sicherheitstools
- **Container Scanning**: `make security-scan` (Trivy)
- **Dockerfile Linting**: `make validate` (Hadolint)
- **Environment Validierung**: `make env-validate`
- **Health Monitoring**: `make status`

#### Externe Ressourcen
- [OWASP Container Security](https://owasp.org/www-project-container-security/)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [LinuxServer.io Security Guidelines](https://docs.linuxserver.io/FAQ#security)

### 🔄 Sicherheitsupdates

Wir aktualisieren regelmäßig unsere Sicherheitsmaßnahmen:

- **Monatliche Reviews** - Regelmäßige Sicherheitsbewertung der Abhängigkeiten
- **Automatisierte Scans** - Kontinuierliche Sicherheitslücken-Überwachung
- **Patch Management** - Schnelle Bereitstellung von Sicherheitsfixes
- **Dokumentations-Updates** - Sicherheitsrichtlinien aktuell halten

### 📞 Kontakt

Für nicht-sicherheitsbezogene Probleme:
- **Allgemeine Issues**: [GitHub Issues](https://github.com/mildman1848/audiobookshelf/issues)
- **Fragen**: [GitHub Discussions](https://github.com/mildman1848/audiobookshelf/discussions)
- **Dokumentation**: [README.de.md](README.de.md)

### 📄 Rechtliches

- Wir werden keine rechtlichen Schritte gegen Sicherheitsforscher einleiten, die dieser Richtlinie folgen
- Wir bitten Sie, Sicherheitslücken nicht öffentlich bekannt zu geben, bis wir die Möglichkeit hatten, sie zu beheben
- Bitte handeln Sie in gutem Glauben und vermeiden Sie Datenschutzverletzungen, Datenvernichtung oder Service-Störungen

---

**Letzte Aktualisierung**: September 2025
**Richtlinien-Version**: 1.0
**Nächste Überprüfung**: Juni 2026