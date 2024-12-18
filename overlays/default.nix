{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = _final: prev:
    {
      { discord = prev.discord.overrideAttrs (_: { src = builtins.fetchTarball https://stable.dl2.discordapp.net/apps/linux/0.0.71/discord-0.0.71.tar.gz; })
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
    };
}
