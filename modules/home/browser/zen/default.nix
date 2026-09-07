{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.meadow.browser.zen;

  inherit (lib) mkIf mkEnableOption getExe;

  profileName = "default";
  modId = "gitlab-mr-title-strip";

  # Zen's native "Copy current URL as Markdown" shortcut (Ctrl+Alt+Shift+C) just
  # does `[${gBrowser.selectedTab.label}](${url})` with the raw tab title - no
  # cleanup hook exists. GitLab MR/issue tab titles look like:
  #   "hotfix(dns/prodbase): prod3 instead of priv3 (!18919) · Merge requests · struktur / kubernetes · GitLab"
  # This trims everything after the "(!12345)" part before the copy happens.
  gitlabMrTitleScript = ''
    (function () {
      function patch() {
        if (!window.gZenCommonActions) {
          setTimeout(patch, 500);
          return;
        }
        const orig = gZenCommonActions.copyCurrentURLAsMarkdownToClipboard.bind(gZenCommonActions);
        gZenCommonActions.copyCurrentURLAsMarkdownToClipboard = function () {
          const tab = gBrowser.selectedTab;
          const url = gBrowser.selectedBrowser.currentURI.spec;
          if (/-\/merge_requests\/\d+/.test(url)) {
            const original = tab.label;
            const trimmed = original.replace(/\s*·.*$/, "");
            if (trimmed !== original) {
              Object.defineProperty(tab, "label", { value: trimmed, configurable: true });
              orig();
              Object.defineProperty(tab, "label", { value: original, configurable: true });
              return;
            }
          }
          orig();
        };
      }
      patch();
    })();
  '';

  # Sine mod manifest format, reverse-engineered from a real store mod
  # (sineorg/store RenderJS): a theme.json declaring `scripts`, mapping
  # script filenames to the chrome:// pages they're injected into.
  gitlabMrThemeJson = builtins.toJSON {
    id = modId;
    author = "elyth";
    name = "GitLab MR title strip";
    description = "Trims the GitLab breadcrumb suffix when copying an MR/issue URL as Markdown.";
    scripts."gitlab-mr-title.uc.mjs".include = [ "chrome://browser/content/browser.xhtml" ];
    version = "1.0";
    fork = [ "zen" ];
  };

  # Sine only executes scripts from mods it has both marked `enabled` in
  # mods.json *and* that are either store-origin or covered by the
  # `sine.allow-unsafe-js` pref (see CosmoCreeper/Sine src/core/utils.sys.mjs
  # Utils.allowUnsafeJS / Utils.getMods). This is the entry Sine's own
  # activation script would normally write after fetching a mod from the
  # store - we write it ourselves since this mod only exists locally.
  modEntry = builtins.toJSON {
    id = modId;
    name = "GitLab MR title strip";
    description = "Trims GitLab MR/issue titles when copying URL as Markdown.";
    enabled = true;
    "no-updates" = true;
    origin = "local";
    style = {
      chrome = "";
      content = "";
    };
    scripts."gitlab-mr-title.uc.mjs".include = [ "chrome://browser/content/browser.xhtml" ];
  };

in
{
  options.meadow.browser.zen = {
    enable = mkEnableOption "Wether to enable zen";
  };

  imports = [ inputs.zen-browser.homeModules.beta ];
  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      profiles.${profileName}.sine.enable = true;
    };

    # Zen doesn't actually read the profile this flake manages
    # (~/.config/zen/${profileName}) - it keeps using whatever pre-existing
    # legacy `~/.zen/<hash>.<name>` profile is marked Default=1 in
    # ~/.zen/profiles.ini. So the mod files, the mods.json entry, and the
    # `sine.allow-unsafe-js` pref all have to be written into *that* real
    # profile instead, resolved at activation time rather than declared by
    # path, since its directory name is random per-install.
    home.activation.zenGitlabMrTitleStrip = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ZEN_LEGACY_DIR="$HOME/.zen"
      INI="$ZEN_LEGACY_DIR/profiles.ini"
      if [ -f "$INI" ]; then
        PROFILE_REL=$(${getExe pkgs.python3} -c '
      import configparser, sys
      c = configparser.ConfigParser()
      c.read(sys.argv[1])
      target = None
      for s in c.sections():
          if s.startswith("Profile"):
              if target is None:
                  target = c[s].get("Path")
              if c[s].get("Default") == "1":
                  target = c[s].get("Path")
                  break
      print(target or "")
      ' "$INI")

        if [ -n "$PROFILE_REL" ]; then
          PROFILE_DIR="$ZEN_LEGACY_DIR/$PROFILE_REL"
          MOD_DIR="$PROFILE_DIR/chrome/sine-mods/${modId}"
          $VERBOSE_ECHO "zen-gitlab-mr-title: installing into legacy profile '$PROFILE_REL'"

          mkdir -p "$MOD_DIR"
          cat > "$MOD_DIR/theme.json" <<'THEMEJSON'
      ${gitlabMrThemeJson}
      THEMEJSON
          cat > "$MOD_DIR/gitlab-mr-title.uc.mjs" <<'MODSCRIPT'
      ${gitlabMrTitleScript}
      MODSCRIPT

          MODS_FILE="$PROFILE_DIR/chrome/sine-mods/mods.json"
          if [ ! -f "$MODS_FILE" ]; then
            echo '{}' > "$MODS_FILE"
          fi
          ${getExe pkgs.jq} --argjson entry '${modEntry}' '.["${modId}"] = $entry' "$MODS_FILE" > "$MODS_FILE.tmp" && mv "$MODS_FILE.tmp" "$MODS_FILE"

          USER_JS="$PROFILE_DIR/user.js"
          touch "$USER_JS"
          if ! grep -q '"sine.allow-unsafe-js"' "$USER_JS"; then
            echo 'user_pref("sine.allow-unsafe-js", true);' >> "$USER_JS"
          fi
        else
          echo "zen-gitlab-mr-title: could not determine default profile from $INI" >&2
        fi
      fi
    '';
  };
}
