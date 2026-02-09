{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.services.kanshi;
in
{
  options.meadow.services.kanshi.enable = mkEnableOption "kanshi";

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ kanshi ];
    };
    services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        {
          profile.name = "gaming";
          profile.outputs = [
            {
              criteria = "Dell Inc. AW3225QF F1X4YZ3";
              mode = "3840x2160@240";
              scale = 1.6;
            }
            {
              criteria = "DP-2";
              mode = "2560x1440@240";
            }
          ];
        }
        {
          profile.name = "home";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "Dell Inc. AW3225QF F1X4YZ3";
              mode = "3840x2160@120";
              scale = 1.6;
            }
          ];
        }
        {
          profile.name = "work_up";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "BNQ BenQ BL2480 JBL0008901Q";
              mode = "1920x1080@60";
              position = "1920,0";
            }
            {
              criteria = "BNQ BenQ BL2480 RAL0223001Q";
              mode = "1920x1080@60";
              position = "0,0";
            }
          ];
        }
        {
          profile.name = "work_end";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "BNQ BenQ BL2480 JBL0040201Q";
              mode = "1920x1080";
              position = "0,0";
            }
            {
              criteria = "Fujitsu Siemens Computers GmbH B22T-7 LED PG YV6J068403";
              mode = "1920x1080";
              position = "1920,0";
            }
          ];
        }
        {
          profile.name = "work_middle";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "BNQ BenQ BL2480 JBL0040201Q";
              mode = "1920x1080";
              position = "0,0";
            }
            {
              criteria = "Fujitsu Siemens Computers GmbH B22T-7 LED PG YV6J068403";
              mode = "1920x1080";
              position = "1920,0";
            }
          ];
        }
        {
          profile.name = "work_anto";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "Ancor Communications Inc ASUS VS229 FALMQS045053";
              mode = "1920x1080";
              position = "0,0";
            }
            {
              criteria = "Ancor Communications Inc ASUS VS229 EBLMQS089619";
              mode = "1920x1080";
              position = "1920,0";
            }
          ];
        }
        {
          profile.name = "work_macarena";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "BNQ BenQ GW2270 T6J09370019";
              mode = "1920x1080";
              position = "0,0";
            }
            {
              criteria = "Fujitsu Siemens Computers GmbH B22T-7 LED PG YV6J068464";
              mode = "1920x1080";
              position = "1920,0";
            }
          ];
        }
        {
          profile.name = "work_fj";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "BNQ BenQ BL2480 HCL0111701Q";
              position = "0,0";
              transform = "90";
            }
            {
              criteria = "BNQ BenQ BL2480 HCL0116301Q";
              mode = "1920x1080";
              position = "1080,0";
            }
          ];
        }
        {
          profile.name = "default";
          profile.outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080";
              position = "0,0";
            }
          ];
        }
      ];
    };
  };
}
