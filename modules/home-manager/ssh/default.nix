{ lib, services, programs, osConfig, ... }:
let cfg = osConfig.modules.ssh;
in
{
  config = lib.mkIf cfg.enable {
    services.ssh-agent.enable = true;
    programs.ssh.enable = true;
  };
}
