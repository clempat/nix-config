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
  mkHome =
    { hostname, username ? defaultUsername, desktop ? null, git ? defaultGit }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.unstable.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit self inputs outputs stateVersion hostname desktop username git;
      };
      modules = [
        inputs.hypridle.homeManagerModules.default
        inputs.hyprlock.homeManagerModules.default
        ../home
      ];
    };

  # Helper function for generating host configs
  mkHost = { hostname, desktop ? null, pkgsInput ? inputs.unstable
    , username ? defaultUsername }:
    pkgsInput.lib.nixosSystem {
      specialArgs = {
        inherit self inputs outputs stateVersion username hostname desktop;
      };
      modules = [ inputs.lanzaboote.nixosModules.lanzaboote ../host/nixos ];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
