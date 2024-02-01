
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

Make sure you use the same username on the Mac than in the configuration.

Install Nix: https://nixos.org/download.html#nix-install-macos

See more about nix-darwin on https://github.com/LnL7/nix-darwin#flakes

```bash
mkdir -p ~/workspace/perso/nix-config
```
```bash
git clone https://github.com/clempat/nix-config.git ~/workspace/perso/nix-config
```

Install brew.sh
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```bash
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes  -- switch --flake ~/workspace/perso/nix-config#macbook
```

## Templates for module

Add the module option in ./modules/default.nix
```nix
zsh.enable = lib.mkEnableOption "Enable ZSH";
```

Add the nix file either in darwin, home-manager or nixos with:
```nix
{ lib, osConfig, pkgs, ... }:
let cfg = osConfig.modules.zsh;
in
{
  config = lib.mkIf cfg.enable
    {
     #...
    };
}

```
