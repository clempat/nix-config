{
  description = "clement's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-flatpak.url = "github:gmodena/nix-flatpak/";

    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    clement-nvim.url = "github:clempat/nvim-config";
    tmux-sessionx.url = "github:omerxx/tmux-sessionx";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ai-tools.url = "github:clempat/ai-tools-flake";
    ai-tools.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "23.11";
      username = "clement";

      mkSystems = import ./lib/mkSystems.nix {
        inherit
          self
          inputs
          outputs
          stateVersion
          username
          ;
      };
    in
    {

      darwinConfigurations =
        let
          username = "clementpatout";
        in
        {
          "${username}@mondo" = mkSystems.mkDarwin {
            inherit username;
            hostname = "MONDO-1325.local";
            system = "aarch64-darwin";
          };
        };

      # nix build .#nixosConfigurations.clement.config.system.build.toplevel
      nixosConfigurations = {
        # Desktop machines
        tuxedo = mkSystems.mkHost {
          hostname = "tuxedo";
          desktop = "kde";
          system = "x86_64-linux";
        };
        sparrow = mkSystems.mkHost {
          hostname = "sparrow";
          system = "x86_64-linux";
        };
      };

      # Custom packages; acessible via 'nix build', 'nix shell', etc
      packages = mkSystems.forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );

      # Custom overlays
      overlays = import ./overlays { inherit inputs; };

      # Devshell for bootstrapping
      # Accessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = mkSystems.forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      formatter = mkSystems.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-classic);
    };
}
