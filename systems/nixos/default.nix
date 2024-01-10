{ lib, nixpkgs, nixpkgs-unstable, inputs, home-manager, user, plasma-manager, hyprland, nur, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow Proprietary Software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;

in
{
  tuxedo = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user unstable inputs hyprland; };
    modules = [
      nur.nixosModules.nur
      ./tuxedo
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ];
        };
      }
    ];

  };

  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user unstable inputs hyprland; };
    modules = [
      nur.nixosModules.nur
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ] ++ [ (import ./desktop/home.nix) ];
        };
      }
    ];

  };
}
