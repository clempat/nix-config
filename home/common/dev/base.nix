{
  inputs,
  lib,
  pkgs,
  isDarwin,
  system,
  ...
}:
{
  home.packages =
    with pkgs.unstable;
    [
      inputs.clement-nvim.packages.${system}.nvim
      pkgs.actionlint # Use stable version instead of unstable
      fd
      jq
      k9s
      ripgrep
      postman
      wget
      age-plugin-yubikey

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
      amp-cli

      # Shell tooling
      shellcheck
      shfmt
      yazi
    ]
    ++ [
      inputs.self.packages.${system}.spec-kit
    ]
    ++ lib.optionals (!isDarwin) [
      pkgs.unstable.docker
      pkgs.unstable.ktailctl
    ];
}
