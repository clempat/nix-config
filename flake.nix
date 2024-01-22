{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
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
    theTimezone = "Europe/BErlin";
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
  in {
    nixosConfigurations = {
      "${hostname}" = nixpkgs.lib.nixosSystem {
	    specialArgs = { 
          inherit system; inherit inputs; 
          inherit username; inherit hostname;
          inherit gitUsername; inherit theTimezone;
          inherit gitEmail; inherit theLocale;
          inherit wallpaperDir; inherit wallpaperGit;
          inherit deviceProfile;
        };
	    modules = [ ./system.nix
	  nur.nixosModules.nur
          home-manager.nixosModules.home-manager {
	        home-manager.extraSpecialArgs = { inherit username; 
              inherit gitUsername; inherit gitEmail;
              inherit inputs; inherit theme;
              inherit browser; inherit wallpaperDir;
              inherit wallpaperGit; inherit flakeDir;
              inherit deviceProfile;
              inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
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
