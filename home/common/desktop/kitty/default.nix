{ inputs, pkgs, ... }: {
  programs.kitty = {
    enable = true;

    package = pkgs.unstable.kitty.override {
      fish = pkgs.unstable.fish.overrideAttrs { doCheck = false; };
    };

    font = {
      name = "GeistMono Nerd Font";
      size = 15;
    };
    themeFile = "Catppuccin-Frappe";

    extraConfig = builtins.readFile ./kitty.conf;
  };

}
