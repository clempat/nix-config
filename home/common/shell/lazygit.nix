{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    package = pkgs.unstable.lazygit;
    settings = {
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --color-only --dark --paging=never";
            useConfig = false;
          }
        ];
      };
    };
  };
}
