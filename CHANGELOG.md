# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 🔧 CI/CD Pipeline Fixes

#### SBOM Generation Fix
- **Docker Publish Workflow**: Fixed SBOM attestation error "subject-digest must be in the format sha256:<hex-digest>"
- **Digest Extraction**: Implemented proper SHA256 digest extraction from manifest lists
- **Subshell Issue**: Resolved GitHub Actions workflow variable propagation issue
- **Conditional SBOM**: Added safety check to only generate SBOM when valid digest is available
- **Reliability**: Enhanced manifest creation step with proper output handling

#### Multi-Platform Support Restoration
- **ARM/v7 Platform**: Re-enabled ARM/v7 (linux/arm/v7) platform support for older ARM devices
- **Three-Platform Build**: Restored full multi-architecture support (AMD64, ARM64, ARM/v7)
- **Manifest Logic**: Enhanced manifest creation to handle three platforms properly
- **LinuxServer.io Compliance**: Updated architecture-specific tags for all three platforms
- **Device Compatibility**: Added support for Raspberry Pi 2/3 and other ARMv7 devices

## [2.29.0-automation.2] - 2025-09-20

### 🔧 Version Management & Final Security

#### Version System Implementation
- **Semantic Versioning**: Implemented comprehensive version management system with VERSION file
- **Workflow Integration**: Added project versioning to all GitHub Actions workflows
- **Container Labels**: Enhanced Docker labels with project version information
- **Documentation**: Updated README badges and documentation with current version

#### Security Validation
- **Zero Critical Vulnerabilities**: Confirmed no HIGH or CRITICAL security issues remain
- **Trivy Scanning**: Comprehensive container vulnerability assessment shows clean state
- **Package Security**: All npm package vulnerabilities resolved through previous security patches

#### Automation Completion
- **Upstream Evaluation**: Finalized UPSTREAM_AUTOMATION_EVALUATION.md with implementation status
- **Monitoring Status**: Confirmed successful implementation of semi-automated dependency monitoring
- **Workflow Reliability**: Achieved 100% success rate for CI, Security Scan, and CodeQL workflows

#### Documentation Finalization
- **Implementation Status**: Comprehensive documentation of completed automation features
- **Version Integration**: All documentation updated with current version information
- **GHCR Setup**: Complete instructions for GitHub Container Registry authentication

---

## [2.29.0-automation.1] - 2025-09-20

### 🤖 Automation & Workflow Improvements

#### Upstream Dependency Monitoring
- **Automated Monitoring**: Implemented comprehensive upstream dependency tracking system
- **GitHub Issue Creation**: Automatic issue creation for new Audiobookshelf and LinuxServer.io base image releases
- **Schedule**: Bi-weekly monitoring (Monday and Thursday at 6 AM UTC)
- **Security Assessment**: Prioritizes security-related updates with automated notifications
- **Semi-Automated Process**: Creates actionable GitHub issues for manual review and implementation

#### Critical Workflow Fixes
- **CI Workflow**: Fixed DL3003 Hadolint warning by adding proper WORKDIR directive
- **Docker Compose Issues**: Resolved "command not found" errors by adding docker-compose installation
- **Security Scanning**: Fixed TruffleHog BASE/HEAD commit scanning issues
- **ARM/v7 Platform**: Removed problematic ARM/v7 support to resolve manifest build failures
- **Multi-Architecture**: Streamlined to AMD64 and ARM64 for reliable builds

#### GHCR Authentication Enhancement
- **Token-Based Auth**: Migrated from GITHUB_TOKEN to GHCR_TOKEN for proper package permissions
- **Permission Fix**: Resolved "permission_denied: write_package" errors
- **Setup Documentation**: Added comprehensive GHCR setup instructions
- **Dual Registry**: Maintained support for both Docker Hub and GitHub Container Registry

#### Workflow Reliability
- **Complete Test Coverage**: All CI workflow jobs now pass successfully
- **Security Scanning**: Enhanced Trivy and CodeQL integration with proper exit codes
- **Container Testing**: Comprehensive Docker Compose and integration testing
- **Manifest Validation**: OCI compliance and LinuxServer.io pipeline standards

### 📚 Documentation Updates

#### Setup Requirements
- **GHCR Token Documentation**: Added step-by-step Personal Access Token setup instructions
- **Bilingual Updates**: Enhanced both English and German documentation
- **Workflow Status**: Updated documentation with current workflow capabilities
- **Troubleshooting**: Added troubleshooting section for common setup issues

#### Implementation Strategy
- **UPSTREAM_AUTOMATION_EVALUATION.md**: Comprehensive automation strategy documentation
- **Risk Assessment**: Detailed security and stability considerations
- **Implementation Plan**: Phase-based rollout strategy with manual approval gates

### 🔧 Technical Infrastructure

#### Workflow Organization
- **upstream-monitor.yml**: New automated dependency monitoring workflow
- **Enhanced CI**: Improved reliability with proper dependency installation
- **Security Integration**: Seamless integration of security scanning with build process
- **Error Handling**: Robust error handling and fallback mechanisms

#### Platform Support
- **Simplified Architecture**: Focused on AMD64 and ARM64 for optimal stability
- **OCI Compliance**: Maintained full OCI manifest list compliance
- **LinuxServer.io Standards**: Continued adherence to LinuxServer.io pipeline requirements

### 📊 Automation Metrics

#### Monitoring Coverage
- **Upstream Sources**: 2 monitored (Audiobookshelf application + LinuxServer.io base image)
- **Check Frequency**: 8 times per month (bi-weekly schedule)
- **Notification Method**: GitHub Issues with automated labeling and categorization
- **Response Time**: Immediate issue creation upon new release detection

#### Workflow Reliability
- **Success Rate**: 100% for CI, Security Scan, and CodeQL workflows
- **Build Time**: Optimized multi-architecture builds
- **Test Coverage**: Complete integration and container testing

---

## [2.29.0-security.1] - 2025-09-20

### 🔒 Security Improvements

#### Major Vulnerability Fixes
- **68% Vulnerability Reduction**: Reduced container vulnerabilities from 28 to 9 through comprehensive npm package updates
- **npm Security Patches**: Updated 16+ vulnerable packages including:
  - `axios@^1.7.9` - Fixes CVE-2025-27152, CVE-2025-58754, CVE-2023-45857
  - `express@^4.21.1` - Fixes CVE-2024-29041, CVE-2024-43796
  - `cookie@^0.7.2` - Fixes CVE-2024-47764
  - `ip@^2.0.1` - Fixes CVE-2024-29415, CVE-2023-42282
  - `path-to-regexp@^8.2.0` - Fixes CVE-2024-45296, CVE-2024-52798
  - `body-parser@^1.20.3` - Fixes CVE-2024-45590
  - `follow-redirects@^1.15.9` - Fixes CVE-2024-28849
  - `form-data@^4.0.1` - Fixes CVE-2025-7783
  - `jose@^5.9.6` - Fixes CVE-2024-28176
  - `tar@^7.4.3` - Fixes CVE-2024-28863
  - `ws@^8.18.0` - Fixes CVE-2024-37890
  - And several more critical security updates

#### Enhanced Security Scanning
- **CodeQL Integration**: Added GitHub CodeQL static code analysis for JavaScript/TypeScript
- **Dual Security Scanning**: Implemented comprehensive security scanning with both Trivy and CodeQL
- **Automated Security Workflows**: Enhanced GitHub Actions with continuous security monitoring
- **Security Reporting**: Added SARIF and JSON export capabilities for security scan results

#### Container Security Enhancements
- **Optimized Logging**: Reduced container log noise by filtering optional secret warnings
- **Enhanced Secret Processing**: Improved FILE__ prefix secret handling with better error messages
- **Security Validation**: Added comprehensive security scan validation in build process

### 📚 Documentation Improvements

#### Bilingual Documentation
- **Complete Internationalization**: Created comprehensive English and German documentation
- **Cross-Reference System**: Added language switcher headers linking between versions
- **Security Policies**: Established bilingual security vulnerability reporting policies (SECURITY.md/SECURITY.de.md)
- **LinuxServer.io Compliance**: Created detailed compliance documentation (LINUXSERVER.md/LINUXSERVER.de.md)

#### Enhanced Documentation
- **README Overhaul**: Updated README.md and README.de.md with latest security improvements
- **CLAUDE.md Updates**: Enhanced development documentation with security scanning details
- **Changelog Introduction**: Added this comprehensive changelog for change tracking

### 🛠️ Development & CI/CD

#### Makefile Enhancements
- **Security Scan Targets**: Added comprehensive security scanning make targets
  - `make security-scan` - Combined Trivy + CodeQL scanning
  - `make trivy-scan` - Trivy vulnerability scanning only
  - `make codeql-scan` - CodeQL static code analysis only
  - `make security-scan-detailed` - Detailed scanning with exports

#### GitHub Actions Improvements
- **CodeQL Workflow**: Added new `.github/workflows/codeql.yml` for automated static code analysis
- **Enhanced Security Workflow**: Improved security scanning integration
- **Build Validation**: Added security validation to CI/CD pipeline

#### Build System
- **Container Optimization**: Streamlined Dockerfile security patch application
- **Enhanced Validation**: Added comprehensive build-time security checks
- **GitIgnore Updates**: Extended `.gitignore` with comprehensive security scan result patterns

### 🔧 Technical Improvements

#### Container Logging
- **Log Optimization**: Refined container initialization logs to show only relevant warnings
- **Error Classification**: Distinguished between required and optional secret warnings
- **Debug Enhancement**: Improved debugging capabilities with cleaner log output

#### Secret Management
- **Enhanced FILE__ Processing**: Improved LinuxServer.io FILE__ prefix secret handling
- **Path Validation**: Added comprehensive path sanitization and validation
- **Error Handling**: Enhanced error reporting for secret configuration issues

### 📋 Configuration Updates

#### Environment Configuration
- **Security Patterns**: Updated `.gitignore` with comprehensive security scan result patterns
- **Documentation Alignment**: Ensured configuration documentation consistency across languages

### 🏗️ Infrastructure

#### GitHub Repository
- **Workflow Organization**: Organized GitHub Actions workflows for better maintainability
- **Security Integration**: Integrated security scanning into CI/CD pipeline
- **Compliance Validation**: Added OCI and LinuxServer.io compliance checks

### 📊 Metrics & Validation

#### Security Metrics
- **Vulnerability Reduction**: Achieved 68% reduction in container vulnerabilities
- **Scan Coverage**: Implemented dual-layer security scanning (container + code)
- **Automation Level**: Full automation of security scanning and reporting

#### Build Metrics
- **Multi-Architecture Support**: Maintained full AMD64, ARM64 compatibility (ARMv7 removed for stability)
- **OCI Compliance**: Validated OCI manifest list compliance
- **LinuxServer.io Standards**: Ensured full compliance with LinuxServer.io pipeline standards

---

### Version Numbering

This project follows semantic versioning with the following pattern:
- **Major.Minor.Patch-type.Build**
- Base version follows upstream Audiobookshelf version (2.29.0)
- Type indicators: `security`, `feature`, `bugfix`
- Build number for iterative improvements

### Links

- [Docker Hub Repository](https://hub.docker.com/r/mildman1848/audiobookshelf)
- [GitHub Repository](https://github.com/mildman1848/audiobookshelf)
- [Upstream Audiobookshelf](https://www.audiobookshelf.org/)
- [LinuxServer.io](https://www.linuxserver.io/)