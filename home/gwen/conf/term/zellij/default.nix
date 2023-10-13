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
                format_left  "{mode} #[fg=#89B4FA,bold]{session} {tabs}"
                format_right "{datetime}"
                format_space ""
    
                hide_frame_for_single_pane "true"
    
                mode_normal  "#[bg=blue] "
                mode_tmux    "#[bg=#ffc387] "
    
                tab_normal   "#[fg=#6C7086] {name} "
                tab_active   "#[fg=#9399B2,bold,italic] {name} "
    
                datetime        "#[fg=#6C7086,bold] {format} "
                datetime_format "%A, %d %b %Y %H:%M"
                datetime_timezone "Europe/Berlin"
            }
        }
    }
  '';
}

