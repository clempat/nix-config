{ pkgs, ... }:

pkgs.writeShellScriptBin "cleanup-node-modules" ''
  #!/usr/bin/env bash
  
  set -euo pipefail
  
  # Colors for output
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color
  
  # Default search path
  SEARCH_PATH="''${1:-$HOME}"
  
  echo -e "''${YELLOW}Searching for node_modules directories in: $SEARCH_PATH''${NC}"
  
  # Find all node_modules directories
  NODE_MODULES_DIRS=$(${pkgs.fd}/bin/fd -t d -H "^node_modules$" "$SEARCH_PATH" 2>/dev/null || true)
  
  if [ -z "$NODE_MODULES_DIRS" ]; then
    echo -e "''${GREEN}No node_modules directories found!''${NC}"
    exit 0
  fi
  
  # Calculate total size
  TOTAL_SIZE=0
  COUNT=0
  
  echo -e "''${YELLOW}Found node_modules directories:''${NC}"
  while IFS= read -r dir; do
    if [ -d "$dir" ]; then
      SIZE=$(${pkgs.coreutils}/bin/du -sh "$dir" 2>/dev/null | cut -f1 || echo "0")
      echo "  $dir ($SIZE)"
      COUNT=$((COUNT + 1))
    fi
  done <<< "$NODE_MODULES_DIRS"
  
  echo -e "''${YELLOW}Total directories found: $COUNT''${NC}"
  
  # Ask for confirmation
  read -p "Do you want to delete all these node_modules directories? (y/N): " -n 1 -r
  echo
  
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "''${RED}Deleting node_modules directories...''${NC}"
    
    while IFS= read -r dir; do
      if [ -d "$dir" ]; then
        echo "Removing: $dir"
        rm -rf "$dir"
      fi
    done <<< "$NODE_MODULES_DIRS"
    
    echo -e "''${GREEN}Cleanup completed!''${NC}"
    echo -e "''${YELLOW}Now run 'pnpm install' in your project directories to reinstall dependencies.''${NC}"
  else
    echo -e "''${YELLOW}Cleanup cancelled.''${NC}"
  fi
''