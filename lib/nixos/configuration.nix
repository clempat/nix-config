{ pkgs, ... }: {

  # Programs
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ username ];
  };
  programs._1password.enable = true;
  nixpkgs.overlays = [
    (self: super: {
      _1password-gui = super._1password-gui.overrideAttrs (_: {
        src = self.fetchurl {
          url =
            "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
          hash = "sha256-TqZ9AffyHl1mAKyZvADVGh5OXKZEGXjKSkXq7ZI/obA=";
        };
      });
    })
  ];

  programs.firefox = {
    enable = true;
    preferences = { "widget.use-xdg-desktop-portal.file-picker" = 1; };
  };

  # List System Programs
  environment.systemPackages = with pkgs; [
    ansible
    cmake
    dnsutils
    esphome
    esptool
    fd
    fluxcd
    fzf
    gcc
    gitleaks
    gnome.gnome-keyring
    go
    go-task
    hyprshade
    killall
    kubectl
    kubectl-tree
    kubernetes-helm
    kustomize
    libsForQt5.okular
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    nextcloud-client
    polkit_gnome
    prettierd
    ripgrep
    sops
    tailscale-systray
    teams-for-linux
  ];

  # List services that you want to enable:
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
      theme = "sugar-dark";
    };
  };

  services.flatpak.enable = true;

  environment.systemPackages =
    let themes = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix { };
    in [
      themes.sddm-sugar-dark
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      pkgs.distrobox
    ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Polkit
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.openssh.enable = true;
  services.fstrim.enable = true;
  xdg.portal = {
    enable = true;
    config = { common.default = "gtk"; };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.pulseaudio.enable = false;
  sound.enable = true;
  security.rtkit.enable = true;
  programs.thunar.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.tailscale.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = { };
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

}
