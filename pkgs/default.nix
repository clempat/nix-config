# Custom packages, that can be defined similarly to ones from nixpkgs
# Build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  nixfmt = pkgs.callPackage ./nixfmt.nix { };
  geist = pkgs.callPackage ./fonts/geist.nix { };
  geist-mono = pkgs.callPackage ./fonts/geist-mono.nix { };
  geist-nf = pkgs.callPackage ./fonts/geist-nf.nix { };
}
