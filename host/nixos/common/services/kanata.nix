{ pkgs, lib, ... }:
{
  services.kanata = {
    enable = true;
    keyboards = {
      main = {
        # Basic config to remap Caps Lock to Escape when tapped, Ctrl when held
        config = ''
          (defsrc
            caps
          )
          
          (deflayer base
            @caps-esc
          )
          
          (defalias
            caps-esc (tap-hold 200 200 esc lctl)
          )
        '';
        
        # Let kanata auto-detect keyboards (empty list = all keyboards)
        devices = [ ];
        
        # Extra configuration for the defcfg section
        extraDefCfg = ''
          process-unmapped-keys yes
        '';
      };
    };
  };
}