{ pkgs }:

pkgs.writeShellScriptBin "organize-workspace" ''
  set -e

  WORKSPACE="$HOME/workspace"
  ARCHIVE="$WORKSPACE/_archive"
  SANDBOX="$WORKSPACE/_sandbox"
  EXECUTE=false
  ARCHIVE_MONTHS=6

  usage() {
    echo "Usage: organize-workspace [--execute]"
    echo ""
    echo "Organizes ~/workspace by GitHub org."
    echo "Dry-run by default, use --execute to apply."
    echo ""
    echo "Target structure:"
    echo "  ~/workspace/<org>/<repo>   - repos grouped by GitHub org"
    echo "  ~/workspace/_sandbox/      - repos with no org"
    echo "  ~/workspace/_archive/      - repos with no commits in ''${ARCHIVE_MONTHS}+ months"
  }

  # Fix .git files with absolute paths after a repo move
  fix_worktree_paths() {
    local repo_dir="$1"
    local bare_dir=""

    # Detect bare repo setup (.git file pointing to .bare)
    if [ -f "$repo_dir/.git" ]; then
      local gitdir_content
      gitdir_content=$(cat "$repo_dir/.git")
      case "$gitdir_content" in
        "gitdir: ./.bare"|"gitdir: .bare")
          bare_dir="$repo_dir/.bare"
          ;;
      esac
    fi

    [ -z "$bare_dir" ] && return

    # Fix worktree .git files and re-register in .bare/worktrees/
    for sub in "$repo_dir"/*/; do
      [ ! -f "$sub/.git" ] && continue
      local wt_name
      wt_name=$(basename "$sub")

      # Create worktree tracking entry
      mkdir -p "$bare_dir/worktrees/$wt_name"
      echo "$sub" > "$bare_dir/worktrees/$wt_name/gitdir"
      echo "../.." > "$bare_dir/worktrees/$wt_name/commondir"

      # Set HEAD if missing
      if [ ! -f "$bare_dir/worktrees/$wt_name/HEAD" ]; then
        echo "ref: refs/heads/$wt_name" > "$bare_dir/worktrees/$wt_name/HEAD"
      fi

      # Update worktree's .git to point to new path
      echo "gitdir: $bare_dir/worktrees/$wt_name" > "$sub/.git"
    done
  }

  for arg in "$@"; do
    case "$arg" in
      --execute) EXECUTE=true ;;
      --help|-h) usage; exit 0 ;;
      *) echo "Unknown arg: $arg"; usage; exit 1 ;;
    esac
  done

  if [ "$EXECUTE" = false ]; then
    echo "=== DRY RUN (use --execute to apply) ==="
    echo ""
  fi

  moved=0
  skipped=0
  archived=0
  zoxide_cmds=""

  for dir in "$WORKSPACE"/*/; do
    [ ! -d "$dir" ] && continue
    repo=$(basename "$dir")

    # Skip already-organized dirs
    case "$repo" in
      _archive|_sandbox|thermondo|clempat) skipped=$((skipped + 1)); continue ;;
    esac

    # Must be a git repo
    if [ ! -d "$dir/.git" ] && [ ! -f "$dir/.git" ]; then
      echo "SKIP (not git): $repo"
      skipped=$((skipped + 1))
      continue
    fi

    # Check for recent activity
    last_commit=$(${pkgs.git}/bin/git -C "$dir" log -1 --format=%ct 2>/dev/null || echo "0")
    cutoff=$(date -v-''${ARCHIVE_MONTHS}m +%s 2>/dev/null || date -d "''${ARCHIVE_MONTHS} months ago" +%s 2>/dev/null || echo "0")

    if [ "$last_commit" != "0" ] && [ "$cutoff" != "0" ] && [ "$last_commit" -lt "$cutoff" ]; then
      target="$ARCHIVE/$repo"
      echo "ARCHIVE: $repo -> _archive/$repo (no commits in ''${ARCHIVE_MONTHS}+ months)"
      archived=$((archived + 1))
      if [ "$EXECUTE" = true ]; then
        mkdir -p "$ARCHIVE"
        mv "$dir" "$target"
        fix_worktree_paths "$target"
        zoxide_cmds="$zoxide_cmds\nzoxide remove '$dir'"
      fi
      continue
    fi

    # Detect org from remote
    org=""
    remote_url=$(${pkgs.git}/bin/git -C "$dir" remote get-url origin 2>/dev/null || echo "")
    if [ -n "$remote_url" ]; then
      case "$remote_url" in
        *github.com*)
          org=$(echo "$remote_url" | ${pkgs.gnused}/bin/sed -E 's|.*github\.com[:/]([^/]+)/.*|\1|')
          ;;
      esac
    fi

    if [ -z "$org" ]; then
      target="$SANDBOX/$repo"
      echo "MOVE: $repo -> _sandbox/$repo (no org detected)"
    else
      target="$WORKSPACE/$org/$repo"
      echo "MOVE: $repo -> $org/$repo"
    fi

    if [ -d "$target" ]; then
      echo "  CONFLICT: target already exists, skipping"
      skipped=$((skipped + 1))
      continue
    fi

    moved=$((moved + 1))
    if [ "$EXECUTE" = true ]; then
      mkdir -p "$(dirname "$target")"
      mv "$dir" "$target"
      fix_worktree_paths "$target"
      zoxide_cmds="$zoxide_cmds\nzoxide remove '$dir'"
    fi
  done

  echo ""
  echo "Summary: $moved moved, $archived archived, $skipped skipped"

  if [ "$EXECUTE" = true ] && [ -n "$zoxide_cmds" ]; then
    echo ""
    echo "Run these to clean up zoxide:"
    echo -e "$zoxide_cmds"
  fi
''
