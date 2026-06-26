# RESOURCE_NAME

Enterprise-grade FiveM resource template by Pigeon Studios Group.

This repository is designed as the starting point for PSG FiveM resources. It includes a production-ready layout, shared configuration, client/server entry points, localisation folders, GitHub issue templates, CI validation, and the PSG version registry checker.

## Quick Start

```bash
git clone https://github.com/WelshPigeon/RESOURCE_NAME
```

Move the resource into your FiveM server:

```text
resources/[standalone]/RESOURCE_NAME
```

Ensure dependencies before the resource:

```cfg
ensure ox_lib
ensure oxmysql
ensure RESOURCE_NAME
```

## Template Setup

When creating a new resource from this template, update:

```lua
name 'RESOURCE_NAME'
description 'RESOURCE_NAME by Pigeon Studios Group.'
version '1.0.0'
repository 'https://github.com/WelshPigeon/RESOURCE_NAME'

psg_name 'RESOURCE_NAME'
psg_version_slug 'resource-name'
provide 'RESOURCE_NAME'
```

Also update resource event names in `client/client.lua` and `server/server.lua` if they still contain `pigeon-fivem-template`.

## Versioning

The source of truth for the installed resource version is `fxmanifest.lua`:

```lua
version '1.0.0'
```

Remote version checks use the PSG version registry:

- latest version: `version` inside `pigeon-resource-versions/<slug>/latest.json`
- changelog: `notes` inside `pigeon-resource-versions/<slug>/latest.json`
- registry slug: `psg_version_slug` metadata in `fxmanifest.lua`

The old loose `version` and `changelog.txt` files are no longer required.

## Release Flow

1. Update `version` in `fxmanifest.lua`.
2. Commit and push the resource.
3. Create a GitHub Release with a matching tag, for example `v1.0.1`.
4. Put the changelog in the GitHub Release body.
5. Restart the resource/server and the checker will compare installed vs latest.

## Repository Structure

```text
.
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |-- workflows/
|   `-- pull_request_template.md
|-- client/
|   `-- client.lua
|-- configuration/
|   `-- config.lua
|-- locales/
|   `-- en.json
|-- server/
|   |-- server.lua
|   `-- version_check.lua
|-- shared/
|   `-- shared.lua
|-- web/
|   `-- img/
|-- fxmanifest.lua
|-- README.md
|-- CHANGELOG.md
|-- CONTRIBUTING.md
|-- LICENSE
`-- SECURITY.md
```

## Dependencies

Required by default:

- `ox_lib`
- `oxmysql`

Optional integrations are configured in `configuration/config.lua`:

- QBCore
- Qbox
- ESX
- Standalone
- ox_inventory
- ox_target

## Configuration

Primary configuration lives in:

```text
configuration/config.lua
```

The template includes sections for:

- resource information
- framework selection
- notifications
- target system
- inventory system
- locale
- logging
- validation
- performance
- developer options
- feature flags

## Version Checker

`server/version_check.lua` is loaded before `server/server.lua`.

It reads:

```lua
version '1.0.0'
repository 'WelshPigeon/RESOURCE_NAME'
psg_name 'RESOURCE_NAME'
psg_brand 'Pigeon Studios Group'
psg_website 'https://pigeonstudios.co.uk'
psg_version_slug 'resource-name'
```

Supported registry slug examples:

```lua
psg_version_slug 'payroll'
psg_version_slug 'pigeon-trash'
psg_version_slug 'taser-cartridge-system'
```

## NUI

NUI is optional. The manifest includes only the banner image by default.

When a resource needs a web UI, add the files under `web/` and uncomment the NUI block in `fxmanifest.lua`.

## CI

The GitHub Actions workflow validates:

- required files
- required folders
- `fxmanifest.lua` version format
- PSG versioning metadata
- forbidden secret-like strings
- leftover placeholders
- Lua syntax
- JSON syntax
- basic manifest fields

## Security

Do not commit secrets, tokens, webhooks, API keys, or private configuration.

Use `SECURITY.md` for vulnerability reporting instructions and keep production credentials outside the repository.

## License

This template is proprietary to Pigeon Studios Group unless a project-specific license says otherwise.

## Credits

Created and maintained by Pigeon Studios Group.
