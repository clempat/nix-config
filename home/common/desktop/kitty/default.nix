{ inputs, pkgs, ... }: {
  programs.kitty = {
    enable = true;

    font = {
      name = "GeistMono Nerd Font";
      size = 15;
    };
    themeFile = "Catppuccin-Frappe";

    extraConfig = builtins.readFile ./kitty.conf;
  };

}
