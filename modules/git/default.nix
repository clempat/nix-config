{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.git;
  _1password = config.mymodule._1password;
in
{
  options = {
    mymodule.git.enable = lib.mkEnableOption "Enable Git";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ git ];
      programs.git = {
        enable = true;
        userName = "Clement Patout";
        userEmail = "clement.patout@gmail.com";

        extraConfig = {
          core = {
            editor = "nvim";
          };
          color = {
            ui = true;
          };
          push = {
            default = "simple";
            autoSetupRemote = true;
          };
          pull = {
            ff = "only";
            rebase = true;
          };
          init = {
            defaultBranch = "main";
          };
          merge.conflictstyle = "diff3";
        };

        delta = {
          enable = true;
          options = {
            navigate = true;
            line-numbers = true;
            syntax-theme = "GitHub";
          };
        };
      };
    };
  };
}
