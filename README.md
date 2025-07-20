# Dotfiles

My personal dotfiles for Ubuntu/Debian-based systems.

## What's Included

- `.bashrc` - Bash configuration with history timestamps, aliases, and HSTR setup
- `.bash_aliases` - Custom bash aliases with smart fallbacks

## Dependencies

The installation script will automatically install these packages:
- **exa** - Modern replacement for `ls` with colors and icons (via package manager or source compilation)
- **hstr** - Command history search (Ctrl+R)
- **autojump** - Smart directory navigation

### exa Installation

The installer uses a comprehensive approach to install `exa`:
- **Package manager first** - Tries apt (Ubuntu/Debian)
- **Source compilation** - Falls back to Rust/cargo compilation if package manager fails
- **Automatic dependencies** - Installs curl and Rust if needed

You can also manually install exa anytime:
```bash
./install_exa.sh
```

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
   ./install.sh
   ```

## Features

- **Safe Installation**: Backs up existing files before overwriting
- **Simple Structure**: All dotfiles in the root directory
- **Ubuntu/Debian Focused**: Optimized for apt-based systems
- **Auto-Dependencies**: Automatically installs required packages
- **Smart Fallbacks**: Uses exa if available, falls back to colored ls
- **Comprehensive exa**: Handles exa installation via apt or source compilation
- **Conditional Aliases**: Log aliases only created if log files exist

## Structure

```
dotfiles/
├── install.sh          # Main installation script
├── install_exa.sh      # exa installation script
├── backup/             # Backup directory for existing files
├── .bashrc            # Bash configuration with Git prompt
├── .bash_aliases      # Smart aliases with fallbacks
└── README.md          # This file
```

## Key Features

### Bash Configuration
- **History timestamps** - All commands logged with timestamps
- **Git integration** - Shows current Git branch in prompt
- **HSTR setup** - Enhanced command history search
- **Autojump** - Smart directory navigation
- **Colorful history** - Custom history display function

### Smart Aliases
- **Modern ls** - Uses exa with fallback to colored ls
- **QOL aliases** - Quick navigation and utility commands
- **Git shortcuts** - Comprehensive Git workflow aliases
- **Log viewing** - System log aliases (only if logs exist)
- **Disk utilities** - Mount and disk management aliases

## Customization

1. Edit the configuration files directly
2. Add new dotfiles to the root directory
3. Update the installation script to handle new files
4. Modify the `PACKAGES` array in `install.sh` to add/remove dependencies

## Backup and Restore

The installation script automatically creates backups of existing files in the `backup/` directory.

## Requirements

- **Ubuntu/Debian system** with apt package manager
- **sudo privileges** for package installation
- **Internet connection** for package downloads and Rust installation

## Contributing

Feel free to fork this repository and customize it for your own needs.

## License

This project is open source and available under the [MIT License](LICENSE). 