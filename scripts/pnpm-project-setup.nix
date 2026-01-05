{ pkgs, ... }:

pkgs.writeShellScriptBin "pnpm-project-setup" ''
  #!/usr/bin/env bash
  
  set -euo pipefail
  
  # Colors for output
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color
  
  PROJECT_DIR="''${1:-.}"
  
  cd "$PROJECT_DIR"
  
  echo -e "''${YELLOW}Setting up pnpm for project in: $(pwd)''${NC}"
  
  # Remove existing node_modules and package-lock.json if they exist
  if [ -d "node_modules" ]; then
    echo -e "''${YELLOW}Removing existing node_modules...''${NC}"
    rm -rf node_modules
  fi
  
  if [ -f "package-lock.json" ]; then
    echo -e "''${YELLOW}Removing package-lock.json...''${NC}"
    rm -f package-lock.json
  fi
  
  if [ -f "yarn.lock" ]; then
    echo -e "''${YELLOW}Removing yarn.lock...''${NC}"
    rm -f yarn.lock
  fi
  
  # Check if project already has .npmrc
  if [ -f ".npmrc" ]; then
    echo -e "''${YELLOW}Project .npmrc already exists, keeping existing configuration''${NC}"
  else
    echo -e "''${YELLOW}No project .npmrc found, pnpm will use global config''${NC}"
  fi
  
  # Install dependencies with pnpm
  if [ -f "package.json" ]; then
    echo -e "''${YELLOW}Installing dependencies with pnpm...''${NC}"
    ${pkgs.pnpm}/bin/pnpm install
    echo -e "''${GREEN}Project setup complete!''${NC}"
    echo -e "''${YELLOW}Dependencies are now shared via pnpm store at ~/.pnpm-store''${NC}"
  else
    echo -e "''${YELLOW}No package.json found. Run 'pnpm init' to create a new project.''${NC}"
  fi
''