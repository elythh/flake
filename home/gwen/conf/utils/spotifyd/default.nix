{ pkgs, ... }:
{
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "gf0vx1cwk1wxno7ejzrurur1g";
        password_cmd = "pass spotify";
        use_mpris = true;
        dbus_type = "session";
        device_name = "spotifyd";
      };
    };
  };
}
  
