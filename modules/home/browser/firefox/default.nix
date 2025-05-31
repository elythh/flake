{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    concatStringsSep
    escapeShellArg
    mapAttrsToList
    ;

  cfg = config.meadow.browser.firefox;

  env = {
    MOZ_WEBRENDER = 1;
    # For a better scrolling implementation and touch support.
    # Be sure to also disable "Use smooth scrolling" in about:preferences
    MOZ_USE_XINPUT2 = 1;
  };
  envStr = concatStringsSep " " (mapAttrsToList (n: v: "${n}=${escapeShellArg v}") env);

  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "128.0";
    hash = "sha256-Xbe9gHO8Kf9C+QnWhZr21kl42rXUQzqSDIn99thO1kE=";
  };
in
{
  options.meadow.browser.firefox = {
    enable = mkEnableOption "Wether to enable Firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.overrideAttrs (old: {
        buildCommand =
          old.buildCommand
          + ''
            substituteInPlace $out/bin/firefox \
              --replace "exec -a" ${escapeShellArg envStr}" exec -a"
          '';
      });

      profiles.default = {
        id = 0;
        isDefault = true;

        extraConfig = builtins.concatStringsSep "\n" [
          (builtins.readFile "${betterfox}/Securefox.js")
          (builtins.readFile "${betterfox}/Fastfox.js")
          (builtins.readFile "${betterfox}/Peskyfox.js")
        ];

        settings = {
          "browser.tabs.loadInBackground" = true;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
          "gnomeTheme.hideSingleTab" = true;
          "gnomeTheme.bookmarksToolbarUnderTabs" = true;
          "gnomeTheme.normalWidthTabs" = false;
          "gnomeTheme.tabsAsHeaderbar" = false;
          "browser.fullscreen.autohide" = false;
          # General
          "intl.accept_languages" = "en-US,en";
          "browser.startup.page" = 3; # Resume previous session on startup
          "browser.aboutConfig.showWarning" = false; # I sometimes know what I'm doing
          "browser.ctrlTab.sortByRecentlyUsed" = false; # (default) Who wants that?
          "browser.download.useDownloadDir" = false; # Ask where to save stuff
          "browser.translations.neverTranslateLanguages" = "de"; # No need :)
          "privacy.clearOnShutdown.history" = false; # We want to save history on exit
          # Allow executing JS in the dev console
          "devtools.chrome.enabled" = true;
          # Disable browser crash reporting
          "browser.tabs.crashReporting.sendReport" = false;
          # Allow userCrome.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # https://github.com/yiiyahui/Neptune-Firefox
          "svg.context-properties.content.enabled" = false;
          "browser.newtabpage.activity-stream.newtabWallpapers.enabled" = false;
          "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = false;
          "widget.non-native-theme.scrollbar.style" = 0;
          # Why the fuck can my search window make bell sounds
          "accessibility.typeaheadfind.enablesound" = false;
          # Why the fuck can my search window make bell sounds
          "general.autoScroll" = true;

          # Hardware acceleration
          # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "widget.dmabuf.force-enabled" = true;
          "media.av1.enabled" = false; # XXX: change once I've upgraded my GPU
          # XXX: what is this?
          "media.ffvpx.enabled" = false;
          "media.rdd-vpx.enabled" = false;

          # Privacy
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "browser.send_pings" = false; # (default) Don't respect <a ping=...>

          # This allows firefox devs changing options for a small amount of users to test out stuff.
          # Not with me please ...
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;

          "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
          "device.sensors.enabled" = false; # This isn't a phone
          "geo.enabled" = false; # Disable geolocation alltogether

          # ESNI is deprecated ECH is recommended
          "network.dns.echconfig.enabled" = true;

          # Disable telemetry for privacy reasons
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.enabled" = false; # enforced by nixos
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;
          "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.eventTelemetry.enabled" = false; # (default)

          # Disable some useless stuff
          "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
          "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
          "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
          "identity.fxaccounts.enabled" = false; # disable firefox login
          "identity.fxaccounts.toolbar.enabled" = false;
          "identity.fxaccounts.pairing.enabled" = false;
          "identity.fxaccounts.commands.enabled" = false;
          "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
          "browser.uitour.enabled" = false; # no tutorial please
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # disable EME encrypted media extension (Providers can get DRM
          # through this if they include a decryption black-box program)
          "browser.eme.ui.enabled" = false;
          "media.eme.enabled" = false;

          # don't predict network requests
          "network.predictor.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;

          # disable annoying web features
          "dom.push.enabled" = false; # no notifications, really...
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false; # you don't need to see my battery...

          "signon.autofillForms" = false;
          "signon.firefoxRelay.feature" = "disabled";
          "signon.generation.enabled" = false;
          "signon.management.page.breach-alerts.enabled" = false;
        };
        search = {
          force = true;
          default = "google";
          order = [
            "google"
            "duckduckgo"
            "youtube"
            "nixos options"
            "nix packages"
            "github"
            "hackernews"
            "homemanager"
            "nixvim"
          ];

          engines = {
            "bing".metaData.hidden = true;
            "amazon.com".metaData.hidden = true;

            "nixvim" = {
              icon = "https://github.com/nix-community/nixvim/raw/main/assets/nixvim_logo.svg";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@v" ];
              urls = [
                {
                  template = "https://nix-community.github.io/nixvim";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "youtube" = {
              icon = "https://youtube.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@yt" ];
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "nix packages" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
              urls = [
                {
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
                }
              ];
            };

            "nixos options" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "github" = {
              icon = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@gh" ];

              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "homemanager" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];

              url = [
                {
                  template = "https://mipmip.github.io/home-manager-option-search/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "hackernews" = {
              icon = "https://hn.algolia.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@hn" ];

              url = [
                {
                  template = "https://hn.algolia.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
      profiles.work = {
        id = 1;
        isDefault = false;

        extraConfig = builtins.concatStringsSep "\n" [
          (builtins.readFile "${betterfox}/Securefox.js")
          (builtins.readFile "${betterfox}/Fastfox.js")
          (builtins.readFile "${betterfox}/Peskyfox.js")
        ];

        settings = {
          # General
          "intl.accept_languages" = "en-US,en";
          "browser.startup.page" = 3; # Resume previous session on startup
          "browser.aboutConfig.showWarning" = false; # I sometimes know what I'm doing
          "browser.ctrlTab.sortByRecentlyUsed" = false; # (default) Who wants that?
          "browser.download.useDownloadDir" = false; # Ask where to save stuff
          "browser.translations.neverTranslateLanguages" = "de"; # No need :)
          "privacy.clearOnShutdown.history" = false; # We want to save history on exit
          # Allow executing JS in the dev console
          "devtools.chrome.enabled" = true;
          # Disable browser crash reporting
          "browser.tabs.crashReporting.sendReport" = false;
          # Allow userCrome.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # https://github.com/yiiyahui/Neptune-Firefox
          "svg.context-properties.content.enabled" = false;
          "browser.newtabpage.activity-stream.newtabWallpapers.enabled" = false;
          "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = false;
          "widget.non-native-theme.scrollbar.style" = 0;
          # Why the fuck can my search window make bell sounds
          "accessibility.typeaheadfind.enablesound" = false;
          # Why the fuck can my search window make bell sounds
          "general.autoScroll" = true;

          # Hardware acceleration
          # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "widget.dmabuf.force-enabled" = true;
          "media.av1.enabled" = false; # XXX: change once I've upgraded my GPU
          # XXX: what is this?
          "media.ffvpx.enabled" = false;
          "media.rdd-vpx.enabled" = false;

          # Privacy
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "browser.send_pings" = false; # (default) Don't respect <a ping=...>

          # This allows firefox devs changing options for a small amount of users to test out stuff.
          # Not with me please ...
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;

          "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
          "device.sensors.enabled" = false; # This isn't a phone
          "geo.enabled" = false; # Disable geolocation alltogether

          # ESNI is deprecated ECH is recommended
          "network.dns.echconfig.enabled" = true;

          # Disable telemetry for privacy reasons
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.enabled" = false; # enforced by nixos
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;
          "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.eventTelemetry.enabled" = false; # (default)

          # Disable some useless stuff
          "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
          "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
          "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
          "identity.fxaccounts.enabled" = false; # disable firefox login
          "identity.fxaccounts.toolbar.enabled" = false;
          "identity.fxaccounts.pairing.enabled" = false;
          "identity.fxaccounts.commands.enabled" = false;
          "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
          "browser.uitour.enabled" = false; # no tutorial please
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # disable EME encrypted media extension (Providers can get DRM
          # through this if they include a decryption black-box program)
          "browser.eme.ui.enabled" = false;
          "media.eme.enabled" = false;

          # don't predict network requests
          "network.predictor.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;

          # disable annoying web features
          "dom.push.enabled" = false; # no notifications, really...
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false; # you don't need to see my battery...

          "network.proxy.socks" = "127.0.0.1";
          "network.proxy.socks_port" = 3128;
          "network.proxy.type" = 1;
        };
      };
    };
  };
}
