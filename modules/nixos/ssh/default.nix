{ lib, config, services, ... }:
let cfg = config.modules.ssh;
in
{
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
  };
}
