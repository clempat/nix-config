{ pkgs }:

pkgs.writeShellScriptBin "clone-for-worktrees" ''
  set -e

  url=$1
  name=$(if [ -n "$2" ]; then echo "$2"; else echo "$(basename $url | cut -d. -f1)"; fi)

  mkdir $name
  cd "$name"

  git clone --bare "$url" .bare
  echo "gitdir: ./.bare" > .git

  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

  git fetch origin
''
