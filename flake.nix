{
  description = "My basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # Unstable Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Stable Nix Packages

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
  };

  outputs = inputs @ { self, nixpkgs, home-manager, plasma-manager, hyprland, nur, ... }:
    let
      system = "x86_64-linux";

      user = "clement";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;

    in
    {

      nixosConfigurations = (
        import ./systems {
          inherit (nixpkgs) lib;
          inherit inputs user system home-manager plasma-manager hyprland nur;
        }
      );

    };

}
