{ self, inputs, outputs, ... }:
let
  stateVersion = "23.11";
  defaultGit = {
    extraConfig.github.user = "clempat";
    userEmail = "2178406+clempat@users.noreply.github.com";
    userName = "Clément Patout";
  };
  defaultUsername = "clement";
in {

  geist-mono = { lib, stdenvNoCC, fetchzip, }:
    stdenvNoCC.mkDerivation {
      pname = "geist-mono";
      version = "3.1.1";
      src = fetchzip {
        hash = "sha256-GzWly6hGshy8DYZNweejvPymcxQSIU7oGUmZEhreMCM=";
        stripRoot = false;
        url =
          "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/GeistMono.zip";
      };

      postInstall = ''
        install -Dm444 *.otf -t $out/share/fonts
      '';
    };

  mkDarwin = let isDarwin = true;
  in { hostname, git ? defaultGit, username ? defaultUsername, system
  , desktop ? null }:
  inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit self inputs outputs stateVersion hostname username git desktop
        isDarwin;
    };
    modules = [
      (import ../host/darwin/configuration.nix)

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs isDarwin desktop git stateVersion outputs username
            system;
        };
        home-manager.users.${username} = import ../home;
      }
    ];
  };

  # Helper function for generating home-manager configs
  mkHome = let isDarwin = false;
  in { hostname, username ? defaultUsername, desktop ? null, git ? defaultGit
  , system }:
  inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.nur.overlay ];
    };
    extraSpecialArgs = {
      inherit self inputs isDarwin desktop git stateVersion outputs username
        system hostname;
    };
    modules = [ ../home ];
  };

  # Helper function for generating host configs
  mkHost = let isDarwin = false;
  in { hostname, desktop ? null, pkgsInput ? inputs.nixpkgs, git ? defaultGit
  , username ? defaultUsername, system }:
  pkgsInput.lib.nixosSystem {
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.joypixels.acceptLicense = true;
      overlays = [ inputs.nur.overlay ];
    };

    specialArgs = {
      inherit self inputs outputs stateVersion username hostname desktop;
    };

    modules = [
      (import ../host/nixos)

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs isDarwin desktop git stateVersion outputs username
            system;
        };
        home-manager.users.${username} = import ../home;
      }
    ];
  };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
