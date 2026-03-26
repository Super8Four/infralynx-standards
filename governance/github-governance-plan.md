# GitHub Governance Plan

## Required Shared Artifacts

- CODEOWNERS
- Issue templates: feature, bug, task, epic, security, docs
- Pull request template
- SECURITY.md
- CONTRIBUTING.md
- SUPPORT.md
- changelog policy

## Required Labels

- `type:feature`
- `type:bug`
- `type:task`
- `type:refactor`
- `domain:core`
- `domain:dcim`
- `domain:ipam`
- `domain:networking`
- `domain:virtualization`
- `priority:p0`
- `priority:p1`
- `priority:p2`
- `priority:p3`

## Branch Protection Targets

- `main`
- `develop`
- `release/*`

## Required Checks by Phase

### PR Validation

- lint
- type check
- unit tests
- build validation
- dependency scan

### Develop

- artifact build
- container build
- deploy to development
- smoke tests

### Release

- regression tests
- staging deployment
- release packaging

### Production

- manual approval gate
- production deployment
- rollback workflow

## Project Governance

- create a GitHub project board for cross-repository planning
- use milestones aligned to roadmap phases
- enforce review ownership through CODEOWNERS
