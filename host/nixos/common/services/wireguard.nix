# WireGuard client configuration for UniFi server
{ pkgs, config, ... }: {
  # Enable WireGuard kernel module
  networking.wireguard.enable = true;

  # SOPS template for WireGuard configuration
  sops.templates."wg0.conf" = {
    content = ''
      [Interface]
      Address = 192.168.2.6/32
      ListenPort = 51820
      PrivateKey = ${config.sops.placeholder."wireguard/private_key"}

      [Peer]
      PublicKey = qAjEb1o20Thwf/614f22rkxHJG8qI2/NYKgXogUnoBM=
      Endpoint = ${config.sops.placeholder."wireguard/server"}:51820
      PersistentKeepalive = 25
      AllowedIPs = 192.168.2.0/24,192.168.10.0/24,192.168.30.0/24,0.0.0.0/0
    '';
    path = "/etc/wireguard/wg0.conf";
    owner = "root";
    group = "root";
    mode = "0600";
  };

  # Use wg-quick for WireGuard management
  networking.wg-quick.interfaces = {
    wg0 = { 
      configFile = config.sops.templates."wg0.conf".path;
      autostart = false; # Manual control via dispatcher script
    };
  };

  # NetworkManager dispatcher script for automatic VPN control
  networking.networkmanager.dispatcherScripts = [{
    source = pkgs.writeText "vpn-control" ''
      #!/bin/sh
      TRUSTED_SSIDS="Famille Patout"
      INTERFACE=$1
      STATUS=$2

      # Skip if this is the WireGuard interface itself
      if [ "$INTERFACE" = "wg0" ]; then
        exit 0
      fi

      # Only act on interface up/down events
      if [ "$STATUS" != "up" ] && [ "$STATUS" != "down" ]; then
        exit 0
      fi

      # Function to check if WireGuard is running
      is_wg_running() {
        ${pkgs.wireguard-tools}/bin/wg show wg0 >/dev/null 2>&1
      }

      # Function to start WireGuard
      start_wg() {
        if ! is_wg_running; then
          echo "Starting WireGuard interface wg0"
          ${pkgs.wireguard-tools}/bin/wg-quick up wg0 || true
        fi
      }

      # Function to stop WireGuard
      stop_wg() {
        if is_wg_running; then
          echo "Stopping WireGuard interface wg0"
          ${pkgs.wireguard-tools}/bin/wg-quick down wg0 || true
        fi
      }

      # Get current WiFi SSID
      CURRENT_SSID=$(${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
      
      # Check if connected to a trusted SSID
      for SSID in $TRUSTED_SSIDS; do
        if [ "$CURRENT_SSID" = "$SSID" ]; then
          echo "Connected to trusted network '$CURRENT_SSID', disabling WireGuard"
          stop_wg
          exit 0
        fi
      done
      
      # Not on trusted network and interface is up, enable WireGuard
      if [ "$STATUS" = "up" ]; then
        echo "Connected to untrusted network, enabling WireGuard"
        start_wg
      elif [ "$STATUS" = "down" ]; then
        echo "Network interface down, disabling WireGuard"
        stop_wg
      fi
    '';
    type = "basic";
  }];

  # Ensure WireGuard tools are available system-wide
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  # Open firewall for WireGuard
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
}