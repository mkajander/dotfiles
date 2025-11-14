# run_once_before_scoop_packages.ps1.tmpl
# This script installs Scoop (as current user) and lazydocker, if possible.

$ErrorActionPreference = "Continue"

Write-Host "Checking Scoop and lazydocker setup..." -ForegroundColor Cyan
Write-Host ""
# Check if Scoop is installed
$scoopCmd = Get-Command scoop -ErrorAction SilentlyContinue

if (-not $scoopCmd) {
    Write-Host "Scoop is not installed. Installing Scoop for the current user..." -ForegroundColor Yellow

    try {
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

        $scoopCmd = Get-Command scoop -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Failed to install Scoop: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "You may need to install Scoop manually from https://scoop.sh/." -ForegroundColor Yellow
        exit 0
    }
}

if ($scoopCmd) {
    Write-Host "Scoop is available. Ensuring 'extras' bucket and installing lazydocker..." -ForegroundColor Green

    try {
        scoop bucket add extras 2>$null
    } catch {
        Write-Host "Warning: could not add 'extras' bucket (it may already exist): $($_.Exception.Message)" -ForegroundColor Yellow
    }

    scoop install lazydocker 

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully installed lazydocker via Scoop." -ForegroundColor Green
    } else {
        Write-Host "Failed to install lazydocker via Scoop (exit code $LASTEXITCODE)." -ForegroundColor Yellow
        Write-Host "You may need to install lazydocker manually (Scoop or Chocolatey)." -ForegroundColor Yellow
    }
} else {
    Write-Host "Scoop is still not available after attempted install. Please install lazydocker manually." -ForegroundColor Yellow
}

exit 0
