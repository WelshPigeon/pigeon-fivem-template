# Contributing Guidelines

Thank you for contributing to this Pigeon Studios repository.

This project is maintained as enterprise-grade FiveM infrastructure and follows strict production development standards.

All changes should be:
- reviewed properly,
- validated carefully,
- documented clearly,
- and tested before merging into protected branches.

---

# 📚 Table of Contents

- Repository Workflow
- Branch Strategy
- Branch Naming
- Pull Request Standards
- Local Development
- Validation Requirements
- Security Requirements
- Coding Standards
- Configuration Standards
- Database & Migration Standards
- Commit Standards
- Release Process
- Testing Checklist
- Production Deployment
- Ownership

---

# 🌳 Repository Workflow

This repository uses a structured multi-branch workflow.

| Branch | Purpose |
|---|---|
| `main` | Production-ready branch used for stable releases and live deployments |
| `staging` | Pre-production validation and staging environment |
| `development` | Active development branch |
| `feature/*` | New features and functionality |
| `fix/*` | Standard bug fixes |
| `hotfix/*` | Emergency production fixes |
| `docs/*` | Documentation updates |
| `infra/*` | Infrastructure and CI changes |

---

# 🔀 Branch Strategy

## `main`

The `main` branch must always remain production-ready.

Only validated and reviewed code should reach `main`.

Expected workflow:

```text
development → staging → main
```

Direct commits to `main` should be avoided.

---

## `staging`

The `staging` branch is used for:

- pre-production validation
- infrastructure testing
- migration validation
- dependency verification
- CI confirmation
- compatibility testing

This branch should mirror production as closely as possible.

---

## `development`

The `development` branch is used for:

- active feature development
- integrations
- bug fixing
- experimentation
- internal validation

Most pull requests should target `development`.

---

# 🏷 Branch Naming Standards

Use descriptive and consistent branch names.

## Recommended Formats

```text
feature/descriptive-feature-name
fix/descriptive-bug-fix
hotfix/descriptive-production-fix
docs/descriptive-documentation-update
infra/descriptive-infrastructure-change
```

## Examples

```text
feature/persistent-inventory-system
fix/version-check-timeout
hotfix/database-validation-fix
docs/update-installation-guide
infra/add-ci-validation
```

Avoid:
- vague names,
- random identifiers,
- personal shorthand,
- or unclear terminology.

---

# 🔁 Pull Request Standards

All pull requests should include:

- clear summaries
- implementation details
- testing information
- deployment impact
- migration impact
- compatibility considerations
- security review confirmation

Pull requests should remain:
- focused,
- isolated,
- and logically grouped.

Avoid extremely large pull requests where possible.

---

# 🧪 Local Development

## Required Dependencies

```cfg
ensure ox_lib
ensure oxmysql
```

## Optional Dependencies

```cfg
ensure ox_inventory
ensure ox_target
```

## Start Resource

```cfg
ensure RESOURCE_NAME
```

---

# ✅ Validation Requirements

Before submitting changes, verify:

- resource starts successfully
- no Lua syntax errors exist
- no console errors are present
- version checker functions correctly
- configuration loads correctly
- framework integrations function correctly
- exports function correctly
- no debug spam exists
- localisation loads correctly

---

# 🔐 Security Requirements

Never commit:

- Discord webhooks
- API keys
- private endpoints
- internal infrastructure information
- development credentials
- production configuration secrets
- environment-specific sensitive data

If sensitive information is committed accidentally:

1. Rotate the compromised credential immediately.
2. Remove the secret from repository history if required.
3. Notify the repository owner.
4. Submit a security follow-up if applicable.

---

# 🧱 Coding Standards

All code should remain:

- readable
- maintainable
- defensive
- config-driven
- production-safe
- performance-conscious
- consistent with repository standards

---

## Recommended Practices

Prefer:
- reusable abstractions
- centralized utilities
- shared validation
- configuration-driven behaviour
- scalable architecture
- defensive event handling

---

## Avoid

Avoid:
- hardcoded secrets
- unsafe client trust
- unvalidated payloads
- excessive production logging
- unnecessary dependencies
- duplicated logic
- random formatting styles

---

# ⚙️ Configuration Standards

Configuration systems should:

- remain centralized
- support scalability
- avoid hardcoded values
- support framework abstraction
- support localisation
- support optional integrations

Configuration should always remain production-safe by default.

---

# 🗄 Database & Migration Standards

Database systems must:

- avoid destructive operations
- remain backward compatible where possible
- validate data before modification
- recover gracefully from failures
- log migration behaviour properly

Migration systems should prioritise:

- automatic recovery
- resilience
- validation
- safe upgrade paths

over manual intervention requirements.

---

# 📝 Commit Standards

Use clear and descriptive commit titles.

## Good Examples

```text
Add framework abstraction support
Improve notification validation handling
Fix version checker timeout issue
Add localisation loading system
Update CI validation workflow
```

## Bad Examples

```text
fix
changes
stuff
final
update
misc
```

Commits should clearly describe:
- what changed,
- and why it changed.

---

# 🚀 Release Process

Recommended release flow:

```text
development → staging → main → release tag
```

---

## Semantic Versioning

This repository follows semantic versioning.

| Version Type | Description |
|---|---|
| Major | Breaking changes |
| Minor | New functionality |
| Patch | Fixes and optimisations |

## Examples

```text
v1.0.0
v1.1.0
v1.1.1
```

---

# ✅ Testing Checklist

Before merging:

- [ ] Resource starts successfully
- [ ] No Lua syntax errors exist
- [ ] No console errors are present
- [ ] Version checker functions correctly
- [ ] Framework integrations validated
- [ ] Localisation validated
- [ ] Configuration validated
- [ ] No secrets committed
- [ ] CI passes successfully
- [ ] Documentation updated if required

---

# 🏭 Production Deployment

Production deployments should only run from:

```text
main
```

Staging validation should run from:

```text
staging
```

Development environments should never directly impact live production systems.

---

# 👥 Ownership

This repository is maintained by Pigeon Studios.

All contributions must follow:
- repository standards,
- branch protection rules,
- licensing requirements,
- and security policies.

Failure to follow repository standards may result in pull requests being rejected.