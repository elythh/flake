{lib, ...}: {
  options = {
    tailscale.enable = lib.mkEnableOption "Enable tailscale";
    pipewire.enable = lib.mkEnableOption "Enable pipewire";
    wayland.enable = lib.mkEnableOption "Enable wayland";
    fonts.enable = lib.mkEnableOption "Enable fonts";
    steam.enable = lib.mkEnableOption "Enable steam";
  };
}
