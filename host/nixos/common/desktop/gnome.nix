{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = (with pkgs.gnomeExtensions;
    [ 
      blur-my-shell 
      pop-shell 
      pip-on-top
      firefox-pip-always-on-top
      clipboard-indicator
    ]) ++ (with pkgs;[ 
      polkit_gnome 
      nordic 
      gnome-tweaks
    ]);

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ]);

}
