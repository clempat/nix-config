{ config, pkgs, ... }:

{
  imports = [
    ./amd-opengl.nix
    ./boot.nix
    ./displaymanager.nix
    ./intel-opengl.nix
    ./polkit.nix
    ./programs.nix
    ./services.nix
  ];
}

