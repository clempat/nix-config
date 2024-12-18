{ pkgs, isDarwin, lib, config, ... }: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./lazygit.nix
    ./neofetch.nix
    ./neovim.nix
    ./nnn.nix
    ./starship.nix
    ./ssh.nix
    ./tmux
    ./zsh.nix
  ] ++ lib.optional (!isDarwin) ./xdg.nix;

  programs = {
    git.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    pyenv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    devpod
    devpod-desktop

    sesh
    _1password-cli
    nodejs
    # To move to project later
    # FIX: Do not know which one to install
    gdal
    heroku
    postgresql

    ffmpeg
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    NODE_VERSIONS = "$HOME/.nvm/versions/node";
    GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.dylib";
    GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c.dylib";
  };
}
