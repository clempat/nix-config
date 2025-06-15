{ self, inputs, outputs, ... }:
let
  # Common configuration
  stateVersion = "23.11";
  defaultGit = {
    extraConfig.github.user = "clempat";
    userEmail = "2178406+clempat@users.noreply.github.com";
    userName = "Clément Patout";
  };
  defaultUsername = "clement";

  # Single function to create pkgs with unstable
  mkPkgs = { system }:
    import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        joypixels.acceptLicense = true;
      };
      overlays = [
        inputs.nur.overlays.default
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    };

  # Common home-manager configuration
  mkHomeManagerConfig = { pkgs, username, isDarwin, desktop ? null
    , git ? defaultGit, system, hostname }: {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit self inputs isDarwin desktop git stateVersion outputs username
          system hostname;
      };
      users.${username} = import ../home;
    };
in {
  mkDarwin = { hostname, git ? defaultGit, username ? defaultUsername, system
    , desktop ? null }:
    let
      isDarwin = true;
      pkgs = mkPkgs { inherit system; };
    in inputs.nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      specialArgs = {
        inherit self inputs outputs stateVersion hostname username git desktop
          isDarwin;
      };
      modules = [
        # inputs.sops-nix.nixosModules.sops
        (import ../host/darwin/configuration.nix)
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = mkHomeManagerConfig {
            inherit pkgs username isDarwin desktop git system hostname;
          };
        }
      ];
    };

  # Helper function for generating host configs
  mkHost = { hostname, desktop ? null, git ? defaultGit
    , username ? defaultUsername, system }:
    let
      isDarwin = false;
      pkgs = mkPkgs { inherit system; };
    in inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = {
        inherit self inputs outputs stateVersion username hostname desktop;
      };
      modules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.sops-nix.nixosModules.sops
        (import ../host/nixos)
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = mkHomeManagerConfig {
            inherit pkgs username isDarwin desktop git system hostname;
          };
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
