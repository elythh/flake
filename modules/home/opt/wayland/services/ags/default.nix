# in home.nix
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with config.colorscheme.palette; {
  imports = [inputs.ags.homeManagerModules.default];
  config = lib.mkIf (config.default.bar == "ags") {
    home.file.".config/ags/style/colors.scss".text = ''
      $base00: #${background};
      $base01: #${mbg};
      $base02: #${darker};
      $base03: #${color4};
      $base04: #${color5};
      $base05: #${foreground};
      $base06: #${color7};
      $base07: #${color8};
      $base08: #${color9};
      $base09: #${color10};
      $base0A: #${accent};
      $base0B: #${color12};
      $base0C: #${color13};
      $base0D: #${color14};
      $base0E: #${color15};
      $base0F: #${accent};
    '';

    programs.ags = {
      enable = true;
      # packages to add to gjs's runtime
      extraPackages = [pkgs.libsoup_3];
    };
  };
}
