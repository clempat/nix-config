{
  description = "clement's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    clement-nvim.url = "github:clempat/nvim-config";
    tmux-sessionx.url = "github:omerxx/tmux-sessionx";

    tuxedo-nixos.url = "github:blitz/tuxedo-nixos";
    tuxedo-nixos.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "23.11";
      username = "clement";

      libx =
        import ./lib { inherit self inputs outputs stateVersion username; };
    in {

      darwinConfigurations = let username = "clementpatout";
      in {
        "${username}@mondo" = libx.mkDarwin {
          inherit username;
          hostname = "MONDO-1325.local";
          system = "aarch64-darwin";
        };
      };

      # nix build .#homeConfigurations."clement@tuxedo".activationPackage
      homeConfigurations = {
        # Desktop machines
        "${username}@tuxedo" = libx.mkHome {
          hostname = "tuxedo";
          desktop = "kde";
          system = "x86_64-linux";
        };
      };

      # nix build .#nixosConfigurations.clement.config.system.build.toplevel
      nixosConfigurations = {
        # Desktop machines
        tuxedo = libx.mkHost {
          hostname = "tuxedo";
          desktop = "kde";
          system = "x86_64-linux";
        };
      };

      # Custom packages; acessible via 'nix build', 'nix shell', etc
      packages = libx.forAllSystems (system:
        let pkgs = unstable.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; });

      # Custom overlays
      overlays = import ./overlays { inherit inputs; };

      # Devshell for bootstrapping
      # Accessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = libx.forAllSystems (system:
        let pkgs = unstable.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; });

      formatter =
        libx.forAllSystems (system: self.packages.${system}.nixfmt-classic);
    };
}
