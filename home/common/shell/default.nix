{ pkgs, isDarwin, lib, ... }: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./lazygit.nix
    ./neofetch.nix
    ./neovim.nix
    ./nnn.nix
    ./starship.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ] ++ lib.optional (!isDarwin) ./xdg.nix;

  programs = {
    eza.enable = true;
    git.enable = true;
    home-manager.enable = true;
    jq.enable = true;
  };

  home.packages = with pkgs; [ ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };
}
