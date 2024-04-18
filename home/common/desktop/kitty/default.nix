{ inputs, pkgs, ... }: {
  programs.kitty = {
    enable = true;

    font = {
      name = "GeistMono Nerd Font";
      size = 15;
    };
    theme = "Catppuccin-Frappe";

    extraConfig = builtins.readFile ./kitty.conf;
  };

}
