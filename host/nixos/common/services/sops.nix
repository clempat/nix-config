_:

{
  sops = {
    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Path to the default sops file
    defaultSopsFile = ../../../../secrets/secrets.yaml;

    # Secrets for VPN services
    secrets = {
      "wireguard/private_key" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "wireguard/server" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
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
  };
}
