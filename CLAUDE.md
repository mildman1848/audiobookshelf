# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a custom Docker image for **Audiobookshelf** based on the LinuxServer.io Alpine baseimage. It provides a self-hosted audiobook and podcast server with enhanced security features, complete LinuxServer.io compliance, robust Docker secrets support, and automated CI/CD workflows.

**Documentation:** Available in English (README.md, LINUXSERVER.md, SECURITY.md) and German (README.de.md, LINUXSERVER.de.md, SECURITY.de.md) with cross-references between versions.

**Key Technologies:**
- **Base:** LinuxServer.io Alpine 3.22 with S6 Overlay v3
- **Application:** Audiobookshelf v2.29.0 (Node.js)
- **Architecture:** OCI Manifest Lists with native multi-platform support (AMD64, ARM64)
- **Security:** Advanced container hardening, 512-bit encryption, capability dropping
- **Compliance:** Full LinuxServer.io standard compliance (FILE__ secrets, Docker Mods, Custom Scripts)
- **Pipeline:** 2024 LinuxServer.io Pipeline standards with architecture-specific tags

## Build and Development Commands

### Essential Make Commands

```bash
# Setup and Initial Configuration
make setup                    # Complete initial setup (creates .env + generates secrets)
make env-setup               # Create .env from .env.example template
make secrets-generate        # Generate secure secrets (512-bit JWT, 256-bit API keys)

# Build and Test (Enhanced with OCI Manifest Lists)
make build                   # Build Docker image for current platform
make build-multiarch         # Build multi-architecture image (Legacy)
make build-manifest          # LinuxServer.io style Manifest Lists (Recommended)
make inspect-manifest        # Inspect manifest lists (Multi-arch details)
make validate-manifest       # Validate OCI manifest compliance
make test                    # Run comprehensive container tests with health checks
make validate               # Validate Dockerfile with hadolint
make security-scan          # Run comprehensive security scan (Trivy + CodeQL)
make trivy-scan              # Run Trivy vulnerability scan only
make codeql-scan             # Run CodeQL static code analysis
make security-scan-detailed  # Run detailed security scan with exports

# Container Management (Improved)
make start                  # Start container using docker-compose
make start-with-db          # Start with PostgreSQL database
make stop                   # Stop running containers
make restart                # Stop and restart containers
make status                 # Show container status and health
make logs                   # Show container logs
make shell                  # Get shell access to running container

# Development
make dev                    # Build and run development container

# Environment Management (Enhanced)
make env-validate           # Validate .env configuration (enhanced checks)
make secrets-info           # Show current secrets status with details
make secrets-rotate         # Rotate secrets (with backup and stronger encryption)
make secrets-clean          # Clean up old secret backups
```

### Docker Compose Operations

```bash
# Standard operations
docker-compose up -d                    # Start in detached mode
docker-compose up -d audiobookshelf    # Start only main service
docker-compose logs -f                 # Follow logs

# With database profile
docker-compose --profile with-db up -d  # Start with PostgreSQL database
```

## Architecture Overview

### LinuxServer.io S6 Overlay Services Structure

The container uses S6 Overlay v3 with the following service dependency chain:

```
init-branding � init-mods-package-install � init-custom-files � init-secrets � init-audiobookshelf-config � audiobookshelf
```

**Service Locations:** `root/etc/s6-overlay/s6-rc.d/`

**Key Services (Enhanced):**
- `init-branding`: Custom Mildman1848 ASCII art branding
- `init-secrets`: Enhanced FILE__ prefix processing with path validation
- `init-audiobookshelf-config`: Application configuration with JSON validation
- `audiobookshelf`: Main application service with corrected parameter passing

**Recent Fixes (September 2025):**
- ✅ Fixed chmod permission issues with secure fallback methods
- ✅ Enhanced FILE__ secret processing with path sanitization
- ✅ Improved error handling in all services
- ✅ Added configuration validation and health checks
- ✅ Integrated CodeQL static code analysis alongside Trivy scanning
- ✅ Applied comprehensive npm security patches (28 → 5 vulnerabilities, 82% reduction)
- ✅ **Advanced Nested Dependency Fixes**: Implemented sophisticated replacement system for nested vulnerabilities
- ✅ **Production-Ready Security**: Eliminated all CRITICAL vulnerabilities and achieved minimal risk profile
- ✅ **Enhanced Build Process**: Added intelligent find-and-replace for vulnerable nested packages
- ✅ Optimized container logging to reduce unnecessary warnings
- ✅ Created bilingual documentation (English/German) with cross-references
- ✅ Fixed critical GitHub Actions workflow failures (ci.yml, docker-publish.yml, security.yml)
- ✅ Implemented upstream dependency monitoring with automated notifications
- ✅ Removed ARM/v7 platform support due to upstream image limitations
- ✅ Fixed docker-compose command not found issues in CI workflow
- ✅ Resolved TruffleHog BASE/HEAD commit scanning issues
- ✅ Updated GHCR authentication to use GHCR_TOKEN for proper package permissions
- ✅ Implemented comprehensive version management system (VERSION file + workflow integration)
- ✅ **Security Achievement**: Reduced vulnerabilities from 28 to only 5 (82% improvement)
- ✅ Finalized UPSTREAM_AUTOMATION_EVALUATION.md with complete implementation status
- ✅ Fixed SBOM generation error in docker-publish.yml with proper SHA256 digest extraction
- ✅ Fixed ARM/v7 build failures by removing unsupported platform

### Security Architecture

**Container Security:**
- Non-root execution (user `abc`, UID 911)
- Security hardening with `no-new-privileges`
- Capability dropping (ALL dropped, minimal added)
- Read-only where possible with tmpfs mounts

**Secret Management (Enhanced):**
- **Preferred:** LinuxServer.io FILE__ prefix secrets with path validation
- **Encryption:** 512-bit JWT secrets, 256-bit API keys
- **Legacy:** Docker Swarm secrets support (backward compatible)
- **Generated secrets:** JWT, API keys, database credentials, session secrets
- **Security:** Automatic backup, rotation, and cleanup capabilities

**Vulnerability Management (September 2025):**
- **Trivy Scanning:** Container and filesystem vulnerability detection
- **CodeQL Analysis:** Static code analysis for security issues
- **npm Security:** Comprehensive package vulnerability patches applied
- **Advanced Nested Fixes:** Intelligent replacement system for vulnerable nested dependencies
- **Results:** 82% vulnerability reduction (28 → 5 vulnerabilities)
- **Production Status:** Zero CRITICAL vulnerabilities, minimal remaining risk
- **Automation:** GitHub Actions integration for continuous security scanning

### OCI Manifest Lists & LinuxServer.io Pipeline (2024)

**Multi-Architecture Implementation:**
- **OCI Compliance:** Full OCI Image Manifest Specification v1.1.0 support
- **LinuxServer.io Style:** Architecture-specific tags + Manifest Lists
- **Native Builds:** No emulation - true platform-specific images
- **GitHub Actions:** Matrix-based builds with digest management

**Architecture Tags (LinuxServer.io Standard):**
```bash
# Architecture-specific pulls
docker pull mildman1848/audiobookshelf:amd64-latest
docker pull mildman1848/audiobookshelf:arm64-latest
docker pull mildman1848/audiobookshelf:arm-v7-latest

# Automatic platform selection
docker pull mildman1848/audiobookshelf:latest
```

**Build Process:**
```bash
# LinuxServer.io Pipeline compliance
make build-manifest          # Create manifest lists with arch tags
make inspect-manifest        # Inspect OCI manifest structure
make validate-manifest       # Validate OCI compliance
```

**GitHub Actions Workflow:**
1. **Build Job:** Matrix builds for each platform (amd64, arm64)
2. **Manifest Job:** Creates OCI manifest lists from platform digests
3. **Validation:** Verifies manifest structure and platform compliance
4. **Cleanup Job:** ✅ Fixed - Removes old GHCR packages with proper error handling

### Configuration System

**Environment Loading Priority:**
1. Docker secrets (FILE__ prefixed variables)
2. Environment variables from `.env`
3. Default values in service scripts

**Key Configuration Files:**
- `.env.example`: Complete configuration template with documentation
- `docker-compose.yml`: Service definitions with secrets integration
- `Dockerfile`: Multi-stage build from official audiobookshelf + LinuxServer.io base

## Development Workflow

### Setting Up Development Environment

1. **Initial Setup:**
   ```bash
   make setup              # Creates .env and generates secrets
   ```

2. **Environment Customization:**
   - Edit `.env` file for local paths and settings
   - Ensure `PUID`/`PGID` match your user: `id -u && id -g`

3. **Development Container:**
   ```bash
   make dev               # Builds and runs with development volumes
   ```

### Making Changes

**For S6 Services:** Edit files in `root/etc/s6-overlay/s6-rc.d/`
**For Build Process:** Modify `Dockerfile` and `Makefile`
**For Configuration:** Update `.env.example` and `docker-compose.yml`

**Testing Changes (Enhanced with Manifest Support):**
```bash
make validate           # Dockerfile linting with hadolint
make build             # Build new image for current platform
make build-manifest    # Build LinuxServer.io style multi-arch with manifest lists
make inspect-manifest  # Inspect manifest structure and platform details
make validate-manifest # Validate OCI manifest compliance
make test              # Run comprehensive integration tests with health checks
make security-scan     # Comprehensive security validation (Trivy + CodeQL)
make trivy-scan        # Trivy vulnerability scanning only
make codeql-scan       # CodeQL static code analysis
make status            # Check container health and status
```

### CI/CD Integration

**GitHub Actions Workflows:** (`.github/workflows/`)
- `ci.yml`: Automated testing and validation ✅ Fixed DL3003 Hadolint warning
- `docker-publish.yml`: **Enhanced** - OCI manifest lists with LinuxServer.io pipeline standards ✅ Fixed ARM/v7 platform issues
- `security.yml`: Security scanning and SBOM generation ✅ Fixed TruffleHog and Trivy exit codes
- `codeql.yml`: **New** - CodeQL static code analysis for JavaScript/TypeScript
- `maintenance.yml`: Dependency updates and maintenance
- `upstream-monitor.yml`: **New** - Automated upstream dependency monitoring with issue creation

**Enhanced Docker Publish Workflow:**
- **Matrix Builds:** Separate jobs for each platform (amd64, arm64) ✅ ARM/v7 removed
- **Digest Management:** Platform images pushed by digest with artifact sharing
- **Manifest Creation:** OCI-compliant manifest lists with architecture-specific tags
- **LinuxServer.io Style:** Architecture tags (`amd64-latest`, `arm64-latest`) ✅ Fixed for 2 platforms
- **Validation:** Manifest structure inspection and OCI compliance verification

**Upstream Monitoring Workflow:**
- **Schedule:** Monday and Thursday at 6 AM UTC
- **Audiobookshelf Monitoring:** GitHub API release tracking with automated issue creation
- **Base Image Monitoring:** LinuxServer.io baseimage-alpine 3.22 series tracking
- **Security Assessment:** Prioritizes security-related updates
- **Semi-Automated:** Creates GitHub issues for manual review and action

**GHCR Setup Requirements:**
- **Personal Access Token:** Required with `write:packages` and `read:packages` scopes
- **Repository Secret:** Add as `GHCR_TOKEN` in repository settings
- **Path:** Repository Settings → Secrets and variables → Actions → New repository secret
- **Note:** Without this token, Docker Build & Publish will fail with permission_denied errors

**Version Management System:**
- **VERSION File:** Central version management with semantic versioning (2.29.0-automation.2)
- **Workflow Integration:** All GitHub Actions workflows include project version information
- **Container Labels:** Docker images tagged with both Audiobookshelf and project versions
- **Documentation Sync:** README badges and documentation automatically reflect current version

## Common Development Patterns

### Adding New Environment Variables

1. Add to `.env.example` with documentation
2. Reference in `docker-compose.yml` environment section
3. Handle in relevant S6 service script
4. Update both README.md and README.de.md if user-facing (maintain bilingual documentation)

### Modifying Container Startup

- Main application logic: `root/etc/s6-overlay/s6-rc.d/audiobookshelf/run`
- Configuration setup: `root/etc/s6-overlay/s6-rc.d/init-audiobookshelf-config/up`
- Secret processing: `root/etc/s6-overlay/s6-rc.d/init-secrets/up`

### Security Best Practices

- All secrets should use FILE__ prefix when possible
- Validate input parameters in S6 scripts
- Use `s6-setuidgid abc` for non-root execution
- Set proper file permissions (750 for config, 600 for secrets)

## File Structure

```
audiobookshelf/
   Dockerfile                 # Multi-stage container build
   Makefile                   # Build and development automation
   docker-compose.yml         # Service orchestration with secrets
   .env.example              # Configuration template
   root/                     # Container filesystem overlay
      etc/s6-overlay/s6-rc.d/  # S6 service definitions
   .github/workflows/        # CI/CD automation
```

## Testing

**Automated Tests:** `make test`
- Container startup validation
- Health check verification
- Service availability testing

**Manual Testing:**
```bash
make dev                      # Start development container
curl http://localhost:13378   # Test application availability
make logs                     # Check for errors
```

## Troubleshooting

**Common Issues (Resolved):**
- **Permission errors:** ✅ Fixed with secure fallback methods, check PUID/PGID in `.env`
- **Port conflicts:** Modify EXTERNAL_PORT in `.env`
- **Secret errors:** ✅ Enhanced validation, run `make secrets-generate` and check `make secrets-info`
- **Health check failures:** ✅ Fixed container parameter passing and health endpoints
- **chmod errors:** ✅ Resolved with graceful permission handling
- **Docker workflow failures:** ✅ Fixed GHCR cleanup step with proper error handling and token authentication

**Debug Mode:**
```bash
# Enable debug logging
echo "LOG_LEVEL=debug" >> .env
echo "DEBUG_MODE=true" >> .env
make restart
```