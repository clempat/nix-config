# Shell for bootstrapping flake-enabled nix and home-manager
# Access development shell with  'nix develop' or (legacy) 'nix-shell'
{
  pkgs ? (import ./nixpkgs.nix) { },
}:
{
  default = pkgs.mkShell {
    name = "clement-flake";
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      deadnix
      nixfmt-rfc-style
      pre-commit
      yamllint
      sops
      # Add C++ standard library and other common dependencies
      stdenv.cc.cc.lib
      glibc
    ];
    shellHook = ''
      # Ensure C++ standard library is available
      export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.glibc}/lib:$LD_LIBRARY_PATH"
    '';
  };
}
