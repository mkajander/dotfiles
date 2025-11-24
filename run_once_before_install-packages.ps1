# run_once_before_install-packages.ps1.tmpl
# This script installs all required packages and dependencies on Windows.

$ErrorActionPreference = "Continue"

Write-Host "Installing dependencies for Windows..." -ForegroundColor Cyan
Write-Host ""

# Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget is not available. Please install App Installer from the Microsoft Store or update Windows." -ForegroundColor Red
    Write-Host ""
    Write-Host "Install these tools manually:" -ForegroundColor Yellow
    Write-Host "  - Git: https://git-scm.com/download/win"
    Write-Host "  - PowerShell 7+: https://aka.ms/powershell"
    Write-Host "  - Windows Terminal: https://aka.ms/terminal"
    exit 1
}

Write-Host "Installing packages with winget..." -ForegroundColor Cyan

# Essential tools
$packages = @(
    "Git.Git"                    # Git
    "Microsoft.PowerShell"       # PowerShell 7+
    "Microsoft.WindowsTerminal"  # Windows Terminal
    "Starship.Starship"          # Starship prompt
    "GitHub.cli"                 # GitHub CLI
    "eza-community.eza"          # Modern ls replacement
    "sharkdp.bat"                # bat (cat with syntax highlighting)
    "sharkdp.fd"                 # fd (fast find)
    "junegunn.fzf"               # fzf
    "ajeetdsouza.zoxide"         # zoxide (smarter cd)
    "JesseDuffield.lazygit"      # lazygit
    "Flow-Launcher.Flow-Launcher" # Flow Launcher
    "Microsoft.AzureCLI"         # Azure CLI
    "Schniz.fnm"                 # Fast Node Manager
)

foreach ($package in $packages) {
    Write-Host "Installing $package..." -ForegroundColor Green

    # Check if already installed
    $null = winget list --id $package --exact 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Already installed, skipping..." -ForegroundColor Gray
        continue
    }

    # Install the package
    winget install --id $package --exact --source winget `
        --accept-source-agreements --accept-package-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Successfully installed $package" -ForegroundColor Green
    } else {
        Write-Host "  Failed to install $package (exit code $LASTEXITCODE), continuing..." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Configuring PowerShell modules..." -ForegroundColor Cyan

# Configure PSGallery
try {
    $psGallery = Get-PSRepository -Name "PSGallery" -ErrorAction Stop
    if ($psGallery.InstallationPolicy -ne "Trusted") {
        Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
    }
} catch {
    Write-Host "Could not configure PSGallery repository, continuing..." -ForegroundColor Yellow
}

# Install PowerShell modules
$modules = @(
    "PSReadLine"
    "PSFzf"
    "posh-git"
    "Terminal-Icons"
)

foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "  Module $module already installed, skipping..." -ForegroundColor Gray
        continue
    }

    Write-Host "Installing PowerShell module: $module..." -ForegroundColor Green
    try {
        Install-Module -Name $module -Scope CurrentUser `
            -Force -SkipPublisherCheck -AllowClobber -ErrorAction Stop
        Write-Host "  Successfully installed $module" -ForegroundColor Green
    } catch {
        Write-Host "  Failed to install ${module}: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Package installation complete." -ForegroundColor Green
Write-Host "You may need to restart your terminal for all changes to take effect." -ForegroundColor Yellow
exit 0
