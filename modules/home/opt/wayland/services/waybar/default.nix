#              ╭──────────────────────────────────────────────────╮
#              │             CREDITS TO: @khaneliman              │
#              │ THIS IS A FORK OF HIS CONFIG, ALL CREDITS TO HIM │
#              ╰──────────────────────────────────────────────────╯
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkMerge;

  style = builtins.readFile ./styles/style.css;
  controlCenterStyle = builtins.readFile ./styles/control-center.css;
  powerStyle = builtins.readFile ./styles/power.css;
  statsStyle = builtins.readFile ./styles/stats.css;
  workspacesStyle = builtins.readFile ./styles/workspaces.css;

  custom-modules = import ./modules/custom-modules.nix { inherit config lib pkgs; };
  default-modules = import ./modules/default-modules.nix { inherit config lib pkgs; };
  group-modules = import ./modules/group-modules.nix;
  hyprland-modules = import ./modules/hyprland-modules.nix { inherit config lib; };

  commonAttributes = {
    layer = "top";
    position = "top";

    margin-top = 10;
    margin-left = 10;
    margin-right = 10;

    modules-left = [
      "custom/power"
      "hyprland/workspaces"
      "custom/separator-left"
      "hyprland/window"
    ];
  };

  fullSizeModules = {
    modules-right = [
      "group/tray"
      "custom/separator-right"
      "group/stats"
      "custom/separator-right"
      "group/control-center"
      "hyprland/submap"
      "custom/weather"
      "clock"
    ];
  };

  mkBarSettings = mkMerge [
    commonAttributes
    fullSizeModules
    custom-modules
    default-modules
    group-modules
    hyprland-modules
  ];

  generateOutputSettings =
    outputList:
    builtins.listToAttrs (
      builtins.map (outputName: {
        name = outputName;
        value = mkMerge [
          mkBarSettings
          { output = outputName; }
        ];
      }) outputList
    );

in
{
  config = lib.mkIf (config.default.bar == "waybar") {

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = generateOutputSettings [
        "eDP-1"
        "HDMI-A-1"
      ];
      style =
        with config.lib.stylix.colors;
        mkMerge [
          ''
            @define-color surface0  #${base01};
            @define-color surface1  #${base01};
            @define-color surface2  #${base01};
            @define-color surface3  #${base01};

            @define-color overlay0  #${base02};

            @define-color surface4  #${base00};
            @define-color theme_base_color #${base00};

            @define-color text #${base05};
            @define-color theme_text_color #${base05};

            @define-color red    #${base08};
            @define-color orange #${base09};
            @define-color peach #${base09};
            @define-color yellow #${base0A};
            @define-color green  #${base0B};
            @define-color purple #${base0E};
            @define-color blue   #${base0D};
            @define-color lavender #${base0E};
            @define-color teal #${base0C};
          ''
          "${style}${controlCenterStyle}${powerStyle}${statsStyle}${workspacesStyle}"
        ];
    };
    sops.secrets = {
      weather_config = {
        path = "${config.home.homeDirectory}/weather_config.json";
      };
    };
  };
}
