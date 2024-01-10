
# NixOS configuration
This is my personal NixOS configuration, working with flakes and Home management.

I have currently two hosts setup:
- laptop
- desktop

## Install on a new machine with live CD

Follow the instructions on https://nixos.org/manual/nixos/stable/#sec-installation-manual to have all disks setup correctly. And generate the default nix config.

```bash
sudo su
```

```bash
nix-env -iA nixos.git
```

```bash
mkdir -p /mnt/home/clement/workspace/perso/nix-config
git clone https://github.com/clempat/nix-config.git /mnt/home/clement/workspace/perso/nix-config
```

Compare the generated hardware config to the one in the repository according to the target. Adapt if needed.

```bash
NIX_SYSTEM=tuxedo nixos-install --flake /mnt/home/clement/workspace/perso/nix-config#${NIX_SYSTEM}
```

Fix potential issue such as SHA256 or due do nix breaking changes. Then re-run the command above.

Reboot

## Install on MacOS

Install Nix: https://nixos.org/download.html#nix-install-macos

See more about nix-darwin on https://github.com/LnL7/nix-darwin#flakes

```bash
mkdir -p /mnt/home/clement/workspace/perso/nix-config
git clone https://github.com/clempat/nix-config.git /mnt/home/clement/workspace/perso/nix-config
```
```bash
NIX_SYSTEM=macos nix run nix-darwin -- switch --flake /mnt/home/clement/workspace/perso/nix-config#${NIX_SYSTEM}
```

## Templates for module

```nix
{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.test;
in
{
  options = {
    mymodule.test.enable = lib.mkEnableOption "This is my test";
  };

  config = lib.mkIf cfg.enable {
    # ...
    home-manager.users.${user} = {
      # ...
    };
  };
}
```