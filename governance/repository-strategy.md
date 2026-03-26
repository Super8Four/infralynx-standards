# Repository Strategy

## Repository Roles

### infralynx-platform

- Owns application runtime code
- Owns backend services, frontend application, shared libraries, and test suites
- Owns database abstraction and migration implementation

### infralynx-docs

- Owns all long-lived documentation
- Owns ADRs, product docs, engineering docs, operations docs, release notes, and contributor guidance

### infralynx-infra

- Owns deployment definitions, environment provisioning, container orchestration assets, and future cloud delivery configuration

### infralynx-standards

- Owns GitHub templates, shared policies, governance documents, and collaboration conventions

### infralynx-design

- Owns design system guidance, UX flows, mockups, visual assets, and design review artifacts

## Working Model

- `main` is production-only
- `develop` is integration
- `release/*` is for release stabilization
- `hotfix/*` is for production remediation
- `domain/*` branches are temporary domain integration branches
- `feature/*` and `bugfix/*` branches are short-lived delivery branches

## Guardrails

- No direct commits to `main` or `develop`
- Pull requests are required for all shared branches
- Protected branches require successful checks and approvals
- Governance artifacts are defined centrally before repo-specific rollout
