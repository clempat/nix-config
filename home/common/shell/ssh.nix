{ isDarwin, ... }:
{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig =
      if isDarwin then
        ''
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        ''
      else
        ''
          IdentityAgent ~/.1password/agent.sock
          Include ~/.ssh/1Password/config
        '';
  };
}
