{ pkgs, ... }:
let
  theme = import "${self}/lib/theme" { inherit pkgs; };
  inherit (theme) colours;
in {
  programs.kitty = {
    enable = true;

    font = {
      name = "${theme.fonts.monospace.name}";
      size = 15;
    };

    settings = {
      foreground = "${colours.text}";
      background = "${colours.bg}";
      title_fg = "${colours.subtext0}";

      title_bg = "${colours.mantle}";
      margin_bg = "${colours.mantle}";
    };

    margin_fg = "${colours.subtext1}";

    filler_bg = "${colours.mantle}";

    remove_bg = "#604456";

    highlight_removed_bg = "#895768";

    removed_margin_bg = "#744D5F";

    added_bg = "#4B5D55";

    highlight_added_bg = "#658168";
    added_margin_bg = "#586F5E";

    hunk_margin_bg = "${colours.mantle}";
    hunk_bg = "${colours.mantle}";

    search_bg = "#EED49F";

    search_fg = "${colours.text}";
    select_bg = "#445B6C";
    select_fg = "${colours.text}";

  };
}
