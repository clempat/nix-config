{ inputs, ... }:
let
  defaultGit = {
    extraConfig.github.user = "clempat";
    userEmail = "2178406+clempat@users.noreply.github.com";
    userName = "Clément Patout";
  };
  defaultUsername = "clementpatout";
  homeManagerNixos = import ./nixos/home-manager.nix { inherit inputs; };
  homeManagerShared = import ./shared/home-manager.nix { inherit inputs; };
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

  mkDarwin = { git ? defaultGit, username ? defaultUsername, }:
    { system }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        (import ./darwin/configuration.nix { inherit username; })

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = { pkgs, ... }: {
            imports = [ (homeManagerShared { inherit git; }) ];
          };
        }
      ];
    };

  mkNixos = { desktop ? true, git ? defaultGit, machine ? "tuxedo"
    , username ? defaultUsername, }:
    { system }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Scripts
        (import ./../scripts/nvidia-offload.nix)
        (import ./../scripts/theme-selector.nix)

        # Configuration
        (import ./nixos/hardware/${machine}/${system}.nix)
        (import ./nixos/hardware/${machine}/boot.nix)
        (import ./nixos/configuration.nix { inherit inputs desktop username; })
        (import ./nixos/configuration-desktop.nix { inherit username; })

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = { pkgs, ... }: {
            imports = [
              (homeManagerNixos { inherit desktop; })
              (homeManagerShared { inherit git; })
            ];
          };
        }
      ];
    };
}
