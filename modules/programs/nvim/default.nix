{ pkgs,... }:

{
   home.file.".config/nvim" = {
     recursive = true;
    source = builtins.fetchGit {
      url = https://github.com/clempat/NvChad.git;
      ref = "main";
      rev = "217b1316d17071fc1683882baf96ea2db51bd82b";
      submodules = true;
    };
  };
}
