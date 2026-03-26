# GitHub Governance Rollout

This document closes the operational gap between governance definitions in `infralynx-standards` and live GitHub repository configuration.

## What This Rollout Applies

- repository default settings,
- labels,
- milestones,
- shared issue templates,
- shared pull request templates,
- CODEOWNERS,
- CONTRIBUTING.md,
- SECURITY.md,
- SUPPORT.md,
- optional `develop` branch creation,
- optional branch protection on `main` and `develop`.

## Usage

Run from `infralynx-standards` in a normal PowerShell session with authenticated `gh` access:

```powershell
Set-Location D:\Project\InfraLynx\infralynx-standards
.\tools\apply-github-governance.ps1 -PushTemplates -CreateDevelopBranches -ApplyBranchProtection
```

## Notes

- Branch protection requires the `develop` branch to exist first.
- `release/*` protection is not directly handled by this script because GitHub pattern-based protection is better managed through rulesets after CI checks are defined.
- Status checks are intentionally not enforced yet because the required workflows do not exist until later chunks.
