{ pkgs, config, username, ... }:
let
  ifExists = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "audio" "networkmanager" "users" "video" "wheel" ]
      ++ ifExists [ "docker" "plugdev" "render" "lxd" "games" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPdCgvYn1SSEVlUd7XZo3jTJashU3aTWwH9SvzvQfP8M"
    ];

    packages = [ pkgs.home-manager ];
  };

  # This is a workaround for not seemingly being able to set $EDITOR in home-manager
  environment.sessionVariables = {
    EDITOR = "nvim";
    NODE_VERSIONS = "$HOME/.nvm/versions/node";
    GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.dylib";
    GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c.dylib";
    RES_OPTIONS = "nameserver 192.168.40.254";
  };
}
