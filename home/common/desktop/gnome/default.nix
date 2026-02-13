{ pkgs, ... }: {

  imports = [ ];
  programs.gnome-shell.theme = pkgs.nordic;
  gtk.theme = {
    name = "Nordic";
    package = pkgs.nordic;
  };
}

