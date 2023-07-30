{ colors, ... }:

with colors; {
  programs.zellij = {
    enable = true;
    settings.themes.default = import ./colors.nix {
      inherit colors;
    };
  };
}

