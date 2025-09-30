# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Common Commands

### Build & Deploy
- **Format code**: `nix fmt` (uses nixfmt-classic)
- **Check flake**: `nix flake check`
- **Build NixOS system**: `nix build .#nixosConfigurations.tuxedo.config.system.build.toplevel`
- **Build Darwin system**: `nix build .#darwinConfigurations."clementpatout@mondo".config.system.build.toplevel`
- **Apply NixOS config**: `sudo nixos-rebuild switch --flake .#tuxedo`
- **Apply Darwin config**: `darwin-rebuild switch --flake .#clementpatout@mondo`
- **Development shell**: `nix develop`

### Testing
- **Test single host build**: `nix build .#nixosConfigurations.sparrow.config.system.build.toplevel`
- **Test package builds**: `nix build .#packages.x86_64-linux.package-name`

### Secrets Management (SOPS)
- **Edit secrets**: `nix run nixpkgs#sops -- secrets/secrets.yaml`
- **Generate age key**: `nix run nixpkgs#age -- -o age-key.txt`
- **Update keys**: Edit `.sops.yaml` with new age keys

## Architecture Overview

### Flake Structure
This is a multi-system Nix flake supporting both NixOS (Linux) and nix-darwin (macOS) configurations. The architecture follows a modular approach:

- **`flake.nix`**: Entry point defining inputs, outputs, and system configurations
- **`lib/mkSystems.nix`**: Core system builder functions with shared configuration logic
- **`host/`**: System-specific configurations split by platform (nixos/darwin)
- **`home/`**: Home Manager configurations for user environments
- **`lib/theme/`**: Centralized theming system using Catppuccin Macchiato

### Key Systems
- **NixOS hosts**: `tuxedo` (KDE desktop), `sparrow` (minimal)
- **Darwin host**: `mondo` (macOS with aerospace, sketchybar)
- **Users**: `clement` (Linux), `clementpatout` (macOS)

### Module System
The configuration uses a sophisticated module system:

1. **Host modules** (`host/{nixos,darwin}/`) handle system-level configuration
2. **Home modules** (`home/`) manage user environments via Home Manager
3. **Common modules** provide shared functionality across systems
4. **Desktop modules** are conditionally loaded based on `desktop` parameter

### Package Management
- **Stable packages**: From `nixpkgs` (25.05 release)
- **Unstable packages**: Available via `pkgs.unstable.*` overlay
- **Custom packages**: Defined in `pkgs/default.nix`
- **Scripts**: Custom shell scripts in `scripts/` (tmux-sessionizer, theme tools)

### Secrets Architecture
Uses SOPS-nix for secrets management:
- Age encryption with per-host and per-user keys
- Secrets stored in `secrets/secrets.yaml`
- Keys defined in `.sops.yaml` for multiple systems

### Theme System
Centralized theming via `lib/theme/`:
- **Base theme**: Catppuccin Macchiato color scheme
- **Application themes**: Coordinated across tmux, vim, bat, GTK, Qt
- **Font system**: Inter (UI), MesloLGSDZ Nerd Font (terminal), Joypixels (emoji)
- **Theme switching**: Scripts for dynamic theme changes

### Development Environment
- **Editor integration**: Configured for Neovim (clement-nvim flake input)
- **Shell**: Zsh with custom configurations
- **Terminal multiplexer**: tmux with sessionizer script for project navigation
- **Package development**: Uses unstable nixpkgs for latest packages

## Code Style Guidelines

- **Indentation**: 2 spaces, no tabs
- **Imports**: Group at top, use `lib.optional` for conditionals
- **Functions**: Use `{ pkgs, lib, config, ... }:` pattern with alphabetical parameters
- **Naming**: camelCase for attributes, kebab-case for files
- **Strings**: Double quotes, `${}` interpolation, `''` for multi-line
- **Error handling**: Use `builtins.pathExists`, `lib.mkDefault`, existence checks
- **Structure**: Clear separation of imports, configuration, packages

## Platform-Specific Notes

### macOS (Darwin)
- Uses Homebrew for GUI applications and some system dependencies
- Aerospace for window management (instead of yabai)
- Sketchybar for status bar customization
- Touch ID integration for sudo in tmux

### NixOS (Linux)
- Supports multiple desktop environments (KDE, Hyprland, GNOME)
- Hardware-specific configurations in `host/nixos/{hostname}/`
- Flatpak integration for additional applications
- Docker and virtualization support

## Important Files
- **System state**: Managed through `stateVersion = "23.11"`
- **Git config**: Centralized in `lib/mkSystems.nix`
- **Hardware configs**: Auto-generated, stored per-host
- **Boot configs**: GRUB/systemd-boot configurations per system