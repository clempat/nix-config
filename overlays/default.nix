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
          outputHash = "sha256-1ZxetDrrRdNNOfDOW2uMwMwpEs5S3BLF+SejWcRdtik=";
        });
        tui = old.tui.overrideAttrs (tuiOld: {
          vendorHash = "sha256-Qvn59PU95TniPy7JaZDJhn/wUCfFYM+7bzav1jxNv34=";
        });
      });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
