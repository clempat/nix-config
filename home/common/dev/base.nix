{ inputs, lib, pkgs, isDarwin, ... }: {
  home.packages = with pkgs.unstable;
    [
      inputs.clement-nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      pkgs.actionlint # Use stable version instead of unstable
      fd
      jq
      k9s
      ripgrep
      bruno
      postman
      wget
      age-plugin-yubikey
      pnpm

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
      (import ./../../../scripts/cleanup-node-modules.nix {
        pkgs = pkgs.unstable;
      })
      (import ./../../../scripts/pnpm-project-setup.nix {
        pkgs = pkgs.unstable;
      })
      (import ./../../../scripts/pnpm-team-setup.nix { pkgs = pkgs.unstable; })
      (import ./../../../scripts/worktree-cleanup.nix { pkgs = pkgs.unstable; })
      dive
      kubectl
      skopeo
      lazydocker

      # Nix tooling
      deadnix
      devenv
      devbox
      nix-init
      nixfmt-classic
      nixpkgs-fmt
      nurl
      statix

      # AI
      gemini-cli-bin
      amp-cli

      # Shell tooling
      shellcheck
      shfmt
      yazi

      uv
    ] ++ lib.optionals (!isDarwin) [
      pkgs.unstable.docker
      pkgs.unstable.ktailctl
    ];
}
