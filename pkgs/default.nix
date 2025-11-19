# Custom packages, that can be defined similarly to ones from nixpkgs
# Build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  tuxedo-tray = pkgs.callPackage ../scripts/tuxedo-tray.nix { };
  spec-kit = pkgs.callPackage ./spec-kit.nix { };
}
