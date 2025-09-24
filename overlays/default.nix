{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = _final: prev: {
    discord = prev.discord.overrideAttrs (_: {
      src = builtins.fetchTarball
        "https://stable.dl2.discordapp.net/apps/linux/0.0.71/discord-0.0.71.tar.gz";
    });
    # Use a wrapper for opencode that sets up proper library paths for ARM64
    opencode = prev.writeShellScriptBin "opencode" ''
      export LD_LIBRARY_PATH="${prev.stdenv.cc.cc.lib}/lib:${prev.glibc}/lib:$LD_LIBRARY_PATH"
      exec ${inputs.nixpkgs-unstable.legacyPackages.${prev.system}.opencode}/bin/opencode "$@"
    '';
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
