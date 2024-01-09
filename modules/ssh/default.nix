{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.ssh;
  _1password = config.mymodule._1password;
in
{
  options = {
    mymodule.ssh.enable = lib.mkEnableOption "Enable SSH";
  };

  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        allowSFTP = true;
        extraConfig = ''
          HostKeyAlgorithms +ssh-rsa
        '';
      };
    };

    home-manager.users.${user} = {
      services.ssh-agent.enable = true;
      programs.ssh.enable = true;
    };
  };
}
