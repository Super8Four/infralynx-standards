# Branch Protection Policy

## Protected Branches

- `main`
- `develop`
- `release/*`

## Required Controls

- Require a pull request before merging
- Require at least 1 approving review
- Dismiss stale approvals after new commits
- Require CODEOWNERS review
- Require status checks to pass
- Require the branch to be up to date before merge
- Disable force pushes
- Disable deletions

## Required Checks

### `main`

- release-validation
- regression-tests
- approval-gate

### `develop`

- lint
- type-check
- unit-tests
- build-validation
- dependency-scan

### `release/*`

- build-validation
- regression-tests
- staging-deployment-verification
