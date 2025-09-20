# Security Policy

> 🇬🇧 **English Version** | 🇩🇪 **[Deutsche Version](SECURITY.de.md)**

## Reporting Security Vulnerabilities

We take the security of our Audiobookshelf Docker image seriously. If you discover a security vulnerability, please help us maintain the security of our project by reporting it responsibly.

### 🔒 How to Report

**DO NOT** create a public GitHub issue for security vulnerabilities. Instead, please use one of the following secure channels:

#### GitHub Security Advisories (Preferred)
1. Go to the [Security tab](https://github.com/mildman1848/audiobookshelf/security/advisories) of this repository
2. Click "Report a vulnerability"
3. Fill out the vulnerability report form with detailed information
4. Submit the report

#### Email Reporting
If GitHub Security Advisories are not available, you can email security reports to:
- **Email**: [Create an issue](https://github.com/mildman1848/audiobookshelf/issues/new?template=security_report.md) with `[SECURITY]` prefix (this will be made private)

### 📋 Information to Include

When reporting a security vulnerability, please include:

- **Vulnerability Type**: (e.g., SQL Injection, XSS, Authentication Bypass, etc.)
- **Affected Component**: Specify which part of the system is affected
  - Docker image/container
  - S6 services
  - Configuration files
  - Build process
  - Dependencies
- **Attack Vector**: How the vulnerability can be exploited
- **Impact**: What an attacker could achieve
- **Proof of Concept**: Steps to reproduce (if safe to do so)
- **Suggested Fix**: If you have ideas for remediation
- **Environment Details**:
  - Docker image version
  - Host operating system
  - Container runtime version

### 🛡️ Scope

This security policy covers vulnerabilities in:

#### ✅ In Scope
- **Docker Image Security**
  - Container escape vulnerabilities
  - Privilege escalation issues
  - Insecure default configurations
- **Application Security**
  - Authentication/authorization flaws
  - Input validation issues
  - Secret exposure
- **Build Process Security**
  - Supply chain attacks
  - Malicious dependencies
  - Insecure build configurations
- **S6 Overlay Services**
  - Service configuration vulnerabilities
  - Inter-service communication issues
- **LinuxServer.io Compliance**
  - FILE__ prefix security issues
  - Docker Mods vulnerabilities
  - Custom script injection

#### ❌ Out of Scope
- **Upstream Audiobookshelf Application**
  - Please report to the [official Audiobookshelf repository](https://github.com/advplyr/audiobookshelf)
- **LinuxServer.io Base Image**
  - Please report to [LinuxServer.io](https://github.com/linuxserver/docker-baseimage-alpine)
- **Third-party Dependencies**
  - Report directly to the respective maintainers
- **Infrastructure Issues**
  - Host system vulnerabilities
  - Network configuration issues
  - Registry/distribution vulnerabilities

### ⏱️ Response Timeline

We aim to respond to security reports according to the following timeline:

| Severity | Initial Response | Investigation | Resolution |
|----------|-----------------|---------------|------------|
| **Critical** | Within 24 hours | Within 72 hours | Within 7 days |
| **High** | Within 48 hours | Within 5 days | Within 14 days |
| **Medium** | Within 72 hours | Within 10 days | Within 30 days |
| **Low** | Within 1 week | Within 2 weeks | Next minor release |

### 🔐 Security Measures

Our Docker image implements several security measures:

#### Container Security
- **Non-root execution** - Runs as user `abc` (UID 911)
- **Capability dropping** - ALL capabilities dropped, minimal required added
- **Security hardening** - `no-new-privileges`, security-opt configurations
- **Read-only filesystem** - Where possible with tmpfs for temporary files
- **UMASK enforcement** - Proper file permissions (750/640)

#### Secret Management
- **LinuxServer.io FILE__ prefix** - Secure secret handling
- **512-bit JWT secrets** - Strong cryptographic keys
- **Path validation** - Prevents path traversal attacks
- **Automatic rotation** - Built-in secret rotation capabilities

#### Build Security
- **Multi-stage builds** - Minimal attack surface
- **Dependency scanning** - Automated vulnerability scanning with Trivy
- **SBOM generation** - Software Bill of Materials for transparency
- **Provenance attestation** - Build integrity verification

#### Supply Chain Security
- **Base image verification** - Official LinuxServer.io Alpine base
- **Dependency pinning** - Specific versions to prevent drift
- **Automated updates** - Dependabot for security updates
- **CI/CD security** - Signed commits and protected workflows

### 🏆 Recognition

We believe in recognizing security researchers who help improve our project's security:

- **Acknowledgment** - We will publicly acknowledge your contribution (with your permission)
- **Hall of Fame** - Recognition in our security hall of fame
- **Priority Support** - Fast-track support for your issues and questions

### 📚 Security Resources

#### Secure Configuration
- Follow our [LinuxServer.io Compliance Guide](LINUXSERVER.md)
- Use recommended [environment variables](.env.example)
- Implement [best practices](README.md#security) from our documentation

#### Security Tools
- **Container Scanning**: `make security-scan` (Trivy)
- **Dockerfile Linting**: `make validate` (Hadolint)
- **Environment Validation**: `make env-validate`
- **Health Monitoring**: `make status`

#### External Resources
- [OWASP Container Security](https://owasp.org/www-project-container-security/)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [LinuxServer.io Security Guidelines](https://docs.linuxserver.io/FAQ#security)

### 🔄 Security Updates

We regularly update our security measures:

- **Monthly Reviews** - Regular security assessment of dependencies
- **Automated Scanning** - Continuous vulnerability monitoring
- **Patch Management** - Rapid deployment of security fixes
- **Documentation Updates** - Keep security guidelines current

### 📞 Contact

For non-security related issues:
- **General Issues**: [GitHub Issues](https://github.com/mildman1848/audiobookshelf/issues)
- **Questions**: [GitHub Discussions](https://github.com/mildman1848/audiobookshelf/discussions)
- **Documentation**: [README.md](README.md)

### 📄 Legal

- We will not pursue legal action against security researchers who follow this policy
- We ask that you do not publicly disclose vulnerabilities until we have had a chance to address them
- Please act in good faith and avoid privacy violations, data destruction, or service disruption

---

**Last Updated**: September 2025
**Policy Version**: 1.0
**Next Review**: June 2026