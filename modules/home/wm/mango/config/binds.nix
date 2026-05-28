{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;

  # Generate workspace bindings (tags in MangoWM terminology)
  # Binds $mod + {1..10} to view tag {1..10}
  # Binds $mod + shift + {1..10} to move window to tag {1..10}
  workspaceTags = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "SUPER,${ws},view,${toString (x + 1)}"
        "SUPER+SHIFT,${ws},tag,${toString (x + 1)}"
      ]
    ) 10
  );

  zellij-attach = pkgs.writeShellScriptBin "zellij-attach" ''
    #! /bin/sh

    session=$(zellij ls -sn | rofi -dmenu -theme ~/.config/rofi/config.rasi -p "zellij session:" )

    if [[ -z $session ]]; then
      exit
    fi

    ${terminal} -e zellij attach --create $session
  '';

  # Get default application
  terminal = config.home.sessionVariables.TERMINAL;
in
{
  wayland.windowManager.mango = {
    settings = {
      # Convert Hyprland bindings to MangoWM format
      # NOTE: MangoWM uses + to combine modifiers, not concatenation
      bind = [
        # Compositor commands
        "CTRL+SHIFT,Q,quit" # Exit compositor
        "SUPER,Q,killclient" # Close window
        "SUPER,F,togglefullscreen" # Fullscreen
        # "SUPER,P,pseudo"                     # No pseudo in MangoWM
        "SUPER+SHIFT,P,toggleglobal" # Pin window (toggleglobal in MangoWM)
        "SUPER,space,togglefloating" # Toggle floating

        # Toggle gaps
        "SUPER,M,togglegaps" # Toggle gaps

        # Cycle through windows (translated to MangoWM)
        "ALT,Tab,focusstack,next"
        "ALT+SHIFT,Tab,focusstack,prev"

        # Move focus (translated to MangoWM direction system)
        "SUPER,left,focusdir,left"
        "SUPER,right,focusdir,right"
        "SUPER,up,focusdir,up"
        "SUPER,down,focusdir,down"

        # Move windows (translated to MangoWM exchange_client)
        "SUPER+SHIFT,left,exchange_client,left"
        "SUPER+SHIFT,right,exchange_client,right"
        "SUPER+SHIFT,up,exchange_client,up"
        "SUPER+SHIFT,down,exchange_client,down"

        # Special workspaces -> scratchpad in MangoWM
        "SUPER+SHIFT,grave,minimized" # Minimize to scratchpad
        "SUPER,grave,toggle_scratchpad" # Toggle scratchpad

        # Cycle through tags (translated to viewtoleft/viewtoright)
        "SUPER+ALT,up,viewtoleft"
        "SUPER+ALT,down,viewtoright"

        # Utilities
        "SUPER,Return,spawn,run-as-service ${terminal}"
        "SUPER+SHIFT,Z,spawn,${getExe zellij-attach}"
        "SUPER,O,spawn,run-as-service wl-ocr"

        # Screenshot - using hyprquickframe (you may want to change this)
        "SUPER+SHIFT,S,spawn,hyprquickframe"

        # Launchers (using spawn instead of exec)
        "SUPER,D,spawn,vicinae open"
        "SUPER+SHIFT,p,spawn,rofi-rbw --no-help --clipboarder wl-copy --keybindings Alt+x:type:password"
        "SUPER+SHIFT,e,spawn,bemoji -t"
        "SUPER+SHIFT,o,spawn,wezterm start --class clipse clipse"

        # Media keys and brightness (always active, no modifier needed)
        "NONE,XF86AudioRaiseVolume,spawn,${pkgs.pamixer}/bin/pamixer -i 5"
        "NONE,XF86AudioLowerVolume,spawn,${pkgs.pamixer}/bin/pamixer -d 5"
        "NONE,XF86MonBrightnessUp,spawn,${pkgs.brillo}/bin/brillo -q -A 10"
        "NONE,XF86MonBrightnessDown,spawn,${pkgs.brillo}/bin/brillo -q -U 10"
        "NONE,XF86AudioMute,spawn,volumectl toggle-mute"
        "NONE,XF86AudioMicMute,spawn,${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute"
      ]
      ++ workspaceTags;
    };

    # MangoWM uses config file format, we'll use extraConfig for resize mode
    extraConfig = ''
      # Resize mode (keymode in MangoWM)
      keymode=resize
      bind=NONE,right,resizewin,+10,0
      bind=NONE,left,resizewin,-10,0
      bind=NONE,up,resizewin,0,-10
      bind=NONE,down,resizewin,0,+10
      bind=NONE,escape,setkeymode,default

      # Back to default mode
      keymode=default
    '';
  };
}
