param(
  [string]$Owner = "Super8Four",
  [switch]$PushTemplates,
  [switch]$ApplyBranchProtection,
  [switch]$CreateDevelopBranches
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$standardsRoot = Split-Path -Parent $scriptRoot
$config = Get-Content (Join-Path $scriptRoot "repos.json") | ConvertFrom-Json
$labels = Get-Content (Join-Path $standardsRoot ".github\labels.json") | ConvertFrom-Json
$issueTemplates = Join-Path $standardsRoot ".github\ISSUE_TEMPLATE"
$prTemplates = Join-Path $standardsRoot ".github\PULL_REQUEST_TEMPLATE"
$codeowners = Join-Path $standardsRoot ".github\CODEOWNERS"
$contributing = Join-Path $standardsRoot "CONTRIBUTING.md"
$security = Join-Path $standardsRoot "SECURITY.md"
$support = Join-Path $standardsRoot "SUPPORT.md"
$mainProtection = Join-Path $scriptRoot "branch-protection-main.json"
$developProtection = Join-Path $scriptRoot "branch-protection-develop.json"

function Ensure-Label {
  param(
    [string]$Repo,
    $Label
  )

  gh label create $Label.name --repo $Repo --color $Label.color --description $Label.description 2>$null | Out-Null
  if ($LASTEXITCODE -ne 0) {
    gh label edit $Label.name --repo $Repo --color $Label.color --description $Label.description | Out-Null
  }
}

function Ensure-Milestone {
  param(
    [string]$Repo,
    [string]$Title
  )

  $escaped = $Title.Replace("'", "''")
  gh api "repos/$Repo/milestones" --paginate | ConvertFrom-Json | Where-Object { $_.title -eq $Title } | Select-Object -First 1 | ForEach-Object { return }
  gh api "repos/$Repo/milestones" --method POST --field title="$Title" | Out-Null
}

function Copy-GovernanceFiles {
  param(
    [string]$RepoName
  )

  $repoRoot = Join-Path (Split-Path $standardsRoot -Parent) $RepoName
  $repoGitHub = Join-Path $repoRoot ".github"
  $repoIssues = Join-Path $repoGitHub "ISSUE_TEMPLATE"
  $repoPRs = Join-Path $repoGitHub "PULL_REQUEST_TEMPLATE"

  New-Item -ItemType Directory -Force -Path $repoIssues | Out-Null
  New-Item -ItemType Directory -Force -Path $repoPRs | Out-Null

  Copy-Item "$issueTemplates\*" -Destination $repoIssues -Force
  Copy-Item "$prTemplates\*" -Destination $repoPRs -Force
  Copy-Item $codeowners -Destination (Join-Path $repoGitHub "CODEOWNERS") -Force
  Copy-Item $contributing -Destination (Join-Path $repoRoot "CONTRIBUTING.md") -Force
  Copy-Item $security -Destination (Join-Path $repoRoot "SECURITY.md") -Force
  Copy-Item $support -Destination (Join-Path $repoRoot "SUPPORT.md") -Force

  git -C $repoRoot add .github CONTRIBUTING.md SECURITY.md SUPPORT.md
  git -C $repoRoot diff --cached --quiet
  if ($LASTEXITCODE -ne 0) {
    git -C $repoRoot commit -m "Apply shared GitHub governance baseline"
    git -C $repoRoot push origin main
  }
}

foreach ($repoName in $config.repositories) {
  $repo = "$Owner/$repoName"
  Write-Host "Applying GitHub governance to $repo" -ForegroundColor Cyan

  gh repo edit $repo --enable-issues=true --enable-projects=true --enable-wiki=false --delete-branch-on-merge=true --default-branch main | Out-Null

  foreach ($label in $labels) {
    Ensure-Label -Repo $repo -Label $label
  }

  foreach ($milestone in $config.milestones) {
    Ensure-Milestone -Repo $repo -Title $milestone
  }

  if ($CreateDevelopBranches) {
    git -C (Join-Path (Split-Path $standardsRoot -Parent) $repoName) rev-parse --verify develop 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
      git -C (Join-Path (Split-Path $standardsRoot -Parent) $repoName) checkout -b develop
      git -C (Join-Path (Split-Path $standardsRoot -Parent) $repoName) push -u origin develop
      git -C (Join-Path (Split-Path $standardsRoot -Parent) $repoName) checkout main
    }
  }

  if ($PushTemplates -and $repoName -ne 'infralynx-standards') {
    Copy-GovernanceFiles -RepoName $repoName
  }

  if ($ApplyBranchProtection) {
    gh api "repos/$repo/branches/main/protection" --method PUT --input $mainProtection | Out-Null
    gh api "repos/$repo/branches/develop/protection" --method PUT --input $developProtection | Out-Null
  }
}

Write-Host "Governance rollout complete." -ForegroundColor Green
