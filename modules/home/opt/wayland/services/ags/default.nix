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
    home.packages = with pkgs; [
      swww
      fd
      bun
      dart-sass
      brightnessctl
      inputs.matugen.packages.${system}.default
      wf-recorder
      wayshot
      hyprpicker
      pavucontrol
      pamixer
    ];

    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = ./config;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
  };
}
