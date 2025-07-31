# Dotfiles

My personal dotfiles for Ubuntu/Debian-based systems.

## What's Included

- `.bashrc` - Bash configuration with Git integration, history timestamps, and enhanced prompt
- `.bash_aliases` - Smart aliases with modern ls fallbacks and Git shortcuts
- `install.sh` - Automated installation script with package management

## Dependencies

The installation script will automatically install these packages:
- **eza/exa** - Modern replacement for `ls` with colors and icons (via package manager)
- **hstr** - Command history search (Ctrl+R)
- **autojump** - Smart directory navigation

### Modern ls Installation

The installer uses a smart approach to install modern ls replacements:
- **eza first** - Tries to install eza (preferred, available in Ubuntu 24.04+)
- **exa fallback** - Falls back to exa if eza is not available (Ubuntu 22.04)
- **Standard ls** - Uses colored ls if neither is available

The `.bash_aliases` automatically detects which tool is available and sets up appropriate aliases.

## Installation

### Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/rh0vandir/dotfiles/main/install.sh | bash
```

### Manual Install
1. Clone this repository:
   ```bash
   git clone https://github.com/rh0vandir/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the installation script:
   ```bash
   bash ./install.sh
   ```

## Features

- **Safe Installation**: Backs up existing files before overwriting
- **Simple Structure**: All dotfiles in the root directory
- **Ubuntu/Debian Focused**: Optimized for apt-based systems
- **Auto-Dependencies**: Automatically installs required packages
- **Smart Fallbacks**: Uses eza if available, falls back to exa, then colored ls
- **Modern ls Support**: Handles both eza and exa installation via apt
- **Conditional Aliases**: Log aliases only created if log files exist

## Structure

```
dotfiles/
├── install.sh          # Main installation script
├── .bashrc            # Bash configuration with Git prompt and HSTR setup
├── .bash_aliases      # Smart aliases with fallbacks
├── .gitignore         # Git ignore file (ignores backup directory)
├── backup/            # Backup directory for existing files
└── README.md          # This file
```

## Key Features

### Bash Configuration (.bashrc)
- **History timestamps** - All commands logged with timestamps
- **Git integration** - Advanced Git prompt showing branch, status, and remote sync
- **HSTR setup** - Enhanced command history search with Ctrl+R binding
- **Autojump** - Smart directory navigation

- **Local customization** - Support for `~/.bashrc.local` for personal settings

### Smart Aliases (.bash_aliases)
- **Modern ls** - Uses eza with fallback to exa, then colored ls
- **QOL aliases** - Quick navigation (`..`, `...`) and utility commands
- **Git shortcuts** - Comprehensive Git workflow aliases (`gs`, `gc`, `gp`, etc.)
- **Log viewing** - System log aliases (only if logs exist)
- **Disk utilities** - Mount and disk management aliases (`mnt`, `lsdisks`)

### Git Prompt Features
- **Branch display** - Shows current Git branch in prompt
- **Status indicators**:
  - ★ Staged files
  - ● Unstaged changes  
  - ○ Untracked files
  - ↑ Local commits not pushed
  - ↓ Behind remote
  - ↕ Diverged from remote
  - ⚠ Has commits but no upstream

## Customization

1. Edit the configuration files directly
2. Add new dotfiles to the root directory
3. Update the installation script to handle new files
4. Modify the `PACKAGES` array in `install.sh` to add/remove dependencies
5. Create `~/.bashrc.local` for personal customizations

## Backup and Restore

The installation script automatically creates backups of existing files in the `backup/` directory with timestamps.

## Requirements

- **Ubuntu/Debian system** with apt package manager
- **sudo privileges** for package installation
- **Internet connection** for package downloads

## Contributing

Feel free to fork this repository and customize it for your own needs.

## License

This project is open source and available under the [MIT License](LICENSE). 
