{ inputs, pkgs, ... }: {
  programs.kitty = {
    enable = true;

    package = pkgs.unstable.kitty;

    font = {
      name = "GeistMono Nerd Font";
      size = 15;
    };
    themeFile = "Catppuccin-Frappe";

    extraConfig = builtins.readFile ./kitty.conf;
  };

}
