{
  config,
  pkgs,
  ...
}: let
  # Binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (builtins.genList (x: let
      ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
    in [
      "SUPER, ${ws}, workspace, ${toString (x + 1)}"
      "SUPERSHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
    ])
    10);

  # Get default application
  gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
  terminal = config.home.sessionVariables.TERMINAL;
in {
  wayland.windowManager.hyprland = {
    settings = {
      bind = let
        monocle = "dwindle:no_gaps_when_only";
      in
        [
          # Compositor commands
          "CTRLSHIFT, Q, exit"
          "SUPER, Q, killactive"
          "SUPER, S, togglesplit"
          "SUPER, F, fullscreen"
          "SUPER, P, pseudo"
          "SUPERSHIFT, P, pin"
          "SUPER, Space, togglefloating"

          # Toggle "monocle" (no_gaps_when_only)
          "SUPER, M, exec, hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))"

          # Grouped (tabbed) windows
          "SUPER, G, togglegroup"
          "SUPER, TAB, changegroupactive, f"
          "SUPERSHIFT, TAB, changegroupactive, b"

          # Cycle through windows
          "ALT, Tab, cyclenext"
          "ALT, Tab, bringactivetotop"
          "ALTSHIFT, Tab, cyclenext, prev"
          "ALTSHIFT, Tab, bringactivetotop"

          # Move focus
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # Move windows
          "SUPERSHIFT, left, movewindow, l"
          "SUPERSHIFT, right, movewindow, r"
          "SUPERSHIFT, up, movewindow, u"
          "SUPERSHIFT, down, movewindow, d"

          # Special workspaces
          "SUPERSHIFT, grave, movetoworkspace, special"
          "SUPER, grave, togglespecialworkspace"

          # Cycle through workspaces
          "SUPERALT, up, workspace, m-1"
          "SUPERALT, down, workspace, m+1"

          # Utilities
          "SUPER, Return, exec, run-as-service ${terminal}"
          "SUPER, B, exec, firefox"
          "SUPER, L, exec, swaylock -S"
          "SUPER, O, exec, run-as-service wl-ocr"

          # Screenshot
          "SUPERSHIFT, S, exec, ~/.local/bin/captureArea"
          "CTRLSHIFT, S, exec, grimblast --notify --cursor copysave output"
        ]
        ++ workspaces;

      bindr = [
        # Launchers
        "SUPER, D, exec, pkill .anyrun-wrapped || run-as-service anyrun"
        "SUPERSHIFT, p, exec, rofi-rbw --no-help --clipboarder wl-copy"
      ];

      binde = [
        # Audio
        ",XF86AudioRaiseVolume, exec, volumectl up 5"
        ",XF86AudioLowerVolume, exec, volumectl down 5"
        ",XF86AudioMute, exec, volumectl toggle-mute"
        ",XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute"

        # Brightness
        ",XF86MonBrightnessUp, exec, lightctl up 5"
        ",XF86MonBrightnessDown, exec, lightctl down 5"
      ];

      # Mouse bindings
      bindm = ["SUPER, mouse:272, movewindow" "SUPER, mouse:273, resizewindow"];
    };

    # Configure submaps
    extraConfig = ''
      bind = SUPERSHIFT, S, submap, resize

      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , escape, submap, reset
      submap = reset
    '';
  };
}
