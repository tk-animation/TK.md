param(
  [string]$VaultPath = "C:\Users\victo\OneDrive\Documents\Obsidian Vault\Japanese-Blog",
  [string]$ContentPath = (Join-Path $PSScriptRoot "..\content")
)

$ErrorActionPreference = "Stop"

$resolvedVault = Resolve-Path -LiteralPath $VaultPath
$resolvedContent = Resolve-Path -LiteralPath $ContentPath

Write-Host "Syncing Obsidian vault:"
Write-Host "  from $resolvedVault"
Write-Host "  to   $resolvedContent"

robocopy $resolvedVault $resolvedContent /MIR /XD ".obsidian" ".trash" ".git" /XF ".DS_Store" "Thumbs.db" "desktop.ini"
$robocopyExit = $LASTEXITCODE

if ($robocopyExit -gt 7) {
  throw "robocopy failed with exit code $robocopyExit"
}

Write-Host "Vault sync complete."
