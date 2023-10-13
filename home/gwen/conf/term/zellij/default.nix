{ colors, ... }:

with colors; {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      themes.default = import ./colors.nix { inherit colors; };
      default_layout = "layout";
      mouse_mode = true;
      copy_on_select = true;
      simplified_ui = false;
      scrollback_editor = "/home/gwen/.nix-profile/bin/nvim";
      pane_frames = false;
      on_force_close = "detach";
      keybinds = {
        unbind = [ "Ctrl b" ];
      };
    };
  };
  xdg.configFile."zellij/layouts/layout.kdl".text = '' 
        layout {
            pane split_direction="vertical" {
                pane
            }
        
            pane size=1 borderless=true {
                plugin location="file:/home/gwen/.nix-profile/bin/zjstatus.wasm" {
                    format_left  "{mode} #[fg=#${colors.comment},bold]{session} {tabs}"
                    format_right "{datetime}"
                    format_space ""
        
                    hide_frame_for_single_pane "true"
        
                    mode_normal  "#[bg=#${colors.color4}] "
                    mode_tmux    "#[bg=#${colors.color3}] "
                    mode_tab     "#[bg=#${colors.color9}] "
        
                    tab_normal              "#[fg=#${colors.comment}] {index}:{name} "
                    tab_normal_fullscreen   "#[fg=#${colors.comment}] {index}:{name} [] "
                    tab_normal_sync         "#[fg=#${colors.comment}] {index}:{name} <> "
                    
                    tab_active              "#[fg=#${colors.color4},bold,italic] {name} "
                    tab_active_fullscreen   "#[fg=#${colors.color4},bold,italic] {name} [] "
                    tab_active_sync         "#[fg=#${colors.color4},bold,italic] {name} <> "
        
                    datetime        "#[fg=#${colors.comment},bold] {format} "
                    datetime_format "%A, %d %b %Y %H:%M"
                    datetime_timezone "Europe/Berlin"
                }
            }
        }
    '';
}
