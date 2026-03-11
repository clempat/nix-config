{ isDarwin, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."git.patout.xyz" = {
      hostname = "git.patout.xyz";
      user = "gitea";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
    };

    matchBlocks."192.168.40.*" = {
      extraOptions =
        if isDarwin then
          {
            IdentitiesOnly = "no";
            IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
          }
        else
          {
            IdentitiesOnly = "no";
            IdentityAgent = "~/.1password/agent.sock";
          };
    };

    matchBlocks."*" = {
      identitiesOnly = true;
      extraOptions =
        if isDarwin then
          {
            IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
          }
        else
          {
            IdentityAgent = "~/.1password/agent.sock";
            Include = "~/.ssh/1Password/config";
          };
    };
  };
}
