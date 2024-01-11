{ lib, services, programs, config, ... }:
let cfg = config.modules.ssh;
in
{
  config = lib.mkIf cfg.enable {
    services.ssh-agent.enable = true;
    programs.ssh.enable = true;
  };
}
