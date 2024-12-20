{ config, desktop, hostname, inputs, lib, modulesPath, outputs, stateVersion
, username, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (./. + "/${hostname}/boot.nix")
    (./. + "/${hostname}/hardware.nix")

    ./common/base
    ./common/users/${username}
  ] ++ lib.optional (builtins.pathExists (./. + "/${hostname}/extra.nix"))
    ./${hostname}/extra.nix
    # Include desktop config if a desktop is defined
    ++ lib.optional (builtins.isString desktop) ./common/desktop;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mkForce
      (lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
        config.nix.registry);

    optimise.automatic = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  system = {
    inherit stateVersion;
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };
  };
}
