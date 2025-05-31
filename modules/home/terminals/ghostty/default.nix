{
  config,
  lib,
  ...
}:
lib.mkIf (config.meadow.default.terminal == "ghostty") {
  home.sessionVariables.TERMINAL = "ghostty";
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = false;
      window-padding-x = "10,10";
      window-padding-y = "10,10";
      keybind = [
        "alt+two=unbind"
        "alt+one=unbind"
        "alt+three=unbind"
        "alt+four=unbind"
      ];
    };
  };
}
