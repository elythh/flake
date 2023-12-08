{ nix-colors, config, ... }:

with config.colorscheme.colors; {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };
  xdg.configFile."zellij/config.kdl".text = ''
       default_layout "layout"
mouse_mode true
copy_on_select true
simplified_ui  false
scrollback_editor "/home/gwen/.nix-profile/bin/nvim"
pane_frames false
on_force_close "detach"

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
        }

        shared_except "locked" {
                bind "Ctrl y" {
                        LaunchOrFocusPlugin "file:~/.config/zellij/plugins/room.wasm" {
                                floating true
                                ignore_case true
                        }
                }
        }
      unbind "Ctrl h" "Ctrl b" "Ctrl g"
    }

    themes {
      default {
       bg  "#${background}"
       fg  "#${foreground}"
       black  "#${background}"
       red  "#${color9}"
       green  "#${color4}"
       yellow  "#${color3}"
       blue  "#${color4}"
       magenta  "#${color5}"
       cyan  "#${color6}"
       white  "#${color7}"
       orange  "#${color11}"
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
                    format_left  "{mode} #[fg=#${comment},bold]{session} {tabs}"
                    format_right "{datetime}"
                    format_space ""
        
                    hide_frame_for_single_pane "true"
        
                    mode_normal  "#[bg=#${color4}] "
                    mode_tab     "#[bg=#${color2}] {name} "
                    mode_locked  "#[bg=#${color9}] {name} "
        
                    tab_normal              "#[fg=#${comment}] {index}:{name} "
                    tab_normal_fullscreen   "#[fg=#${comment}] {index}:{name} [] "
                    tab_normal_sync         "#[fg=#${comment}] {index}:{name} <> "
                    
                    tab_active              "#[fg=#${color4},bold,italic] {name} "
                    tab_active_fullscreen   "#[fg=#${color4},bold,italic] {name} [] "
                    tab_active_sync         "#[fg=#${color4},bold,italic] {name} <> "
        
                    datetime        "#[fg=#${comment},bold] {format} "
                    datetime_format "%A, %d %b %Y %H:%M"
                    datetime_timezone "Europe/Paris"
                }
            }
        }
    '';
}
