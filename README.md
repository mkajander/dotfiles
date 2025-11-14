# Dotfiles

A cross-platform dotfiles repository managed with [chezmoi](https://www.chezmoi.io/), supporting **Windows** (PowerShell), **macOS**, and **Linux** (Zsh) environments.

## 📋 Overview

This repository contains my personal configuration files (dotfiles) for a consistent development environment across multiple operating systems. It includes:

- **Shell configurations**: Zsh (macOS/Linux) with Oh My Zsh and PowerShell (Windows)
- **Modern CLI tools**: Enhanced replacements for common commands (eza, bat, fzf, zoxide)
- **Development tools**: Git, GitHub CLI, Azure CLI, Node.js (via fnm/nvm), Docker utilities
- **Automated setup**: OS-specific package installation scripts
- **Modular design**: Organized configuration files for easy maintenance and customization

## ✅ Prerequisites

### All Platforms
- **[chezmoi](https://www.chezmoi.io/)** - Dotfile manager
- **Git** - Version control

### Windows
- **Windows 10/11**
- **PowerShell 7+** (PowerShell Core)
- **Windows Terminal** (recommended)
- **winget** (Windows Package Manager) - Usually pre-installed on Windows 11

### macOS
- **macOS 10.15+**
- **[Homebrew](https://brew.sh/)** - Package manager
- **Zsh** (default shell on modern macOS)

### Linux
- **Ubuntu/Debian** or compatible distribution
- **[Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux)** (Linuxbrew)
- **Zsh** shell

## 🚀 Installation

### Quick Start (New Machine)

1. **Install chezmoi and initialize with this repository:**

   ```bash
   # macOS/Linux
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mkajander/dotfiles

   # Windows (PowerShell)
   (irm -useb https://get.chezmoi.io/ps1) | powershell -c -
   chezmoi init --apply mkajander/dotfiles
   ```

2. **Restart your terminal** to load the new configuration.

### Manual Installation

1. **Install chezmoi:**

   ```bash
   # macOS
   brew install chezmoi

   # Linux
   brew install chezmoi
   # or
   snap install chezmoi --classic

   # Windows (PowerShell)
   winget install twpayne.chezmoi
   ```

2. **Initialize chezmoi with this repository:**

   ```bash
   chezmoi init https://github.com/mkajander/dotfiles.git
   ```

3. **Preview changes before applying:**

   ```bash
   chezmoi diff
   ```

4. **Apply the dotfiles:**

   ```bash
   chezmoi apply -v
   ```

   This will:
   - Copy configuration files to your home directory
   - Run OS-specific package installation scripts (`run_once_before_*.ps1` or `run_once_before_*.sh`)
   - Install required tools and dependencies

5. **Restart your terminal** to load the new configuration.

## 📁 Repository Structure

```
.
├── .chezmoi.toml.tmpl              # Chezmoi configuration
├── .chezmoiignore                  # Files to ignore per OS
├── dot_zshrc.tmpl                  # Main Zsh configuration (macOS/Linux)
├── private_dot_zsh/                # Modular Zsh configuration
│   ├── 00-init.zsh.tmpl           # PATH, exports, Powerlevel10k
│   ├── 10-tools.zsh.tmpl          # Tool configs (fzf, bat, eza, etc.)
│   ├── 20-functions.zsh.tmpl      # Custom shell functions
│   ├── 30-os-specific.zsh.tmpl    # OS-specific settings
│   └── 99-final.zsh.tmpl          # Completions and cleanup
├── OneDrive/Documents/PowerShell/
│   └── Microsoft.PowerShell_profile.ps1.tmpl  # Main PowerShell profile (Windows)
├── private_dot_config/powershell/  # Modular PowerShell configuration
│   ├── 00-init.ps1.tmpl           # PATH, exports, Starship
│   ├── 10-tools.ps1.tmpl          # Tool configs (PSReadLine, fzf, etc.)
│   ├── 20-functions.ps1.tmpl      # Custom PowerShell functions
│   └── 30-os-specific.ps1.tmpl    # OS-specific settings
├── run_once_before_install-packages.ps1  # Windows package installer
├── run_once_before_scoop_packages.ps1    # Scoop setup (Windows)
└── run_once_before_install-packages.sh.tmpl  # macOS/Linux package installer
```

### File Naming Convention

Chezmoi uses special prefixes to determine how files are managed:

- `dot_` → `.` (creates dotfiles, e.g., `dot_zshrc` → `.zshrc`)
- `private_` → Files with restricted permissions (chmod 600)
- `run_once_before_` → Scripts that run once before applying dotfiles
- `.tmpl` → Go templates (processed with OS-specific logic)

## 🔧 Usage

### Common Workflows

**Update dotfiles from repository:**
```bash
chezmoi update -v
```

**Edit a dotfile:**
```bash
# Opens the source file in your $EDITOR
chezmoi edit ~/.zshrc

# Or edit directly in the source directory
chezmoi cd
# Make changes, then exit
```

**Add a new dotfile to the repository:**
```bash
chezmoi add ~/.gitconfig
```

**Apply changes after editing:**
```bash
chezmoi apply -v
```

**Check what would change:**
```bash
chezmoi diff
```

**Pull latest changes and apply:**
```bash
chezmoi update
```

### Managing the Repository

**Navigate to chezmoi source directory:**
```bash
chezmoi cd
```

**Commit and push changes:**
```bash
chezmoi cd
git add .
git commit -m "Update configuration"
git push
```

**Re-run installation scripts:**
```bash
# Remove the script state to force re-execution
chezmoi state delete-bucket --bucket=scriptState

# Then apply to re-run scripts
chezmoi apply -v
```

## 🛠️ Development Commands

### Reset Script Execution State

During development, you may need to force `run_once_*` scripts to execute again:

```bash
# Delete the script state bucket (forces run_once scripts to re-run)
chezmoi state delete-bucket --bucket=scriptState

# Apply changes to execute the scripts
chezmoi apply -v
```

This is useful when:
- Testing changes to installation scripts
- Debugging package installation issues
- Adding new packages to the installation scripts

### Other Useful Development Commands

```bash
# Verify chezmoi configuration
chezmoi doctor

# Show chezmoi data (OS, architecture, etc.)
chezmoi data

# Execute a template to see the output
chezmoi execute-template < ~/.local/share/chezmoi/dot_zshrc.tmpl

# Archive your dotfiles
chezmoi archive --output=dotfiles.tar.gz

# Unmanage a file (remove from chezmoi without deleting)
chezmoi forget ~/.gitconfig
```

## 🎨 Customization

### Adding New Dotfiles

1. **Add an existing file:**
   ```bash
   chezmoi add ~/.config/myapp/config.yml
   ```

2. **Edit and customize:**
   ```bash
   chezmoi edit ~/.config/myapp/config.yml
   ```

3. **Apply changes:**
   ```bash
   chezmoi apply -v
   ```

### Modifying Shell Configuration

The shell configurations are modular for easy customization:

#### Zsh (macOS/Linux)
- `~/.zsh/00-init.zsh` - PATH and environment variables
- `~/.zsh/10-tools.zsh` - Tool configurations (fzf, bat, eza, etc.)
- `~/.zsh/20-functions.zsh` - Custom functions
- `~/.zsh/30-os-specific.zsh` - OS-specific settings
- `~/.zsh/99-final.zsh` - Completions and final setup

#### PowerShell (Windows)
- `~/.config/powershell/00-init.ps1` - PATH and environment variables
- `~/.config/powershell/10-tools.ps1` - Tool configurations
- `~/.config/powershell/20-functions.ps1` - Custom functions
- `~/.config/powershell/30-os-specific.ps1` - OS-specific settings

**To modify:**
```bash
# Edit the source file
chezmoi edit ~/.zsh/10-tools.zsh

# Apply changes
chezmoi apply -v
```

### Adding New Packages

#### Windows
Edit `run_once_before_install-packages.ps1` and add packages to the `$packages` array:
```powershell
$packages = @(
    "Git.Git"
    "YourPackage.Name"  # Add your package here
)
```

#### macOS/Linux
Edit `run_once_before_install-packages.sh.tmpl` and add to the `brew install` command:
```bash
brew install \
  eza \
  your-package-name  # Add your package here
```

Then reset the script state and re-apply:
```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply -v
```

### OS-Specific Configuration

Use chezmoi templates to add OS-specific logic:

```bash
{{- if eq .chezmoi.os "windows" }}
# Windows-specific configuration
{{- else if eq .chezmoi.os "darwin" }}
# macOS-specific configuration
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific configuration
{{- end }}
```

## 🐛 Troubleshooting

### Common Issues

#### Scripts Don't Run on First Apply

**Problem:** Installation scripts (`run_once_before_*`) don't execute.

**Solution:**
```bash
# Check script state
chezmoi state dump

# Force re-run
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply -v
```

#### Permission Denied Errors

**Problem:** Files have incorrect permissions.

**Solution:**
- Files with `private_` prefix should have restricted permissions (600)
- Check file permissions: `ls -la ~/.zshrc`
- Re-apply with verbose output: `chezmoi apply -v`

#### PowerShell Profile Not Loading

**Problem:** PowerShell profile doesn't load on Windows.

**Solution:**
1. Check execution policy:
   ```powershell
   Get-ExecutionPolicy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. Verify profile location:
   ```powershell
   $PROFILE
   Test-Path $PROFILE
   ```

3. Re-apply dotfiles:
   ```bash
   chezmoi apply -v
   ```

#### Homebrew Not Found (Linux)

**Problem:** `brew` command not found on Linux.

**Solution:**
1. Install Homebrew on Linux:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Add to PATH (usually in `~/.profile` or `~/.zshrc`):
   ```bash
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
   ```

#### Package Installation Fails

**Problem:** Some packages fail to install during initial setup.

**Solution:**
- Installation scripts use `$ErrorActionPreference = "Continue"` to continue on errors
- Manually install failed packages:
  ```bash
  # Windows
  winget install <package-name>

  # macOS/Linux
  brew install <package-name>
  ```

#### Zsh Completions Not Working

**Problem:** Tab completions don't work in Zsh.

**Solution:**
```bash
# Rebuild completion cache
rm -f ~/.zcompdump
autoload -Uz compinit && compinit
```

#### Changes Not Applying

**Problem:** `chezmoi apply` doesn't update files.

**Solution:**
```bash
# Check what would change
chezmoi diff

# Force apply
chezmoi apply -v --force

# Check for errors
chezmoi doctor
```

### Getting Help

```bash
# Check chezmoi configuration and environment
chezmoi doctor

# View chezmoi logs
chezmoi apply -v

# Get help on a specific command
chezmoi help <command>
```

## 📦 Installed Tools

### Shell Enhancements
- **Zsh** (macOS/Linux) with Oh My Zsh
- **PowerShell 7+** (Windows)
- **Starship** (Windows) / **Powerlevel10k** (macOS/Linux) - Modern prompt

### Modern CLI Tools
- **eza** - Modern replacement for `ls`
- **bat** - Cat with syntax highlighting
- **fzf** - Fuzzy finder
- **fd** - Fast alternative to `find`
- **zoxide** - Smarter `cd` command
- **tlrc** - Simplified man pages

### Development Tools
- **Git** - Version control
- **GitHub CLI (gh)** - GitHub from the command line
- **Azure CLI (az)** - Azure cloud management
- **fnm** (Windows) / **nvm** (macOS/Linux) - Node.js version manager
- **lazygit** - Terminal UI for Git
- **lazydocker** - Terminal UI for Docker

### Shell Plugins & Modules
- **PSReadLine** (Windows) - Enhanced command-line editing
- **PSFzf** (Windows) - Fuzzy finder integration
- **posh-git** (Windows) - Git integration
- **Terminal-Icons** (Windows) - File icons in terminal
- **zsh-autosuggestions** (macOS/Linux) - Command suggestions
- **zsh-syntax-highlighting** (macOS/Linux) - Syntax highlighting

## 📝 License

MIT - See [LICENSE](LICENSE) for more information.

## 🤝 Contributing

This is a personal dotfiles repository so feel free to fork it but I'm not accepting pull requests.
## 🔗 Resources

- [chezmoi Documentation](https://www.chezmoi.io/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Starship](https://starship.rs/)
- [Homebrew](https://brew.sh/)
- [Scoop](https://scoop.sh/)


