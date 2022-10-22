{config, lib, pkgs, inputs, user,...}:

{
  imports =
    [(import ./hardware-configuration.nix)] ++
    [(import ../../modules/desktop/i3/default.nix)];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = '/boot/efi';
      };
      timeout = 1;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      discord
    ];
  };

  services = {
    blueman.enable = true;
    printing = {
      enable = true;
    };

    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    # Set a password with `smbpasswd -a <user>`
    samba = {
      enable = true;
      shares = {
        share = {
          "path" = "/home/${user}";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };

  };
  

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "0qaczvp79b4gzzafgc5ynp6h4nd2ppvndmj6pcs1zys3c0hrabpv";
        };}
      );
    })
  ];
}
