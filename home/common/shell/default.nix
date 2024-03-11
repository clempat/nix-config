{ pkgs, isDarwin, lib, ... }: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./neofetch.nix
    ./neovim.nix
    ./nnn.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ] ++ lib.optional (!isDarwin) ./xdg.nix ++ lib.optional (!isDarwin) ./gpg.nix;

  programs = {
    eza.enable = true;
    git.enable = true;
    home-manager.enable = true;
    jq.enable = true;
  };

  home.packages = with pkgs; [ ];
}
