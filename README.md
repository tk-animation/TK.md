# Japanese Blog Quartz

This Quartz site publishes the Obsidian vault at:

```text
C:\Users\victo\OneDrive\Documents\Obsidian Vault\Japanese-Blog
```

## Local preview

```powershell
.\scripts\sync-vault.ps1
npx quartz build --serve
```

Quartz serves the site at `http://localhost:8080`.

## Publish from Obsidian

After setting this repo's `origin` remote to your own GitHub repository:

```powershell
.\scripts\publish-from-vault.ps1
```

That script mirrors the Obsidian vault into `content/`, builds the site, commits changes, and pushes them. GitHub Actions then deploys the site to GitHub Pages.

If GitHub Actions is unavailable, publish the generated static site directly to a `gh-pages` branch:

```powershell
.\scripts\publish-static-pages.ps1
```

Then set GitHub Pages to **Deploy from a branch**, branch `gh-pages`, folder `/ (root)`.

## Daily automatic publishing

Register a Windows Scheduled Task:

```powershell
.\scripts\register-daily-publish-task.ps1 -At "20:00"
```

The task runs `publish-from-vault.ps1` every day. Change the time if you want publishing to happen earlier or later.
