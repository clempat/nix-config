{ pkgs, isDarwin, ... }: {
  home.packages = with pkgs; [
    fd
    jq
    k9s
    ripgrep
    postman
    wget

    # Import Scripts
    (import ./../../../scripts/tmux-sessionizer.nix { inherit pkgs; })
    (import ./../../../scripts/kn.nix { inherit pkgs; })
    (import ./../../../scripts/clone-for-worktrees.nix { inherit pkgs; })
    (import ./../../../scripts/recording.nix { inherit pkgs isDarwin; })

    # Container tooling
    dive
    kubectl
    skopeo
    lazydocker

    # Go tooling
    go
    go-tools
    gofumpt
    gopls

    # Nix tooling
    deadnix
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
  ];
}
