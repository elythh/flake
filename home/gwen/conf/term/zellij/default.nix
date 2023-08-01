{ colors, ... }:

with colors; {
  programs.zellij = {
    enable = true;
    settings.themes.default = import ./colors.nix {
      inherit colors;
    };
    settings.default_layout = "compact";
    settings.keybinds = {
      unbind = [ "Ctrl b" "Ctrl h" ];
    };
  };
}

