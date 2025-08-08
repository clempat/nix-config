{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = _final: prev: {
    discord = prev.discord.overrideAttrs (_: {
      src = builtins.fetchTarball
        "https://stable.dl2.discordapp.net/apps/linux/0.0.71/discord-0.0.71.tar.gz";
    });
    opencode =
      inputs.nixpkgs-unstable.legacyPackages.${prev.system}.opencode.overrideAttrs
      (old: {
        version = "0.3.54";
        src = inputs.opencode;
        node_modules = old.node_modules.overrideAttrs (nmOld: {
          outputHash = "sha256-XIRV1QrgRHnpJyrgK9ITxH61dve7nWfVoCPs3Tc8nuU=";
        });
        tui = old.tui.overrideAttrs (tuiOld: {
          vendorHash = "sha256-MZAKEXA34dHiH4XYUlLq6zo8ppG8JD3nj7fhZMrr+TI=";
        });
      });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
