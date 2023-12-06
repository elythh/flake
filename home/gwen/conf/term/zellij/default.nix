{ nix-colors, config, ... }:

with config.colorscheme.colors; {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      themes.default = import ./colors.nix { inherit config nix-colors; };
      default_layout = "layout";
      mouse_mode = true;
      copy_on_select = true;
      simplified_ui = false;
      scrollback_editor = "/home/gwen/.nix-profile/bin/nvim";
      pane_frames = false;
      on_force_close = "detach";
      keybinds = {
        unbind = [ "Ctrl b" " Ctrl h" "Ctrl g" ];
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
