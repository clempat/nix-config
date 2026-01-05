{ pkgs }:

pkgs.writeShellScriptBin "worktree-cleanup" ''
  set -euo pipefail

  # Check if we're at worktree root
  if [ ! -d ".bare" ] && [ ! -f ".git" ]; then
    echo "Error: Not at worktree root"
    echo "Run this from a directory created with clone-for-worktrees"
    exit 1
  fi

  # Verify .git points to .bare if it's a file
  if [ -f ".git" ]; then
    if ! grep -q "gitdir: ./.bare" .git 2>/dev/null; then
      echo "Error: .git file doesn't point to .bare"
      exit 1
    fi
  fi

  ROOT_DIR=$(pwd)

  # Detect main branch name
  MAIN_BRANCH=""
  MAIN_BRANCH_SHORT=""
  if git rev-parse --verify origin/main &>/dev/null; then
    MAIN_BRANCH="origin/main"
    MAIN_BRANCH_SHORT="main"
  elif git rev-parse --verify origin/master &>/dev/null; then
    MAIN_BRANCH="origin/master"
    MAIN_BRANCH_SHORT="master"
  else
    echo "Error: Neither origin/main nor origin/master found"
    exit 1
  fi

  echo "Using $MAIN_BRANCH as target branch"
  echo ""

  # Fetch latest
  ${pkgs.gum}/bin/gum spin --spinner dot --title "Fetching from origin..." -- git fetch origin

  # Build worktree info
  declare -a WORKTREE_PATHS=()
  declare -a WORKTREE_LABELS=()
  declare -a PRESELECTED=()

  # Parse git worktree list
  while IFS= read -r line; do
    WORKTREE_PATH=$(echo "$line" | awk '{print $1}')
    BRANCH=$(echo "$line" | sed -n 's/.*\[\(.*\)\].*/\1/p')

    # Skip if no branch (bare repo itself)
    [ -z "$BRANCH" ] && continue

    # Skip main/master
    [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]] && continue

    # Gather status info
    STATUS_FLAGS=""

    # Check if merged into main
    IS_MERGED="no"
    if git branch -r --merged "$MAIN_BRANCH" 2>/dev/null | grep -q "origin/$BRANCH"; then
      IS_MERGED="yes"
      STATUS_FLAGS+=" [merged]"
    fi

    # Check if pushed (remote branch exists and is up to date)
    IS_PUSHED="no"
    if git rev-parse --verify "origin/$BRANCH" &>/dev/null; then
      LOCAL_SHA=$(git rev-parse "$BRANCH" 2>/dev/null || echo "")
      REMOTE_SHA=$(git rev-parse "origin/$BRANCH" 2>/dev/null || echo "")
      if [ "$LOCAL_SHA" = "$REMOTE_SHA" ] && [ -n "$LOCAL_SHA" ]; then
        IS_PUSHED="yes"
        STATUS_FLAGS+=" [pushed]"
      else
        STATUS_FLAGS+=" [unpushed]"
      fi
    else
      STATUS_FLAGS+=" [local-only]"
    fi

    # Check for uncommitted changes
    HAS_CHANGES="no"
    if [ -d "$WORKTREE_PATH" ]; then
      if ! git -C "$WORKTREE_PATH" diff --quiet 2>/dev/null || \
         ! git -C "$WORKTREE_PATH" diff --cached --quiet 2>/dev/null; then
        HAS_CHANGES="yes"
        STATUS_FLAGS+=" [dirty]"
      fi
      # Check for untracked files
      UNTRACKED=$(git -C "$WORKTREE_PATH" ls-files --others --exclude-standard 2>/dev/null | head -1)
      if [ -n "$UNTRACKED" ]; then
        HAS_CHANGES="yes"
        STATUS_FLAGS+=" [untracked]"
      fi
    fi

    # Build label
    LABEL="$BRANCH$STATUS_FLAGS"

    WORKTREE_PATHS+=("$WORKTREE_PATH")
    WORKTREE_LABELS+=("$LABEL")

    # Pre-select if merged and no uncommitted changes
    if [[ "$IS_MERGED" == "yes" && "$HAS_CHANGES" == "no" ]]; then
      PRESELECTED+=("$LABEL")
    fi
  done < <(git worktree list)

  # Check if any worktrees found
  if [ ''${#WORKTREE_PATHS[@]} -eq 0 ]; then
    echo "No worktrees found (besides main)."
    exit 0
  fi

  echo "Legend: [merged]=in $MAIN_BRANCH_SHORT [pushed]=synced [unpushed]=ahead [local-only]=no remote [dirty]=uncommitted [untracked]=new files"
  echo ""

  # Build gum choose arguments
  GUM_ARGS=(--no-limit --header "Select worktrees to delete (space to toggle, enter to confirm):")

  # Add pre-selected items
  for sel in "''${PRESELECTED[@]}"; do
    GUM_ARGS+=(--selected "$sel")
  done

  # Run gum choose
  SELECTED=$(printf '%s\n' "''${WORKTREE_LABELS[@]}" | ${pkgs.gum}/bin/gum choose "''${GUM_ARGS[@]}" || true)

  if [ -z "$SELECTED" ]; then
    echo "No worktrees selected. Exiting."
    exit 0
  fi

  # Count selected
  SELECTED_COUNT=$(echo "$SELECTED" | wc -l | tr -d ' ')

  # Confirm deletion
  echo ""
  if ${pkgs.gum}/bin/gum confirm "Delete $SELECTED_COUNT worktree(s)?"; then
    echo ""

    while IFS= read -r selected_label; do
      # Find matching worktree path
      for i in "''${!WORKTREE_LABELS[@]}"; do
        if [[ "''${WORKTREE_LABELS[$i]}" == "$selected_label" ]]; then
          WORKTREE="''${WORKTREE_PATHS[$i]}"
          BRANCH=$(echo "$selected_label" | awk '{print $1}')

          ${pkgs.gum}/bin/gum spin --spinner dot --title "Removing $BRANCH..." -- rm -rf "$WORKTREE"
          echo "  ✓ Removed $BRANCH"
          break
        fi
      done
    done <<< "$SELECTED"

    # Prune worktrees
    ${pkgs.gum}/bin/gum spin --spinner dot --title "Pruning worktrees..." -- git worktree prune

    echo ""
    echo "Cleanup complete!"
  else
    echo "Cleanup cancelled."
  fi
''
