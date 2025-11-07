{ config, lib, pkgs, ... }:

{
  # Home Manager sops configuration for user-level secrets
  sops = {
    # Age key for decryption - uses SSH key
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Default sops file location
    defaultSopsFile = ../../../secrets/secrets.yaml;

    # User environment variables from sops
    # FIXME: Add "user/env" key to secrets.yaml before enabling
    # secrets."user/env" = {
    #   # Path where the decrypted file will be available
    #   path = "${config.home.homeDirectory}/.config/environment.d/sops-env";
    # };
  };
}
