{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep escapeShellArg mapAttrsToList;
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
    rev = "116.1";
    hash = "sha256-Ai8Szbrk/4FhGhS4r5gA2DqjALFRfQKo2a/TwWCIA6g=";
  };
in {
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

      # Hide tab bar because we have tree style tabs
      userChrome = with config.lib.stylix.colors; ''
        :root {
          --sfwindow: #${base00};
          --sfsecondary: #${base01};
        }

        /* Urlbar View */

        /*─────────────────────────────*/
        /* Comment this section if you */
        /* want to show the URL Bar    */
        /*─────────────────────────────*/

        /*
        .urlbarView {
          display: none !important;
        }

        */

        /*─────────────────────────────*/

        /*
        ┌─┐┌─┐┬  ┌─┐┬─┐┌─┐
        │  │ ││  │ │├┬┘└─┐
        └─┘└─┘┴─┘└─┘┴└─└─┘
        */

        /* Tabs colors  */
        #tabbrowser-tabs:not([movingtab])
          > #tabbrowser-arrowscrollbox
          > .tabbrowser-tab
          > .tab-stack
          > .tab-background[multiselected='true'],
        #tabbrowser-tabs:not([movingtab])
          > #tabbrowser-arrowscrollbox
          > .tabbrowser-tab
          > .tab-stack
          > .tab-background[selected='true'] {
          background-image: none !important;
          background-color: var(--toolbar-bgcolor) !important;
        }

        /* Inactive tabs color */
        #navigator-toolbox {
          background-color: var(--sfwindow) !important;
        }

        /* Window colors  */
        :root {
          --toolbar-bgcolor: var(--sfsecondary) !important;
          --tabs-border-color: var(--sfsecondary) !important;
          --lwt-sidebar-background-color: var(--sfwindow) !important;
          --lwt-toolbar-field-focus: var(--sfsecondary) !important;
        }

        /* Sidebar color  */
        #sidebar-box,
        .sidebar-placesTree {
          background-color: var(--sfwindow) !important;
        }
        /* Tabs elements  */

        #nav-bar:not([tabs-hidden='true']) {
          box-shadow: none;
        }

        #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
          > #tabbrowser-arrowscrollbox
          > .tabbrowser-tab[first-visible-unpinned-tab] {
          margin-inline-start: 0 !important;
        }

        :root {
          --toolbarbutton-border-radius: 0 !important;
          --tab-border-radius: 0 !important;
          --tab-block-margin: 0 !important;
        }

        .tab-background {
          border-right: 0px solid rgba(0, 0, 0, 0) !important;
          margin-left: -4px !important;
        }

        .tabbrowser-tab:is([visuallyselected='true'], [multiselected])
          > .tab-stack
          > .tab-background {
          box-shadow: none !important;
        }

        .tabbrowser-tab[last-visible-tab='true'] {
          padding-inline-end: 0 !important;
        }

        #tabs-newtab-button {
          padding-left: 0 !important;
        }

        /* Url Bar  */
        #urlbar-input-container {
          background-color: var(--sfsecondary) !important;
          border: 1px solid rgba(0, 0, 0, 0) !important;
        }

        #urlbar-container {
          margin-left: 0 !important;
        }

        #urlbar[focused='true'] > #urlbar-background {
          box-shadow: none !important;
        }

        #navigator-toolbox {
          border: none !important;
        }

        /* Bookmarks bar  */
        toolbarbutton.bookmark-item:not(.subviewbutton) {
          min-width: 1.6em;
        }

        /* Toolbar  */
        #tracking-protection-icon-container,
        #urlbar-zoom-button,
        #star-button-box,
        #pageActionButton,
        #pageActionSeparator,
        #PanelUI-button,
        .tab-secondary-label {
          display: none !important;
        }

        .urlbarView-url {
          color: #dedede !important;
        }

        /* Disable elements  */
        #context-navigation,
        #context-savepage,
        #context-pocket,
        #context-sendpagetodevice,
        #context-selectall,
        #context-viewsource,
        #context-inspect-a11y,
        #context-sendlinktodevice,
        #context-openlinkinusercontext-menu,
        #context-bookmarklink,
        #context-savelink,
        #context-savelinktopocket,
        #context-sendlinktodevice,
        #context-searchselect,
        #context-sendimage,
        #context-print-selection {
          display: none !important;
        }

        #context_bookmarkTab,
        #context_moveTabOptions,
        #context_sendTabToDevice,
        #context_reopenInContainer,
        #context_selectAllTabs,
        #context_closeTabOptions {
          display: none !important;
        }
      '';

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
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        re-enable-right-click
        don-t-fuck-with-paste

        enhancer-for-youtube
        sponsorblock
        return-youtube-dislikes

        enhanced-github
        refined-github
        github-file-icons
        reddit-enhancement-suite
      ];

      search = {
        force = true;
        default = "Google";
        order = ["Kagi" "Google" "DuckDuckGo" "Youtube" "NixOS Options" "Nix Packages" "GitHub" "HackerNews"];

        engines = {
          "Bing".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;

          "Kagi" = {
            iconUpdateURL = "https://kagi.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@k"];
            urls = [
              {
                template = "https://kagi.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          "YouTube" = {
            iconUpdateURL = "https://youtube.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@yt"];
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

          "Nix Packages" = {
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
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

          "NixOS Options" = {
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
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

          "GitHub" = {
            iconUpdateURL = "https://github.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@gh"];

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

          "Home Manager" = {
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@hm"];

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

          "HackerNews" = {
            iconUpdateURL = "https://hn.algolia.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@hn"];

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
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
