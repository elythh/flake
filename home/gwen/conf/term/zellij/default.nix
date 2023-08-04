{ colors, ... }:

with colors; {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings.themes.default = import ./colors.nix {
      inherit colors;
    };
    settings.default_layout = "compact";
    settings.simplified_ui = true;
    settings.scrollback_editor = "/home/gwen/.nix-profile/bin/nvim";
    settings.pane_frames = false;
    settings.on_force_close = "quit";
    settings.keybinds = {
      unbind = [ "Ctrl b" "Ctrl h" ];
    };
  };
}

