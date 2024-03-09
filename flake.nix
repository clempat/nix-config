{
  description = "My Nixos configuration Linux/Darwin";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";
    clement-nvim.url = "github:clempat/nvim-config";
    tmux-sessionx.url = "github:omerxx/tmux-sessionx";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, home-manager, nur, ... }:
    let
      mkDarwin = self.lib.mkDarwin { };
      mkNixos = self.lib.mkNixos { };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        darwinConfigurations = {
          aarch64 = mkDarwin { system = "aarch64-darwin"; };
          x86_64 = mkDarwin { system = "x86_64-darwin"; };
        };

        lib = import ./lib { inherit inputs; };

        nixosConfiguration = { x86_64 = mkNixos { system = "x86_64-linux"; }; };
      };

      systems =
        [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          geist-mono =
            self.lib.geist-mono { inherit (pkgs) fetchzip lib stdenvNoCC; };
        };
      };
    };
}
