_: {
  programs.atuin = {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      sync_address = "https://atuin.patout.app";
      enter_accept = true;
      keymap_mode = "vim-insert";
    };
  };
}
