# Security Policy

Thank you for helping maintain the security and integrity of Pigeon Studios resources.

This repository follows enterprise-grade security practices designed for production FiveM server infrastructure.

---

# 📚 Table of Contents

- Supported Versions
- Security Scope
- Reporting Vulnerabilities
- Responsible Disclosure
- Response Process
- Security Standards
- Repository Security
- Infrastructure Security
- Development Security
- Dependency Security
- Production Recommendations
- Disclosure Policy
- Legal Notice

---

# 🛡 Supported Versions

Only actively maintained versions receive security updates.

| Version | Supported |
|---|---|
| Latest Release | ✅ |
| Previous Minor Release | ✅ |
| Legacy Releases | ❌ |
| Deprecated Versions | ❌ |

Always upgrade to the latest stable release where possible.

---

# 🔍 Security Scope

This policy covers:

- source code vulnerabilities
- server-side validation flaws
- privilege escalation
- injection vulnerabilities
- persistence exploits
- event abuse
- duplication exploits
- authentication bypasses
- infrastructure vulnerabilities
- sensitive data exposure
- production deployment risks

---

# 🚨 Reporting Vulnerabilities

## Private Reporting Only

Do NOT publicly disclose security vulnerabilities.

Please report vulnerabilities privately through:

```text
pigeon@pigeonstudios.co.uk
```

---

## Include The Following

When reporting a vulnerability, include:

- affected resource
- affected version
- vulnerability summary
- reproduction steps
- proof of concept
- expected impact
- recommended mitigation (optional)

Providing detailed reports helps accelerate remediation.

---

# 🤝 Responsible Disclosure

Please:

- allow reasonable remediation time
- avoid public disclosure before resolution
- avoid exploiting vulnerabilities outside controlled testing
- avoid disrupting live production servers
- avoid accessing unauthorized systems or data

Responsible disclosure helps protect server operators and communities.

---

# 🔄 Response Process

Security reports are generally handled using the following process:

| Stage | Description |
|---|---|
| Acknowledgement | Initial review and confirmation |
| Validation | Vulnerability reproduction and verification |
| Mitigation | Internal remediation and patching |
| Release | Security update deployment |
| Disclosure | Optional coordinated disclosure |

Response times may vary depending on severity and complexity.

---

# 🔐 Security Standards

Pigeon Studios resources are developed using:

- server-side validation
- framework abstraction
- defensive event handling
- centralized validation systems
- secure repository workflows
- CI validation pipelines
- production-safe configuration systems
- configurable logging systems

---

# 🧱 Repository Security

This repository includes:

- protected branch workflows
- pull request validation
- CI validation pipelines
- CODEOWNERS review enforcement
- issue security templates
- security disclosure guidance
- secret prevention standards

---

# 🖥 Infrastructure Security

Recommended production infrastructure practices:

- protected GitHub branches
- isolated staging environments
- restricted deployment credentials
- secure webhook storage
- environment-based configuration
- private infrastructure secrets
- access control policies
- regular dependency reviews

---

# 👨‍💻 Development Security

Contributors should never commit:

- Discord webhooks
- API keys
- infrastructure credentials
- private endpoints
- production secrets
- sensitive deployment configuration
- internal authentication data

---

## If Secrets Are Committed

Immediately:

1. Rotate compromised credentials.
2. Remove secrets from repository history if necessary.
3. Notify repository maintainers.
4. Review infrastructure exposure.
5. Deploy updated credentials securely.

---

# 📦 Dependency Security

All dependencies should:

- remain actively maintained
- receive security updates
- avoid abandoned libraries
- avoid unnecessary packages
- remain version controlled
- be reviewed before deployment

Avoid introducing unnecessary external dependencies.

---

# 🚦 Production Recommendations

Recommended production configuration:

```lua
Config.Resource.Debug = false
```

Recommended deployment standards:

- CI validation enabled
- staging validation required
- semantic release tagging
- branch protection enabled
- production deployment reviews
- version-controlled deployments
- secure secret management

---

# 📢 Disclosure Policy

Pigeon Studios reserves the right to:

- patch vulnerabilities privately
- delay disclosure until remediation
- refuse disclosure of dangerous exploit details
- coordinate responsible disclosure timelines
- restrict publication of production attack methods

Public exploit releases targeting active production communities are strongly discouraged.

---

# ⚖ Legal Notice

Unauthorized exploitation, abuse, disruption, or malicious testing against live systems may violate applicable laws and platform policies.

Security research must remain lawful, ethical, and controlled.

---

# 📬 Contact

Security reports should be directed to:

```text
security@pigeonstudios.co.uk
```

For non-security support:
- open a GitHub Issue
- submit a Feature Request
- review repository documentation

---

# 🏢 Maintained By

Pigeon Studios

Built for secure, scalable, and production-grade FiveM infrastructure.