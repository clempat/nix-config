{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";
    clement-nvim.url = "github:clempat/nvim-config";
  };

  outputs = inputs@{ nixpkgs, home-manager, nur, ... }:
    let
      system = "x86_64-linux";

      # User Variables
      hostname = "tuxedo";
      username = "clement";
      gitUsername = "Clement Patout";
      gitEmail = "clement.patout@gmail.com";
      theLocale = "en_US.UTF-8";
      theLCVariables = "fr_FR.UTF-8";
      theTimezone = "Europe/Berlin";
      theKBDLayout = "us";
      theKBDVariant = "altgr-intl";
      theme = "dracula";
      browser = "firefox";
      wallpaperGit = "https://gitlab.com/Zaney/my-wallpapers.git";
      wallpaperDir = "/home/${username}/Pictures/Wallpapers";
      flakeDir = "/home/${username}/workspace/github/Zaney/zaneyos";
      # Configuration option profile
      # default options amd-desktop, intel-laptop, vm (WIP)
      deviceProfile = "intel-laptop";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nur.overlay
        ];
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system; inherit inputs;
            inherit username; inherit hostname;
            inherit gitUsername; inherit theTimezone;
            inherit gitEmail; inherit theLocale;
            inherit wallpaperDir; inherit wallpaperGit;
            inherit deviceProfile; inherit theKBDLayout;
            inherit theLCVariables; inherit theKBDVariant;
          };
          modules = [
            ./system.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit gitUsername; inherit gitEmail;
                inherit inputs; inherit theme;
                inherit browser; inherit wallpaperDir;
                inherit wallpaperGit; inherit flakeDir;
                inherit deviceProfile; inherit theKBDLayout;
                inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
                inherit theLCVariables; inherit theKBDVariant;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              nixpkgs.overlays = [
                nur.overlay
              ];
            }
          ];
        };
      };
    };
}
