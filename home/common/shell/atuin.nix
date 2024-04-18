_: {
  programs.atuin = {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      sync_address = "https://sh.patout.xyz";
      enter_accept = true;
      keymap_mode = "vim-insert";
    };
  };
}
