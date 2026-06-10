param(
  [string]$VaultPath = "C:\Users\victo\OneDrive\Documents\Obsidian Vault\Japanese-Blog",
  [string]$CommitMessage = "Deploy static Quartz site"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$Parent = Split-Path $RepoRoot
$PagesWorktree = Join-Path $Parent "japanese-blog-quartz-gh-pages"

Push-Location $RepoRoot
try {
  & (Join-Path $PSScriptRoot "sync-vault.ps1") -VaultPath $VaultPath

  node --import tsx -e "import('./quartz/plugins/loader/gitLoader.ts').then(m => m.regeneratePluginIndex({ verbose: true }))"
  npx quartz build

  if (-not (Test-Path -LiteralPath $PagesWorktree)) {
    git worktree add -B gh-pages $PagesWorktree
  }

  $resolvedWorktree = Resolve-Path -LiteralPath $PagesWorktree
  if (-not ($resolvedWorktree.Path.StartsWith($Parent, [System.StringComparison]::OrdinalIgnoreCase))) {
    throw "Refusing to clean unexpected worktree path: $resolvedWorktree"
  }

  Get-ChildItem -LiteralPath $resolvedWorktree -Force |
    Where-Object { $_.Name -ne ".git" } |
    Remove-Item -Recurse -Force

  robocopy (Join-Path $RepoRoot "public") $resolvedWorktree /E /XD ".git"
  $robocopyExit = $LASTEXITCODE
  if ($robocopyExit -gt 7) {
    throw "robocopy failed with exit code $robocopyExit"
  }

  New-Item -ItemType File -Path (Join-Path $resolvedWorktree ".nojekyll") -Force | Out-Null

  git -C $resolvedWorktree add -A
  $changes = git -C $resolvedWorktree status --porcelain
  if (-not $changes) {
    Write-Host "No static site changes to publish."
    exit 0
  }

  git -C $resolvedWorktree commit -m $CommitMessage
  git -C $resolvedWorktree push -u origin gh-pages
} finally {
  Pop-Location
}
