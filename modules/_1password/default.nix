{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule._1password;
  ssh = config.home-manager.users.${user}.programs.ssh;
  git = config.home-manager.users.${user}.programs.git;
  version = "8.10.23";
in
{
  options = {
    mymodule._1password.enable = lib.mkEnableOption "Enable 1Password";
  };

  config = lib.mkIf cfg.enable {
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user ];
    };
    programs._1password.enable = true;

    nixpkgs.overlays = [
      (self: super: {
        _1password-gui = super._1password-gui.overrideAttrs (_: {
          src = self.fetchurl {
            url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
            hash = "sha256-TqZ9AffyHl1mAKyZvADVGh5OXKZEGXjKSkXq7ZI/obA=";
          };
        });
      })
    ];
  };
}
