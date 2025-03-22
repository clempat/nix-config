{ pkgs, isDarwin, ... }: {
  home.packages = with pkgs.unstable; [
    fd
    jq
    k9s
    ripgrep
    postman
    wget

    # Import Scripts
    (import ./../../../scripts/tmux-sessionizer.nix { pkgs = pkgs.unstable; })
    (import ./../../../scripts/kn.nix { pkgs = pkgs.unstable; })
    (import ./../../../scripts/clone-for-worktrees.nix { pkgs = pkgs.unstable; })
    (import ./../../../scripts/recording.nix { pkgs = pkgs.unstable; inherit isDarwin; })
    dive
    kubectl
    skopeo
    lazydocker
    docker

    # Go tooling
    go
    go-tools
    gofumpt
    gopls

    # Nix tooling
    deadnix
    devenv
    devbox
    nix-init
    nixfmt-classic
    nixpkgs-fmt
    nurl
    statix

    # Python tooling
    ruff
    # (pkgs.python3.withPackages (p: with p; [ tox virtualenv ]))
    # pipx

    # Shell tooling
    shellcheck
    shfmt
    yazi
  ];
}
