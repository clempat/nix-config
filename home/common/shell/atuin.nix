_: {
  programs.atuin = {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      sync_address = "https://atuin.patout.xyz";
      enter_accept = true;
      keymap_mode = "vim-insert";
    };
  };
}
