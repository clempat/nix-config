{ isDarwin, ... }: {
  programs.gpg.enable = true;

  services.gpg-agent = if isDarwin then
    { }
  else {
    enable = true;
    pinentryFlavor = "curses";
  };

}
