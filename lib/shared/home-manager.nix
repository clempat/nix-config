{ inputs }:
{ git }:
{ pkgs, ... }:
let
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  system = pkgs.system;
in {
  imports = [
    (import ./tmux.nix {
      inherit inputs;
      inherit pkgs;
    })
  ];

  home.packages = with pkgs; [
    atuin
    bat
    cachix
    delta
    fd
    jq
    k9s
    kubectl
    lazydocker
    ripgrep
    postman

    # Import Scripts
    (import ./../../scripts/tmux-sessionizer.nix { inherit pkgs; })
    (import ./../../scripts/kn.nix { inherit pkgs; })
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };

  home.stateVersion = "23.11";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.git = pkgs.lib.recursiveUpdate git {
    delta = {
      enable = true;
      options = {
        chameleon = {
          blame-code-style = "syntax";
          blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
          blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
          dark = true;
          file-added-label = "[+]";
          file-copied-label = "[==]";
          file-decoration-style = "#434C5E ul";
          file-modified-label = "[*]";
          file-removed-label = "[-]";
          file-renamed-label = "[->]";
          file-style = "#434C5E bold";
          hunk-header-style = "omit";
          keep-plus-minus-markers = true;
          line-numbers = true;
          line-numbers-left-format = " {nm:>1} │";
          line-numbers-left-style = "red";
          line-numbers-minus-style = "red italic black";
          line-numbers-plus-style = "green italic black";
          line-numbers-right-format = " {np:>1} │";
          line-numbers-right-style = "green";
          line-numbers-zero-style = "#434C5E italic";
          minus-emph-style = "bold red";
          minus-style = "bold red";
          plus-emph-style = "bold green";
          plus-style = "bold green";
          side-by-side = true;
          syntax-theme = "Nord";
          zero-style = "syntax";
        };
        features = "chameleon";
        side-by-side = true;
      };
    };
    extraConfig = {
      color.ui = true;
      commit.gpgsign = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      pull.ff = "only";
      pull.rebase = "true";
      gpg.format = "ssh";
      "ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      signing = {
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOR4x6DZqrgy8cuxcU/2Zvjx8664hrAK+MgChuuKvbYJ";
        signByDefault = true;
      };
    };

  };

  programs.kitty = {
    enable = true;

    font = {
      name = "GeistMono";
      package = inputs.self.packages.${pkgs.system}.geist-mono;
      size = 15;
    };

    settings = {
      active_border_color = "#ee5396";
      active_tab_background = "#ee5396";
      active_tab_foreground = "#161616";
      allow_remote_control = "yes";
      background = "#161616";
      background_opacity = "0.9";
      bell_border_color = "#ee5396";
      color0 = "#262626";
      color1 = "#ff7eb6";
      color10 = "#42be65";
      color11 = "#82cfff";
      color12 = "#33b1ff";
      color13 = "#ee5396";
      color14 = "#3ddbd9";
      color15 = "#ffffff";
      color2 = "#42be65";
      color3 = "#82cfff";
      color4 = "#33b1ff";
      color5 = "#ee5396";
      color6 = "#3ddbd9";
      color7 = "#dde1e6";
      color8 = "#393939";
      color9 = "#ff7eb6";
      cursor = "#f2f4f8";
      cursor_text_color = "#393939";
      confirm_os_window_close = 0;
      enabled_layouts = "splits";
      foreground = "#dde1e6";
      hide_window_decorations = "titlebar-and-corners";
      inactive_border_color = "#ff7eb6";
      inactive_tab_background = "#393939";
      inactive_tab_foreground = "#dde1e6";
      listen_on = "unix:/tmp/kitty";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "system";
      selection_background = "#525252";
      selection_foreground = "#f2f4f8";
      tab_bar_background = "#161616";
      url_color = "#ee5396";
      url_style = "single";
      wayland_titlebar_color = "system";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --color-only --dark --paging=never";
          useConfig = false;
        };
      };
    };
  };

  programs.neovim = inputs.clement-nvim.lib.mkHomeManager { inherit system; };

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override { withNerdIcons = true; };
    plugins = {
      mappings = { K = "preview-tui"; };
      src = pkgs.nnn + "/plugins";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = { add_newline = false; };
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = if isDarwin then ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '' else ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    sessionVariables.SSH_AUTH_SOCK = "~/.1password.agent.sock";

    initExtra = ''
      n () {
        if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
          echo "nnn is already running"
          return
        fi

        export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

        nnn -adeHo "$@"

        if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
        fi
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      cat = "bat";
      dr = "docker container run --interactive --rm --tty";
      lg = "lazygit";
      ll = if isDarwin then "n" else "n -P K";
      nb = "nix build --json --no-link --print-build-logs";
      s = ''doppler run --config "nixos" --project "$(whoami)"'';
      wt = "git worktree";
    };

    syntaxHighlighting = { enable = true; };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Neofetch
  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
        info "$(color 6)  OS " distro
        info underline
        info "$(color 7)  VER" kernel
        info "$(color 2)  UP " uptime
        info "$(color 4)  PKG" packages
        info "$(color 6)  DE " de
        info "$(color 5)  TER" term
        info "$(color 3)  CPU" cpu
        info "$(color 7)  GPU" gpu
        info "$(color 5)  MEM" memory
        prin " "
        prin "$(color 1) $(color 2) $(color 3) $(color 4) $(color 5) $(color 6) $(color 7) $(color 8)"
    }
    distro_shorthand="on"
    memory_unit="gib"
    cpu_temp="C"
    separator=" $(color 4)>"
    stdout="off"
  '';

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.cache.disk.enable" = true;
          "browser.newtabpage.pinned" = [{
            title = "Home Assistant";
            url = "http://192.168.40.200:8123";
          }];
          "browser.ctrlTab.sortByRecentlyUsed" = true;
        };
        search = {
          force = true;
          default = "Ecosia";
          order = [ "Ecosia" "DuckDuckGo" ];
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "Ecosia" = {
              urls = [{
                template = "https://www.ecosia.org/search?q={searchTerms}";
              }];
              iconUpdateURL = "https://www.ecosia.org/static/icons/favicon.ico";
              definedAliases = [ "@eco" ];
            };
            "Bing".metaData.hidden = true;
            "DuckDuckGo".metaData.alias =
              "@d"; # builtin engines only support specifying one additional alias
          };
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          aria2-integration
          buster-captcha-solver
          clearurls
          container-tabs-sidebar
          decentraleyes
          libredirect
          no-pdf-download
          react-devtools
          reduxdevtools
          #tridactyl
          ublock-origin
          omnivore
          darkreader
          languagetool
          tabcenter-reborn
          onepassword-password-manager
          ecosia
          fediact
          raindropio
        ];

        userChrome = builtins.readFile ./files/userChrome.css;
      };
    };
  };

}
