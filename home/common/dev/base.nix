{ inputs, lib, pkgs, isDarwin, system, ... }: {
  home.packages = with pkgs.unstable;
    [
      inputs.clement-nvim.packages.${system}.nvim
      actionlint
      fd
      jq
      ktailctl
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
      claude-code
      amp-cli

      # Shell tooling
      shellcheck
      shfmt
      yazi
    ] ++ lib.optional (!isDarwin) pkgs.unstable.docker;
}
