{
  description = "My basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # User Environment Manager
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      # Official Hyprland Flake
      url = "github:hyprwm/Hyprland"; # Requires "hyprland.nixosModules.default" to be added the host modules
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nur = {
      # NUR Community Packages
      url = "github:nix-community/NUR"; # Requires "nur.nixosModules.nur" to be added to the host modules
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
    };

    darwin = {
      # MacOS Package Management
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # Neovim
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, plasma-manager, hyprland, nur, darwin, nixvim, ... }:
    let
      vars = {
        user = "clement";
        email = "clement.patout@gmail.com";
      };
    in
    {

      nixosConfigurations = (
        import ./systems/nixos {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable vars home-manager plasma-manager hyprland nur nixvim;
        }
      );


      darwinConfigurations = (
        # Darwin Configurations
        import ./systems/macos {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager darwin vars nixvim;
        }
      );

    };

}
