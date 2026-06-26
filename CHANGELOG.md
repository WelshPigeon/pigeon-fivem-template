# Changelog

All notable changes to this repository should be documented through GitHub Releases.

This file exists as a high-level release reference for the template itself. Individual resource changelogs should live in the body of each GitHub Release so `server/version_check.lua` can display them in the FiveM console.

## Versioning Standard

This repository follows semantic versioning:

```text
MAJOR.MINOR.PATCH
```

- Major: breaking changes or major architectural rewrites
- Minor: new features or compatible system additions
- Patch: fixes, optimisation, maintenance, and documentation updates

## Release Workflow

Recommended flow:

```text
development -> staging -> main -> GitHub Release
```

Release checklist:

1. Update `version` in `fxmanifest.lua`.
2. Commit and push changes.
3. Create a GitHub Release with a matching tag, for example `v1.0.1`.
4. Add release notes to the GitHub Release body.
5. Verify the resource version checker on startup.

## [v1.0.0] - YYYY-MM-DD

Initial production template release.

Added:

- FiveM `fxmanifest.lua`
- PSG metadata fields
- GitHub Releases version checker
- client/server/shared/configuration layout
- localisation folder structure
- optional NUI structure
- GitHub Actions CI validation
- issue templates and pull request template
- contribution and security documentation
