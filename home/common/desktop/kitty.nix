{ inputs, pkgs, ... }: {
  programs.kitty = {
    enable = true;

    font = {
      name = "GeistMono";
      size = 15;
    };

    settings = {
      active_border_color = "#ee5396";
      active_tab_background = "#ee5396";
      active_tab_foreground = "#161616";
      allow_remote_control = "yes";
      background = "#161616";
      background_opacity = "0.9";
      bell_border_color = "#ee5396";
      color0 = "#262626";
      color1 = "#ff7eb6";
      color10 = "#42be65";
      color11 = "#82cfff";
      color12 = "#33b1ff";
      color13 = "#ee5396";
      color14 = "#3ddbd9";
      color15 = "#ffffff";
      color2 = "#42be65";
      color3 = "#82cfff";
      color4 = "#33b1ff";
      color5 = "#ee5396";
      color6 = "#3ddbd9";
      color7 = "#dde1e6";
      color8 = "#393939";
      color9 = "#ff7eb6";
      cursor = "#f2f4f8";
      cursor_text_color = "#393939";
      confirm_os_window_close = 0;
      enabled_layouts = "splits";
      foreground = "#dde1e6";
      hide_window_decorations = "titlebar-only";
      inactive_border_color = "#ff7eb6";
      inactive_tab_background = "#393939";
      inactive_tab_foreground = "#dde1e6";
      listen_on = "unix:/tmp/kitty";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "system";
      selection_background = "#525252";
      selection_foreground = "#f2f4f8";
      tab_bar_background = "#161616";
      url_color = "#ee5396";
      url_style = "single";
      wayland_titlebar_color = "system";
    };
  };
}
