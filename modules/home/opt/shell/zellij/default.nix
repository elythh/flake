{
  config,
  lib,
  ...
}:
with config.lib.stylix.colors;
  lib.mkIf config.modules.zellij.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = false;
    };
    home.shellAliases = {
      zr = "zellij run --";
      zrf = "zellij run --floating --";
      ze = "zellij edit";
      zef = "zellij edit --floating";
    };

    xdg.configFile."zellij/config.kdl".text = ''
      default_layout "layout"
      mouse_mode true
      copy_on_select true
      simplified_ui  false
      scrollback_editor "/home/gwen/.nix-profile/bin/nvim"
      pane_frames false
      on_force_close "detach"

      ui {
        pane_frames {
          rounded_corners true
        }
      }

      keybinds {
              normal {
                      bind "Alt m" {
                              LaunchPlugin "file:~/.config/zellij/plugins/monocle.wasm" {
                                      in_place true
                                      kiosk true
                              };
                              SwitchToMode "Normal"
                      }
                      bind "Ctrl f" {
                              LaunchOrFocusPlugin "file:~/.config/zellij/plugins/monocle.wasm" {
                                      floating true
                              }
                              SwitchToMode "Normal"
                      }
                    bind "Alt 1" { GoToTab 1;}
                    bind "Alt 2" { GoToTab 2;}
                    bind "Alt 3" { GoToTab 3;}
                    bind "Alt 4" { GoToTab 4;}
              }

              shared_except "locked" {
                      bind "Ctrl y" {
                              LaunchOrFocusPlugin "file:~/.config/zellij/plugins/room.wasm" {
                                      floating true
                                      ignore_case true
                              }
                      }
              }
            unbind "Ctrl b" "Ctrl h" "Ctrl g"
          }

          themes {
            default {
             bg  "#${base01}"
             fg  "#${base05}"
             black  "#${base00}"
             red  "#${base08}"
             green  "#${base0B}"
             yellow  "#${base09}"
             blue  "#${base0D}"
             magenta  "#${base0E}"
             cyan  "#${base0C}"
             white  "#${base05}"
             orange  "#${base0A}"
           }
         }
    '';
    xdg.configFile."zellij/layouts/layout.kdl".text = ''
      layout {
          pane split_direction="vertical" {
              pane
      }

       pane size=1 borderless=true {
           plugin location="file:/home/gwen/.nix-profile/bin/zjstatus.wasm" {
               format_left  "{mode} #[fg=#${base00},bold]{session}"
               format_center "{tabs}"
               format_right "{swap_layout}{datetime}"
               format_space ""

               hide_frame_for_single_pane "true"

               command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
               command_git_branch_format      "#[fg=blue] {stdout} "
               command_git_branch_interval    "10"
               command_git_branch_rendermode  "static"

               mode_normal  "#[bg=#${base08}] "
               mode_pane    "#[bg=#${base0D}] {name} "
               mode_tab     "#[bg=#${base0C}] {name} "
               mode_scroll  "#[bg=#${base0B}] {name} "
               mode_search  "#[bg=#${base0E}] {name} "
               mode_locked  "#[bg=#${base08}] {name} "

               tab_normal              "#[fg=#${base00}] {index}:{name} "
               tab_normal_fullscreen   "#[fg=#${base00}] {index}:{name} {fullscreen_indicator}"
               tab_normal_sync         "#[fg=#${base00}] {index}:{name} <> "
               tab_normal_floating     "#[fg=#${base00}] {index}:{name} {floating_indicator}"

               tab_active              "#[fg=#${base08},bold,dashed-underscore,bg=default,us=white] {name} "
               tab_active_fullscreen   "#[fg=#${base08},bold,italic] {name} {fullscreen_indicator}"
               tab_active_sync         "#[fg=#${base08},bold,italic] {name} {sync_indicator}"
               tab_active_floating     "#[fg=#${base08},bold,italic] {name} {floating_indicator}"

               datetime        "#[fg=#${base00},bold] {format} "
               datetime_format "%A, %d %b %Y %H:%M"
               datetime_timezone "Europe/Paris"

               tab_fullscreen_indicator "[] "
               tab_floating_indicator   "⬚ "
               tab_sync_indicator      "<>"
           }
       }
      }
    '';
  }
