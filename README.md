# Nix Config

WIP

## Commands

```sh
# NixOS
nixos-rebuild switch --flake .#tuxedo --fast --use-remote-sudo --upgrade

# Darwin
darwin-rebuild switch --flake .#clementpatout@mondo
```

## Troubleshooting

### Pin package to specific version

If a package has broken tests or build issues, pin it in `overlays/default.nix`:

```nix
# Disable tests
packageName = prev.packageName.overrideAttrs (_: { doCheck = false; });

# Pin to specific commit
packageName = prev.packageName.overrideAttrs (_: {
  src = prev.fetchFromGitHub {
    owner = "owner";
    repo = "repo";
    rev = "commit-sha";
    sha256 = "sha256-...";
  };
});
```

For unstable packages, also add overlay in `lib/mkSystems.nix` under `unstable` import.
