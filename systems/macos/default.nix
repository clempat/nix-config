{ lib, inputs, nixpkgs, darwin, home-manager, ...}:

let
  system = "aarch64-darwin";
in
{
  macbook = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs user; };
    modules = [
      ./configuration.nix
      
      home-manager.darwinModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}