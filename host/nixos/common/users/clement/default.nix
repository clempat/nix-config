{ pkgs, config, ... }:
let
  ifExists = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.jon = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "audio" "networkmanager" "users" "video" "wheel" ]
      ++ ifExists [ "docker" "plugdev" "render" "lxd" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPdCgvYn1SSEVlUd7XZo3jTJashU3aTWwH9SvzvQfP8M"
    ];

    packages = [ pkgs.home-manager ];
  };

  # This is a workaround for not seemingly being able to set $EDITOR in home-manager
  environment.sessionVariables = { EDITOR = "nvim"; };
}
