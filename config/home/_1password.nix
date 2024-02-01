{pkgs, lib, ...}:

{
  systemd.user.sessionVariables.SSH_AUTH_SOCK = "~/.1password/agent.sock";
  programs.zsh.sessionVariables.SSH_AUTH_SOCK = "~/.1password/agent.sock";

  programs.ssh = {
    forwardAgent = true;
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.git.extraConfig.gpg = {
    format = "ssh";
    "ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
  };

  programs.git.signing = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOR4x6DZqrgy8cuxcU/2Zvjx8664hrAK+MgChuuKvbYJ";
    signByDefault = lib.mkForce true;
  }; 
}
