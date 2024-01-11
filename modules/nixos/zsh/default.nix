{ lib, config, programs, environment, user, pkgs, ... }:
let cfg = config.modules.zsh;
in
{
  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [ zsh spaceship-prompt ];
    users.users.${user} = {
      shell = pkgs.zsh;
    };
  };
}
