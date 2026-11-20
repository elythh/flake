{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.meadow.services = {
    openrazer.enable = mkEnableOption "openrazer";
  };
  config = mkIf config.meadow.services.openrazer.enable {
    # kernel driver + daemon, users need the openrazer group to talk to the daemon
    hardware.openrazer = {
      enable = true;
      users = [ "gwen" ];
    };
    # GUI for lighting, DPI and polling rate
    environment.systemPackages = [ pkgs.polychromatic ];
    # The Naga's onboard profile sends numpad keys on the side buttons and openrazer can't change it,
    # map them back to the number row (receiver 1532:00b4 only)
    services.udev.extraHwdb = ''
      evdev:input:b0003v1532p00B4*
       KEYBOARD_KEY_70059=1
       KEYBOARD_KEY_7005a=2
       KEYBOARD_KEY_7005b=3
       KEYBOARD_KEY_7005c=4
       KEYBOARD_KEY_7005d=5
       KEYBOARD_KEY_7005e=6
       KEYBOARD_KEY_7005f=7
       KEYBOARD_KEY_70060=8
       KEYBOARD_KEY_70061=9
       KEYBOARD_KEY_70062=0
       KEYBOARD_KEY_70056=minus
       KEYBOARD_KEY_70057=equal
    '';
  };
}
