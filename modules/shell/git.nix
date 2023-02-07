{ pkgs, user, ... }:
{


  programs.git = {
    enable = true;
    userName = "Clement Patout";
    userEmail = "clement.patout@gmail.com";

    signing = {
      signByDefault = true;
    };

    extraConfig = {
      core = {
        editor = "nvim";
      };
      color = {
        ui = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        ff = "only";
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
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
}
