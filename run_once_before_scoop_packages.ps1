# run_once_before_scoop_packages.ps1.tmpl
# This script installs Scoop (as current user) and lazydocker, if possible.

$ErrorActionPreference = "Continue"

Write-Host "Checking Scoop and lazydocker setup..." -ForegroundColor Cyan
Write-Host ""

# Detect if running as admin – Scoop does not support being installed as admin.
$windowsIdentity  = [Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = New-Object Security.Principal.WindowsPrincipal($windowsIdentity)
$isAdmin = $windowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    Write-Host "Running as administrator. Scoop installation is skipped (Scoop should be installed as a normal user)." -ForegroundColor Yellow
    Write-Host "If you want lazydocker via Scoop, run 'chezmoi apply' from a non-admin PowerShell later." -ForegroundColor Yellow
    exit 0
}

# If lazydocker already exists, we are done.
if (Get-Command lazydocker -ErrorAction SilentlyContinue) {
    Write-Host "lazydocker is already installed, skipping Scoop setup." -ForegroundColor Gray
    exit 0
}

# Check if Scoop is installed
$scoopCmd = Get-Command scoop -ErrorAction SilentlyContinue

if (-not $scoopCmd) {
    Write-Host "Scoop is not installed. Installing Scoop for the current user..." -ForegroundColor Yellow

    try {
        # Allow the install script to run in this process
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

        Invoke-Expression (Invoke-WebRequest -UseBasicParsing -Uri 'https://get.scoop.sh').Content

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
