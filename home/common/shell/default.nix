{ inputs, pkgs, isDarwin, lib, config, ... }: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./ai-tools.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./lazygit.nix
    ./neofetch.nix
    ./nnn.nix
    ./sops.nix
    ./starship.nix
    ./ssh.nix
    ./tmux
    ./zsh.nix
  ] ++ lib.optional (!isDarwin) ./xdg.nix;

  programs = {
    git.enable = true;
    home-manager.enable = true;
    jq = {
      enable = true;
      package = pkgs.unstable.jq;
    };
    pyenv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs.unstable; [
    devpod

    sesh
    inputs.worktrunk.packages.${pkgs.stdenv.hostPlatform.system}.worktrunk-with-git-wt
    _1password-cli
    nodejs
    # To move to project later
    # FIX: Do not know which one to install
    gdalMinimal # FIX: Minimal GDAL without PostgreSQL dependencies
    gcalcli
    heroku
    tmuxinator

    nil
    nixd

    ffmpeg
  ];

  home.sessionVariables = {
    GDAL_DATA = "${pkgs.gdalMinimal}/share/gdal";
    GDAL_LIBRARY_PATH = "${pkgs.gdalMinimal}/lib/libgdal.dylib";
    GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c.dylib";
    OLLAMA_HOST = "0.0.0.0:11434";
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };

  # Configure pnpm global settings (only affects your machine)
  xdg.configFile."pnpm/rc".text = ''
    store-dir=~/.pnpm-store
    global-dir=~/.pnpm-global
    global-bin-dir=~/.local/bin
    auto-install-peers=true
    dedupe-peer-dependents=false
  '';

  xdg.configFile."worktrunk/config.toml".text = ''
    worktree-path = "{{ repo_path }}/.worktrees/{{ branch | sanitize }}"

    [post-switch]
    rename_tmux_window = "[ -n \"$TMUX\" ] && tmux rename-window '{{ branch | sanitize }}'"

    [post-create]
    direnv_allow = "[ -f .envrc ] && direnv allow ."
    rename_tmux_window = "[ -n \"$TMUX\" ] && tmux rename-window '{{ branch | sanitize }}'"
  '';

  xdg.configFile."sesh/sesh.toml".text = ''
    [[session]]
    name = "nix-config"
    path = "~/workspace/clempat/nix-config"
    startup_command = "nvim"

    [[search_paths]]
    path = "~/workspace/thermondo"
    depth = 1

    [[search_paths]]
    path = "~/workspace/clempat"
    depth = 1

    [[search_paths]]
    path = "~/workspace/_sandbox"
    depth = 1
  '';
}
