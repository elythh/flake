{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  mkLuaInline = lib.generators.mkLuaInline;
  # Binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (
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
        {
          _args = [
            "SUPER + ${ws}"
            (mkLuaInline "hl.dsp.focus({ workspace = ${toString (x + 1)} })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + ${ws}"
            (mkLuaInline "hl.dsp.window.move({ workspace = ${toString (x + 1)} })")
          ];
        }
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
  wayland.windowManager.hyprland = {
    settings = {
      bind =
        let
          monocle = "dwindle:no_gaps_when_only";
        in
        # screenshot = import ../scripts/screenshot.nix { inherit pkgs; };
        [
          # Compositor commands
          {
            _args = [
              "CTRL + SHIFT + Q"
              (mkLuaInline "hl.dsp.exit()")
            ];
          }
          {
            _args = [
              "SUPER + Q"
              (mkLuaInline "hl.dsp.window.close()")
            ];
          }
          # { _args = [ "SUPER + S" (mkLuaInline "hl.dsp.layout(\"togglesplit\")") ]; }
          {
            _args = [
              "SUPER + F"
              (mkLuaInline "hl.dsp.window.fullscreen()")
            ];
          }
          {
            _args = [
              "SUPER + P"
              (mkLuaInline "hl.dsp.window.pseudo()")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + P"
              (mkLuaInline "hl.dsp.window.pin()")
            ];
          }
          {
            _args = [
              "SUPER + space"
              (mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
            ];
          }

          # Toggle "monocle" (no_gaps_when_only)
          {
            _args = [
              "SUPER + M"
              (mkLuaInline "hl.dsp.exec_cmd(\"hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))\")")
            ];
          }

          # Grouped (tabbed) windows
          {
            _args = [
              "SUPER + G"
              (mkLuaInline "hl.dsp.group.toggle()")
            ];
          }
          {
            _args = [
              "SUPER + TAB"
              (mkLuaInline "hl.dsp.group.next()")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + TAB"
              (mkLuaInline "hl.dsp.group.prev()")
            ];
          }

          # Cycle through windows
          {
            _args = [
              "ALT + Tab"
              (mkLuaInline "hl.dsp.window.cycle_next()")
            ];
          }
          {
            _args = [
              "ALT + Tab"
              (mkLuaInline "hl.dsp.window.bring_to_top()")
            ];
          }
          {
            _args = [
              "ALT + SHIFT + Tab"
              (mkLuaInline "hl.dsp.window.cycle_next({ next = false })")
            ];
          }
          {
            _args = [
              "ALT + SHIFT + Tab"
              (mkLuaInline "hl.dsp.window.bring_to_top()")
            ];
          }

          # Move focus
          {
            _args = [
              "SUPER + left"
              (mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              "SUPER + right"
              (mkLuaInline "hl.dsp.focus({ direction = \"right\" })")
            ];
          }
          {
            _args = [
              "SUPER + up"
              (mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
            ];
          }
          {
            _args = [
              "SUPER + down"
              (mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
            ];
          }

          # Move windows
          {
            _args = [
              "SUPER + SHIFT + left"
              (mkLuaInline "hl.dsp.window.move({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + right"
              (mkLuaInline "hl.dsp.window.move({ direction = \"right\" })")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + up"
              (mkLuaInline "hl.dsp.window.move({ direction = \"up\" })")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + down"
              (mkLuaInline "hl.dsp.window.move({ direction = \"down\" })")
            ];
          }

          # Special workspaces
          {
            _args = [
              "SUPER + SHIFT + grave"
              (mkLuaInline "hl.dsp.window.move({ workspace = \"special\" })")
            ];
          }
          {
            _args = [
              "SUPER + grave"
              (mkLuaInline "hl.dsp.workspace.toggle_special(\"\")")
            ];
          }

          # Cycle through workspaces
          {
            _args = [
              "SUPER + ALT + up"
              (mkLuaInline "hl.dsp.focus({ workspace = \"m-1\" })")
            ];
          }
          {
            _args = [
              "SUPER + ALT + down"
              (mkLuaInline "hl.dsp.focus({ workspace = \"m+1\" })")
            ];
          }

          # Utilities
          {
            _args = [
              "SUPER + Return"
              (mkLuaInline "hl.dsp.exec_cmd(\"run-as-service ${terminal}\")")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + Z"
              (mkLuaInline "hl.dsp.exec_cmd(\"${getExe zellij-attach}\")")
            ];
          }
          {
            _args = [
              "SUPER + O"
              (mkLuaInline "hl.dsp.exec_cmd(\"run-as-service wl-ocr\")")
            ];
          }

          # Screenshot
          {
            _args = [
              "SUPER + SHIFT + S"
              (mkLuaInline "hl.dsp.exec_cmd(\"hyprquickframe\")")
            ];
          }
          # { _args = [ "SUPER + SHIFT + S" (mkLuaInline "hl.dsp.exec_cmd(\"${screenshot}/bin/screenshot a\")") ]; }
          # { _args = [ "SUPER + ALT + S" (mkLuaInline "hl.dsp.exec_cmd(\"${screenshot}/bin/screenshot f\")") ]; }
          # { _args = [ "print" (mkLuaInline "hl.dsp.exec_cmd(\"${screenshot}/bin/screenshot f\")") ]; }

          # Launchers (release binds)
          {
            _args = [
              "SUPER + D"
              (mkLuaInline "hl.dsp.exec_cmd(\"vicinae open\")")
              { release = true; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + p"
              (mkLuaInline "hl.dsp.exec_cmd(\"rofi-rbw --no-help --clipboarder wl-copy --keybindings Alt+x:type:password\")")
              { release = true; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + e"
              (mkLuaInline "hl.dsp.exec_cmd(\"bemoji -t\")")
              { release = true; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + o"
              (mkLuaInline "hl.dsp.exec_cmd(\"wezterm start --class clipse clipse\")")
              { release = true; }
            ];
          }

          # Media / hardware keys (repeat binds)
          {
            _args = [
              "XF86AudioRaiseVolume"
              (mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.pamixer}/bin/pamixer -i 5\")")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.pamixer}/bin/pamixer -d 5\")")
              { repeating = true; }
            ];
          }

          {
            _args = [
              "XF86MonBrightnessUp"
              (mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.brillo}/bin/brillo -q -A 10\")")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86MonBrightnessDown"
              (mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.brillo}/bin/brillo -q -U 10\")")
              { repeating = true; }
            ];
          }
          # Audio
          {
            _args = [
              "XF86AudioMute"
              (mkLuaInline "hl.dsp.exec_cmd(\"volumectl toggle-mute\")")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86AudioMicMute"
              (mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute\")")
              { repeating = true; }
            ];
          }

          # Mouse bindings
          {
            _args = [
              "SUPER + mouse:272"
              (mkLuaInline "hl.dsp.window.drag()")
              { mouse = true; }
            ];
          }
          {
            _args = [
              "SUPER + mouse:273"
              (mkLuaInline "hl.dsp.window.resize()")
              { mouse = true; }
            ];
          }
        ]
        ++ workspaces;
    };

    # Configure submaps
    submaps = {
      resize = {
        settings.bind = [
          {
            _args = [
              "right"
              (mkLuaInline "hl.dsp.window.resize({ x = 10, y = 0, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "left"
              (mkLuaInline "hl.dsp.window.resize({ x = -10, y = 0, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "up"
              (mkLuaInline "hl.dsp.window.resize({ x = 0, y = -10, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "down"
              (mkLuaInline "hl.dsp.window.resize({ x = 0, y = 10, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "escape"
              (mkLuaInline "hl.dsp.submap(\"reset\")")
            ];
          }
        ];
      };
    };
  };
}
