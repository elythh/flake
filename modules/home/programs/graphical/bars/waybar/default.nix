{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkForce
    getExe
    mkMerge
    types
    ;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;
  inherit (inputs) waybar;

  cfg = config.${namespace}.programs.graphical.bars.waybar;

  style = builtins.readFile ./styles/style.css;
  controlCenterStyle = builtins.readFile ./styles/control-center.css;
  powerStyle = builtins.readFile ./styles/power.css;
  statsStyle = builtins.readFile ./styles/stats.css;
  workspacesStyle = builtins.readFile ./styles/workspaces.css;

  custom-modules = import ./modules/custom-modules.nix { inherit config lib pkgs; };
  default-modules = import ./modules/default-modules.nix { inherit lib pkgs config; };
  group-modules = import ./modules/group-modules.nix;
  hyprland-modules = import ./modules/hyprland-modules.nix { inherit config lib; };

  commonAttributes = {
    layer = "top";
    position = "top";

    margin-top = 10;
    margin-left = 20;
    margin-right = 20;

    modules-left =
      [ "custom/power" ]
      ++ lib.optionals config.${namespace}.programs.graphical.wms.hyprland.enable [
        "hyprland/workspaces"
      ]
      ++ [ "custom/separator-left" ]
      ++ lib.optionals config.${namespace}.programs.graphical.wms.hyprland.enable [ "hyprland/window" ];
  };

  fullSizeModules = {
    modules-right =
      [
        "group/tray"
        "custom/separator-right"
        "group/stats"
        "custom/separator-right"
        "group/control-center"
      ]
      ++ lib.optionals config.${namespace}.programs.graphical.wms.hyprland.enable [ "hyprland/submap" ]
      ++ [
        "custom/weather"
        "clock"
      ];
  };

  condensedModules = {
    modules-right =
      [
        "group/tray-drawer"
        "group/stats-drawer"
        "group/control-center"
      ]
      ++ lib.optionals config.${namespace}.programs.graphical.wms.hyprland.enable [ "hyprland/submap" ]
      ++ [
        "custom/weather"
        "clock"
      ];
  };

  mkBarSettings =
    barType:
    mkMerge [
      commonAttributes
      (if barType == "fullSize" then fullSizeModules else condensedModules)
      custom-modules
      default-modules
      group-modules
      hyprland-modules
    ];

  generateOutputSettings =
    outputList: barType:
    builtins.listToAttrs (
      builtins.map (outputName: {
        name = outputName;
        value = mkMerge [
          (mkBarSettings barType)
          { output = outputName; }
        ];
      }) outputList
    );
in
{
  options.${namespace}.programs.graphical.bars.waybar = {
    enable = mkBoolOpt false "Whether to enable waybar in the desktop environment.";
    debug = mkBoolOpt false "Whether to enable debug mode.";
    fullSizeOutputs =
      mkOpt (types.listOf types.str) "Which outputs to use the full size waybar on."
        [ ];
    condensedOutputs =
      mkOpt (types.listOf types.str) "Which outputs to use the smaller size waybar on."
        [ ];
  };

  config = mkIf cfg.enable {
    systemd.user.services.waybar.Service.ExecStart = mkIf cfg.debug (
      mkForce "${getExe config.programs.waybar.package} -l debug"
    );

    programs.waybar = {
      enable = true;
      package = waybar.packages.${system}.waybar;
      systemd.enable = true;

      settings = mkMerge [
        (generateOutputSettings cfg.fullSizeOutputs "fullSize")
        (generateOutputSettings cfg.condensedOutputs "condensed")
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
        sopsFile = lib.snowfall.fs.get-file "secrets/gwen/secrets.yaml";
        path = "${config.home.homeDirectory}/weather_config.json";
      };
    };
  };
}