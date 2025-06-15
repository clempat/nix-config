{ inputs, pkgs, isDarwin, system, ... }: {
  home.packages = with pkgs.unstable; [
    inputs.clement-nvim.packages.${system}.nvim
    actionlint
    fd
    jq
    k9s
    ripgrep
    postman
    wget

    # Import Scripts
    (import ./../../../scripts/tmux-sessionizer.nix { pkgs = pkgs.unstable; })
    (import ./../../../scripts/kn.nix { pkgs = pkgs.unstable; })
    (import ./../../../scripts/clone-for-worktrees.nix {
      pkgs = pkgs.unstable;
    })
    (import ./../../../scripts/recording.nix {
      pkgs = pkgs.unstable;
      inherit isDarwin;
    })
    dive
    kubectl
    skopeo
    lazydocker
    docker

    # Nix tooling
    deadnix
    devenv
    devbox
    nix-init
    nixfmt-classic
    nixpkgs-fmt
    nurl
    statix

    # Shell tooling
    shellcheck
    shfmt
    yazi
  ];
}
