{ config, lib, pkgs, ... }:

{
  sops = {
    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    
    # Path to the default sops file
    defaultSopsFile = ../../../../secrets/secrets.yaml;
    
    # Secrets for WireGuard
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
    };
  };
}
