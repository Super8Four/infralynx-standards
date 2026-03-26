# Branching Strategy

InfraLynx uses the following branch model:

- `main` for production
- `develop` for integration
- `release/*` for release preparation
- `hotfix/*` for urgent production fixes
- `domain/core`
- `domain/ipam`
- `domain/dcim`
- `domain/networking`
- `domain/virtualization`
- `feature/*`
- `bugfix/*`

Rules:

- No direct commits to `main` or `develop`
- All shared work flows through pull requests
- Protected branches require approvals and checks
