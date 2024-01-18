{
  description = "My basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland"; # Requires "hyprland.nixosModules.default" to be added the host modules
    hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nur.url = "github:nix-community/NUR"; # Requires "nur.nixosModules.nur" to be added to the host modules
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
  };
  outputs = inputs @ { nixpkgs, home-manager, nur, ... }:
    let
      system = "x86_64-linux";
      user = "clement";
      email = "clement.patout@gmail.com";
      theme = "grayscale-light";
      wallpaperDir = "/home/${user}/Pictures/Wallpapers";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {

      nixosConfigurations = {
        tuxedo = nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit user inputs; };
            modules = [
              nur.nixosModules.nur
              ./systems/nixos/tuxedo/configuration.nix
              ./systems/nixos/configuration.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit user; inherit inputs; inherit theme; inherit wallpaperDir;
                  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
                };
                home-manager.users.${user} = {
                  imports = [ ./home.nix ];
                };
              }
            ];
          };

        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit user inputs; };
          modules = [
            nur.nixosModules.nur
            ./systems/nixos/desktop/configuration.nix
            ./systems/nixos/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit user; inherit inputs; inherit theme; inherit wallpaperDir;
                inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
              };
              home-manager.users.${user} = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };

      darwinConfigurations = (
        # Darwin Configurations
        import ./systems/macos {
          inherit (nixpkgs) lib;
          inherit inputs; inherit user; inherit theme;
        }
      );
    };
}
