# Tailscale client configuration for headscale server
{
  pkgs,
  config,
  ...
}:
{
  services.tailscale = {
    enable = true;
    package = pkgs.tailscale;
    useRoutingFeatures = "client";
    extraUpFlags = [
      "--login-server=${config.sops.placeholder."tailscale/headscale_url"}"
      "--accept-routes"
      "--accept-dns"
    ];
  };

  # Open firewall for Tailscale
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Ensure tailscale service starts after network
  systemd.services.tailscaled = {
    wants = [ "network-pre.target" ];
    after = [ "network-pre.target" ];
  };

  # SOPS secrets for headscale configuration
  sops.secrets = {
    "tailscale/headscale_url" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
    "tailscale/auth_key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };

  # Optional: Auto-connect script using auth key
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale/Headscale";
    after = [
      "network-online.target"
      "tailscaled.service"
    ];
    wants = [
      "network-online.target"
      "tailscaled.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Check if already connected
      if ${pkgs.tailscale}/bin/tailscale status --json | ${pkgs.jq}/bin/jq -e '.BackendState == "Running"' > /dev/null; then
        echo "Tailscale already connected"
        exit 0
      fi

      # Connect using auth key if available
      if [ -f "${config.sops.secrets."tailscale/auth_key".path}" ]; then
        AUTH_KEY=$(cat "${config.sops.secrets."tailscale/auth_key".path}")
        HEADSCALE_URL=$(cat "${config.sops.secrets."tailscale/headscale_url".path}")
        
        echo "Connecting to headscale server..."
        ${pkgs.tailscale}/bin/tailscale up \
          --login-server="$HEADSCALE_URL" \
          --authkey="$AUTH_KEY" \
          --accept-routes \
          --accept-dns
      else
        echo "No auth key found, manual connection required"
        echo "Run: tailscale up --login-server=<your-headscale-url>"
      fi
    '';
  };
}

