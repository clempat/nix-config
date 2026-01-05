{ pkgs, ... }:

pkgs.writeShellScriptBin "pnpm-team-setup" ''
  #!/usr/bin/env bash
  
  set -euo pipefail
  
  # Colors for output
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color
  
  PROJECT_DIR="''${1:-.}"
  
  cd "$PROJECT_DIR"
  
  echo -e "''${BLUE}Setting up team-friendly pnpm configuration in: $(pwd)''${NC}"
  
  # Create .nvmrc if Node version should be locked
  if [ ! -f ".nvmrc" ] && [ ! -f ".node-version" ]; then
    NODE_VERSION=$(${pkgs.nodejs}/bin/node --version | sed 's/v//')
    echo -e "''${YELLOW}Creating .nvmrc with Node $NODE_VERSION''${NC}"
    echo "$NODE_VERSION" > .nvmrc
  fi
  
  # Create package.json engines field suggestion
  if [ -f "package.json" ] && ! ${pkgs.jq}/bin/jq -e '.engines' package.json > /dev/null 2>&1; then
    NODE_VERSION=$(${pkgs.nodejs}/bin/node --version | sed 's/v//')
    PNPM_VERSION=$(${pkgs.pnpm}/bin/pnpm --version)
    
    echo -e "''${YELLOW}Consider adding engines to package.json:''${NC}"
    echo -e "''${BLUE}  \"engines\": {''${NC}"
    echo -e "''${BLUE}    \"node\": \">=$NODE_VERSION\",''${NC}"
    echo -e "''${BLUE}    \"pnpm\": \">=$PNPM_VERSION\"''${NC}"
    echo -e "''${BLUE}  }''${NC}"
  fi
  
  # Create .pnpmfile.cjs for team-specific configurations if needed
  if [ ! -f ".pnpmfile.cjs" ]; then
    echo -e "''${YELLOW}Creating .pnpmfile.cjs for team consistency''${NC}"
    cat > .pnpmfile.cjs << 'EOF'
// Team-specific pnpm configuration
// This file ensures consistent behavior across all team members

module.exports = {
  hooks: {
    readPackage(pkg, context) {
      // Add any team-specific package modifications here
      return pkg
    }
  }
}
EOF
  fi
  
  # Create pnpm-workspace.yaml if this is a monorepo
  if [ -d "packages" ] || [ -d "apps" ] || [ -d "libs" ]; then
    if [ ! -f "pnpm-workspace.yaml" ]; then
      echo -e "''${YELLOW}Detected potential monorepo structure, creating pnpm-workspace.yaml''${NC}"
      cat > pnpm-workspace.yaml << 'EOF'
packages:
  - 'packages/*'
  - 'apps/*'
  - 'libs/*'
EOF
    fi
  fi
  
  # Update .gitignore for multi-package-manager support
  if [ -f ".gitignore" ]; then
    if ! grep -q "node_modules" .gitignore; then
      echo -e "''${YELLOW}Adding node_modules to .gitignore''${NC}"
      echo "node_modules/" >> .gitignore
    fi
    
    # Add all package manager debug/cache files
    PACKAGE_MANAGER_IGNORES=(".pnpm-debug.log*" ".npm-debug.log*" ".yarn-debug.log*" ".yarn-error.log*" ".pnpm-store/" ".yarn/cache/" ".yarn/unplugged/")
    
    for ignore_pattern in "''${PACKAGE_MANAGER_IGNORES[@]}"; do
      if ! grep -q "$ignore_pattern" .gitignore; then
        echo -e "''${YELLOW}Adding $ignore_pattern to .gitignore''${NC}"
        echo "$ignore_pattern" >> .gitignore
      fi
    done
  fi
  
  # Create README section for team
  echo -e "''${GREEN}Team setup complete!''${NC}"
  echo -e "''${YELLOW}Add this to your README.md:''${NC}"
  echo -e "''${BLUE}"
  cat << 'EOF'

## Development Setup

This project supports multiple package managers: npm, yarn, or pnpm.

### Prerequisites
- Node.js (see .nvmrc for version)

### Installation
Choose your preferred package manager:

```bash
# Using npm
npm install

# Using yarn  
yarn install

# Using pnpm
pnpm install
```

### Scripts
```bash
# npm
npm run dev
npm run build
npm test

# yarn
yarn dev
yarn build  
yarn test

# pnpm
pnpm dev
pnpm build
pnpm test
```

**Note**: Each package manager maintains its own lock file. All are committed to ensure reproducible installs.
EOF
  echo -e "''${NC}"
''