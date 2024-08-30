{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.common;
in
{
  imports = [ (lib.snowfall.fs.get-file "modules/shared/suites/common/default.nix") ];

  config = mkIf cfg.enable {

    environment = {
      defaultPackages = lib.mkForce [ ];

      systemPackages = with pkgs; [
        curl
        dnsutils
        lshw
        pciutils
        rsync
        upower
        util-linux
        wget
      ];
    };

    elyth = {
      hardware = {
        power = enabled;
      };

      nix = enabled;

      programs = {
        terminal = {
          tools = {
            bandwhich = enabled;
            nix-ld = enabled;
          };
        };
      };

      security = {
        gpg = enabled;
        pam = enabled;
      };

      services = {
        openssh = enabled;
      };

      system = {
        fonts = enabled;
        locale = enabled;
        time = enabled;
      };
    };
  };
}
