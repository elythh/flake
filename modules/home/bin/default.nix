{ config, ... }:
{
  home = {
    file = {
      ".local/bin/captureCode" = {
        executable = true;
        text = import ./screenshot/captureCode.nix { inherit config; };
      };
      ".local/bin/captureAll" = {
        executable = true;
        text = import ./screenshot/captureAll.nix { };
      };
      ".local/bin/captureArea" = {
        executable = true;
        text = import ./screenshot/captureArea.nix { inherit config; };
      };
      ".local/bin/captureWindow" = {
        executable = true;
        text = import ./screenshot/captureWindow.nix { inherit config; };
      };
      ".local/bin/captureScreen" = {
        executable = true;
        text = import ./screenshot/captureScreen.nix { };
      };
    };
  };
}
