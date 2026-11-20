{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  # Steam has no global launch options, so wrap Proton-GE in a compat tool that
  # starts every game inside a 4K gamescope. Select it once in
  # Settings > Compatibility as the default tool.
  # Per game: NO_GAMESCOPE=1 %command% to skip it, GAMESCOPE_ARGS="..." to override flags.
  gamescope-proton =
    pkgs.runCommand "gamescope-proton"
      {
        outputs = [
          "out"
          "steamcompattool"
        ];
      }
      ''
        mkdir -p $out $steamcompattool

        cat > $steamcompattool/compatibilitytool.vdf <<'EOF'
        "compatibilitytools"
        {
          "compat_tools"
          {
            "Gamescope-Proton-GE"
            {
              "install_path" "."
              "display_name" "Gamescope 4K (Proton-GE)"
              "from_oslist" "windows"
              "to_oslist" "linux"
            }
          }
        }
        EOF

        cat > $steamcompattool/toolmanifest.vdf <<'EOF'
        "manifest"
        {
          "version" "2"
          "commandline" "/gamescope-proton %verb%"
        }
        EOF

        cat > $steamcompattool/gamescope-proton <<'EOF'
        #!/bin/sh
        proton=${pkgs.proton-ge-bin.steamcompattool}/proton
        verb="$1"
        case "$verb" in
          run | waitforexitandrun)
            if [ -z "$NO_GAMESCOPE" ]; then
              exec gamescope ''${GAMESCOPE_ARGS:--W 3840 -H 2160 -w 3840 -h 2160 -r 240 -f} -- "$proton" "$@"
            fi
            ;;
        esac
        exec "$proton" "$@"
        EOF
        chmod +x $steamcompattool/gamescope-proton
      '';
in
{
  options.meadow.programs.steam = {
    enable = mkEnableOption "steam";
  };
  config = mkIf config.meadow.programs.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.millennium-steam;
      protontricks.enable = true;
      # extraPackages = [ pkgs.mangohud ]; # so the MangoHud Vulkan layer is visible inside Steam's FHS env
      extraCompatPackages = [
        pkgs.proton-ge-bin
        gamescope-proton
      ];
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    # run games at native res under fractional scaling (XWayland only sees the scaled size)
    programs.gamescope.enable = true;
  };
}
