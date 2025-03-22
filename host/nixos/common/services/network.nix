{ lib, pkgs, config, ... }: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = { backend = "iwd"; };
      # Define trusted networks where VPN should not be active
      dispatcherScripts = [
        {
          source = pkgs.writeText "vpn-control" ''
            #!/bin/sh
            TRUSTED_SSIDS="Famille Patout"
            INTERFACE=$1
            STATUS=$2
            
            if [ "$INTERFACE" = "wg0" ]; then
              # Don't do anything when WireGuard interface changes
              exit 0
            fi
            
            if [ "$STATUS" = "up" ] || [ "$STATUS" = "down" ]; then
              CURRENT_SSID=$(${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
              
              # Check if connected to a trusted SSID
              for SSID in $TRUSTED_SSIDS; do
                if [ "$CURRENT_SSID" = "$SSID" ]; then
                  echo "Connected to trusted network $CURRENT_SSID, disabling WireGuard"
                  ${pkgs.networkmanager}/bin/nmcli connection down wg0 || true
                  exit 0
                fi
              done
              
              # Not on trusted network, enable WireGuard
              if [ "$STATUS" = "up" ]; then
                echo "Connected to untrusted network, enabling WireGuard"
                ${pkgs.networkmanager}/bin/nmcli connection up wg0 || true
              fi
            fi
          '';
          type = "basic";
        }
      ];
    };
    nameservers = [ "192.168.40.254" ];
  };

  services.resolved = {
    enable = true;
    fallbackDns = ["1.1.1.1" "9.9.9.9"];
  };

  sops.templates."wg0.conf" = {
    content = ''
      [interface]
      Address = 192.168.2.6/32
      ListenPort = 51820
      PrivateKey = ${config.sops.placeholder."wireguard/private_key"}

      [Peer]
      PublicKey = qAjEb1o20Thwf/614f22rkxHJG8qI2/NYKgXogUnoBM=
      Endpoint = ${config.sops.placeholder."wireguard/server"}:51820
      PersistentKeepalive = 25
      AllowedIPs = 192.168.2.1/32,192.168.2.6/32,0.0.0.0/0
    '';
    path = "/etc/wireguard/wg0.conf";
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = config.sops.templates."wg0.conf".path;
    };
  };
}
