{ pkgs, inputs, ... }: {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.cache.disk.enable" = true;
          "browser.newtabpage.pinned" = [{
            title = "Home Assistant";
            url = "http://192.168.40.200:8123";
          }];
          "browser.ctrlTab.sortByRecentlyUsed" = true;
        };
        search = {
          force = true;
          default = "searchxng";
          order = [ "searchxng" "ecosia" "ddg" ];
          engines = {
            "searchxng" = {
              template = "https://search.patout.xyz/search";
              icon = "https://search.patout.xyz/favicon.ico";
              definedAliases = [ "@s" ];
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            };
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "ecosia" = {
              urls = [{
                template = "https://www.ecosia.org/search?q={searchTerms}";
              }];
              icon = "https://www.ecosia.org/static/icons/favicon.ico";
              definedAliases = [ "@eco" ];
            };
            "bing".metaData.hidden = true;
            "ddg".metaData.alias =
              "@d"; # builtin engines only support specifying one additional alias
          };
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          aria2-integration
          buster-captcha-solver
          clearurls
          container-tabs-sidebar
          decentraleyes
          libredirect
          no-pdf-download
          react-devtools
          reduxdevtools
          #tridactyl
          ublock-origin
          omnivore
          darkreader
          languagetool
          tabcenter-reborn
          onepassword-password-manager
          ecosia
          fediact
          raindropio
        ];

        userChrome = builtins.readFile ./userChrome.css;
      };
    };
  };
}
