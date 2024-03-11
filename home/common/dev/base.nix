{ pkgs, ... }: {
  home.packages = with pkgs; [
    fd
    jq
    k9s
    ripgrep
    postman

    # Import Scripts
    (import ./../../../scripts/tmux-sessionizer.nix { inherit pkgs; })
    (import ./../../../scripts/kn.nix { inherit pkgs; })

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
    nixfmt
    nixpkgs-fmt
    nurl
    rnix-lsp
    statix

    # Python tooling
    ruff
    (pkgs.python3.withPackages (p: with p; [ tox virtualenv ]))

    # Shell tooling
    shellcheck
    shfmt
  ];
}
