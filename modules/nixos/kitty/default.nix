{ lib, config, environment, ... }:
let cfg = config.modules.kitty;
in
{
  config = lib.mkIf cfg.enable {
    environment.variables.TERMINAL = "kitty";
  };
}
