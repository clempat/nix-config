
# NixOS configuration
This is my personal NixOS configuration, working with flakes and Home management.

I have currently two hosts setup:
- laptop
- desktop

## Install on a new machine with live CD

```bash
sudo su
```

```bash
nix-env -iA nixos.git
```

```bash
git clone https://github.com/clempat/nix-config.git /mnt/etc/nixos
```

```bash
nixos-install --flake .#clement
```

Reboot

Check if default configuration is created under `/etc/nixos/configuration.nix` if yes, delete it.

Finally move everything to the home directory

