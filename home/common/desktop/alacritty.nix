{ pkgs, ... }: {
  programs.alacritty = let
    catpuccin-frappe = pkgs.fetchurl {
      url =
        "https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-frappe.toml";
      hash = "sha256-DmZRJtlogPUBYw06JLAa5vePAjYuikT5sAL4juEIXeU=";
    };
  in {
    enable = true;
    settings = {
      import = [ catpuccin-frappe ];
      live_config_reload = true;
      # env = { TERM = "xterm-256color"; };
      window = {
        decorations = "buttonless";
        dynamic_padding = false;
        opacity = 0.9;
        padding = {
          x = 25;
          y = 20;
        };
      };
      shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [ "new-session" "-A" "-D" "-s" "default" ];
      };
      font = {
        size = 15;
        normal = {
          family = "GeistMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "GeistMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "GeistMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "GeistMono Nerd Font";
          style = "Bold Italic";
        };
      };
    };
  };
}
