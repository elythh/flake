# in home.nix
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.opt.services.ags;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  options.opt.services.ags.enable = mkEnableOption "ags";

  config = mkIf cfg.enable {
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
      extraPackages = with pkgs; [ libsoup_3 ];
    };
  };
}
