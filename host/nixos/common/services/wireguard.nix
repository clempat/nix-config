# WireGuard client configuration for UniFi server
{ pkgs, config, ... }:
{
  # SOPS template for WireGuard configuration file
  sops.templates."wg0.conf" = {
    content = ''
      [Interface]
      Address = 192.168.2.11/24
      ListenPort = 51820
      DNS = 192.168.40.29
      PrivateKey = ${config.sops.placeholder."wireguard/private_key"}

      [Peer]
      PublicKey = qAjEb1o20Thwf/614f22rkxHJG8qI2/NYKgXogUnoBM=
      Endpoint = ${config.sops.placeholder."wireguard/server"}:51820
      PersistentKeepalive = 25
      AllowedIPs = 192.168.2.0/24,192.168.10.0/24,192.168.30.0/24,192.168.40.0/24
    '';
    path = "/etc/wireguard/wg0.conf";
    owner = "root";
    group = "root";
    mode = "0600";
  };

  # Use wg-quick with the SOPS template
  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = config.sops.templates."wg0.conf".path;
      autostart = true; # Enable autostart now that it works
    };
  };

  # Firewall configuration
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    # Fix potential conflicts with Tailscale
    checkReversePath = "loose";
  };

  # Ensure WireGuard tools are available
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}

