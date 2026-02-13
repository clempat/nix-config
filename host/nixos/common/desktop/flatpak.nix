{ services, lib, ... }: {
  services.flatpak.enable = true;
  services.flatpak.remotes = lib.mkOptionDefault [{
    name = "flathub-beta";
    location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  }];

  services.flatpak.packages =
    [ "com.todoist.Todoist" "md.obsidian.Obsidian" "com.logseq.Logseq" ];

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };

  services.flatpak.overrides = {
    global = {
      # Force Wayland by default
      Context.sockets = [ "wayland" "!x11" "!fallback-x11" ];

      Environment = {
        # Fix un-themed cursor in some Wayland apps
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

        # Force correct theme for some GTK apps
        GTK_THEME = "Adwaita:dark";
      };
    };

    "com.todoist.Todoist".Context.sockets = [ "x11" ]; # No Wayland support
    "com.logseq.Logseq".Context.sockets = [ "x11" ]; # No Wayland support
  };
}
