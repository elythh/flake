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
    home.file.".config/ags/style/colors.scss".text = with config.lib.stylix.colors; ''
      $base00: #${base00};
      $base01: #${base01};
      $base02: #${base02};
      $base03: #${base03};
      $base04: #${base04};
      $base05: #${base05};
      $base06: #${base06};
      $base07: #${base07};
      $base08: #${base08};
      $base09: #${base09};
      $base0A: #${base0A};
      $base0B: #${base0B};
      $base0C: #${base0C};
      $base0D: #${base0D};
      $base0E: #${base0E};
      $base0F: #${base0F};
    '';

    programs.ags = {
      enable = true;
      # packages to add to gjs's runtime
      extraPackages = [pkgs.libsoup_3];
    };
  };
}
