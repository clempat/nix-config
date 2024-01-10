{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.firefox;
in
{
  options = {
    mymodule.firefox.enable = lib.mkEnableOption "Enable Firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        SearchBar = "unified";

        Preferences = {
          # Privacy settings
          "extensions.pocket.enabled" = "lock-false";
          "browser.newtabpage.pinned" = "lock-empty-string";
          "browser.topsites.contile.enabled" = "lock-false";
          "browser.newtabpage.activity-stream.showSponsored" = "lock-false";
          "browser.newtabpage.activity-stream.system.showSponsored" = "lock-false";
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = "lock-false";
        };
      };
    };
  };
}
