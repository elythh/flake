{ colors, ... }:

with colors; {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      themes.default = import ./colors.nix { inherit colors; };
      default_layout = "compact";
      mouse_mode = false;
      simplified_ui = true;
      scrollback_editor = "/home/gwen/.nix-profile/bin/nvim";
      pane_frames = false;
      on_force_close = "quit";
      keybinds = {
          unbind = [ "Ctrl b" "Ctrl h" ];
        };
    };
  };
}

