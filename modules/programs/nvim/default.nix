{ pkgs,... }:

{
   home.file.".config/nvim" = {
     recursive = true;
    source = builtins.fetchGit {
      url = https://github.com/clempat/NvChad.git;
      ref = "main";
      rev = "a99b87ee32af8935f4d8839888ef9bb09a15a9bf";
      submodules = true;
    };
  };
}
