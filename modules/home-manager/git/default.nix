{ osConfig, lib, pkgs, ... }:
let cfg = osConfig.modules.git;
in
{
  config = lib.mkIf cfg.enable {
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
}
