{ pkgs }:

pkgs.writeShellScriptBin "clone-for-worktrees" ''
  set -e

  url=$1
  name=''${2:-$(basename "$url" | cut -d. -f1)}

  # Auto-detect org from GitHub URL
  org=""
  case "$url" in
    *github.com*)
      org=$(echo "$url" | sed -E 's|.*github\.com[:/]([^/]+)/.*|\1|')
      ;;
  esac

  workspace="$HOME/workspace"
  if [ -n "$org" ]; then
    target="$workspace/$org/$name"
    mkdir -p "$workspace/$org"
  else
    target="$workspace/_sandbox/$name"
    mkdir -p "$workspace/_sandbox"
  fi

  if [ -d "$target" ]; then
    echo "Error: $target already exists"
    exit 1
  fi

  mkdir -p "$target"
  cd "$target"

  git clone --bare "$url" .bare
  echo "gitdir: ./.bare" > .git

  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch origin

  # Determine default branch and create initial worktree
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||' || echo "main")
  git worktree add ".worktrees/$default_branch" "$default_branch" 2>/dev/null || \
    git worktree add ".worktrees/main" "main" 2>/dev/null || \
    git worktree add ".worktrees/master" "master" 2>/dev/null || true

  echo ""
  echo "Cloned to: $target"
  echo "Default branch worktree created."
  echo ""
  echo "Usage:"
  echo "  cd $target/.worktrees/$default_branch"
  echo "  wt switch          # switch/create worktrees"
  echo "  wt switch -c       # create new worktree + branch"
''
