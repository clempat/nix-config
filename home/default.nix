{ config, lib, outputs, stateVersion, username, inputs, pkgs, isDarwin, desktop
, ... }: {
  imports = [ ./common/shell ] ++ lib.optional (builtins.isString desktop)
    ./common/desktop
    # Include in desktop:
    ++ lib.optional (isDarwin) ./common/dev
    ++ lib.optional (isDarwin) ./common/desktop/kitty
    ++ lib.optional (isDarwin) ./common/desktop/alacritty.nix
    ++ lib.optional (isDarwin) ./aerospace
    ++ lib.optional (isDarwin) ./sketchybar;
  # ++ lib.optional (isDarwin) ./common/desktop/firefox;

  home = lib.mkMerge [
    (lib.mkIf (!isDarwin) { homeDirectory = "/home/${username}"; })
    {
      inherit username stateVersion;
      activation.report-changes = config.lib.dag.entryAnywhere ''
        if [[ -n "$oldGenPath" && -n "$newGenPath" ]]; then
          ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
        fi
      '';
    }

  ];
}
