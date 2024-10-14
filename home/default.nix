{ config, lib, outputs, stateVersion, username, inputs, pkgs, isDarwin, desktop
, ... }: {
  # Only import desktop configuration if the host is desktop enabled
  # Only import user specific configuration if they have bespoke settings
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./common/shell
  ] ++ lib.optional (builtins.isString desktop) ./common/desktop
    ++ lib.optional (isDarwin) ./common/dev
    ++ lib.optional (isDarwin) ./common/desktop/kitty
    ++ lib.optional (isDarwin) ./common/desktop/alacritty.nix;
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

  nixpkgs = if isDarwin then {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  } else {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
    ];

    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [ "electron-25.9.0" ];
    };
  };
}
