{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule._1password;
  ssh = config.home-manager.users.${user}.programs.ssh;
  git = config.home-manager.users.${user}.programs.git;
in
{
  options = {
    mymodule._1password.enable = lib.mkEnableOption "Enable 1Password";
  };

  config = lib.mkIf cfg.enable {
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user ];
    };
    programs._1password.enable = true;


    home-manager.users.${user} = {
      systemd.user.sessionVariables.SSH_AUTH_SOCK = "~/.1password/agent.sock";
      programs.zsh.sessionVariables.SSH_AUTH_SOCK = "~/.1password/agent.sock";
      programs.ssh = lib.mkIf ssh.enable {
        forwardAgent = true;
        extraConfig = ''
          IdentitiesOnly yes
          IdentityAgent ~/.1password/agent.sock
        '';
      };

      programs.git.extraConfig.gpg = lib.mkIf git.enable {
        format = "ssh";
        "ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };

      programs.git.signing = lib.mkIf git.enable {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOR4x6DZqrgy8cuxcU/2Zvjx8664hrAK+MgChuuKvbYJ";
        signByDefault = lib.mkForce true;
      };
    };
  };
}