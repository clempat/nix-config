{ pkgs, git, isDarwin, config, lib, ... }: {

  home.packages = with pkgs; [ gh gh-dash ];

  programs.git = pkgs.lib.recursiveUpdate git {
    iniContent.gpg = {
      format = lib.mkForce "ssh";
      ssh = { program = config.programs.git.signing.gpgPath; };
    };
    signing = {
      key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOR4x6DZqrgy8cuxcU/2Zvjx8664hrAK+MgChuuKvbYJ";
      signByDefault = true;
      gpgPath = if isDarwin then
        "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
      else
        "${pkgs.unstable._1password-gui}/bin/op-ssh-sign";
    };
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
      # issues with lazyvim
      # remote.origin.fetch = "+refs/heads/*:refs/remotes/origin/*";
    };

  };
}
