# AGENTS.md - Nix Configuration Development Guide

## Build/Test Commands
- **Format code**: `nix fmt` (uses nixfmt-classic)
- **Check flake**: `nix flake check`
- **Build NixOS**: `nix build .#nixosConfigurations.tuxedo.config.system.build.toplevel`
- **Build Darwin**: `nix build .#darwinConfigurations."clementpatout@mondo".config.system.build.toplevel`
- **Apply NixOS**: `sudo nixos-rebuild switch --flake .#tuxedo`
- **Apply Darwin**: `darwin-rebuild switch --flake .#clementpatout@mondo`
- **Dev shell**: `nix develop`

## Code Style Guidelines
- **Indentation**: 2 spaces, no tabs
- **Imports**: Group at top, one per line, use `lib.optional` for conditionals
- **Functions**: `{ pkgs, lib, config, ... }:` pattern, alphabetical parameters
- **Naming**: camelCase for attributes, kebab-case for files, descriptive names
- **Strings**: Double quotes, `${}` interpolation, `''` for multi-line
- **Comments**: Minimal, single-line with `#`, aligned with code
- **Attributes**: One per line, proper nesting, closing brace aligned
- **Error handling**: Use `builtins.pathExists`, `lib.mkDefault`, existence checks
- **Packages**: Prefer `pkgs.unstable.package` for newer versions
- **Structure**: Clear separation of imports, configuration, packages