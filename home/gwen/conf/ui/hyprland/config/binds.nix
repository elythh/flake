{ lib
, config
, pkgs
, ...
}:
let
  ocrScript =
    let
      inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
      _ = lib.getExe;
    in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';

  screenshotarea = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copysave area; hyprctl keyword animation 'fadeOut,1,4,default'";

  workspaces = builtins.concatLists (builtins.genList
    (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "SUPER, ${ws}, split-workspace, ${toString (x + 1)}"
        "SUPERSHIFT, ${ws}, split-movetoworkspacesilent, ${toString (x + 1)}"
      ]
    )
    10);

  terminal = config.home.sessionVariables.TERMINAL;
  browser = config.home.sessionVariables.BROWSER;
  editor = config.home.sessionVariables.EDITOR;
in
{
  home.packages = [ ocrScript ];

  wayland.windowManager.hyprland = {
    settings = {
      bind =
        let
          monocle = "dwindle:no_gaps_when_only";
        in
        [
          "SUPERSHIFT, Q, exec, pkill Hyprland"
          "SUPER, Q, killactive,"

          "SUPER, S, togglesplit,"
          "SUPER, F, fullscreen,"
          "SUPER, M, exec, hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))"
          "SUPER, Space, togglefloating,"
          "SUPERALT, ,resizeactive,"

          "SUPER, G, togglegroup,"
          "SUPERSHIFT, N, changegroupactive, f"
          "SUPERSHIFT, P, changegroupactive, b"

          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          "SUPERSHIFT, grave, movetoworkspace, special"
          "SUPER, grave, togglespecialworkspace, eDP-1"

          "SUPER, bracketleft, workspace, m-1"
          "SUPER, bracketright, workspace, m+1"

          "SUPER, Return, exec, ${terminal}"
          "SUPER, B, exec, ${browser}"
          "SUPERSHIFT, L, exec, ${pkgs.swaylock-effects}/bin/swaylock -S --grace 2"
          "SUPER, O, exec, wl-ocr"
          "SUPER, P, exec, rofi-rbw --typer wtype --no-help"

          ", Print, exec, ${screenshotarea}"
          "CTRL, Print, exec, grimblast --notify --cursor copysave output"
          "ALT, Print, exec, grimblast --notify --cursor copysave screen"
        ]
        ++ workspaces;

      bindr = [
        "SUPER, E, exec, pkill wofi  || run-as-service $(wofi -S drun)"
      ];

      binde = [
        ",XF86AudioRaiseVolume, exec, volumectl up 5"
        ",XF86AudioLowerVolume, exec, volumectl down 5"
        ",XF86AudioMute, exec, volumectl toggle-mute"

        ",XF86MonBrightnessUp, exec, lightctl up 5"
        ",XF86MonBrightnessDown, exec, lightctl down 5"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER ALT, mouse:272, resizewindow"
      ];
    };

    extraConfig = ''
      bind = SUPERSHIFT, S, submap, resize

      submap=resize
      binde=,right,resizeactive,10 0
      binde=,left,resizeactive,-10 0
      binde=,up,resizeactive,0 -10
      binde=,down,resizeactive,0 10
      bind=,escape,submap,reset
      submap=reset
    '';
  };
}
