{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./shared
    inputs.stylix.homeModules.stylix
    inputs.caelestia.homeManagerModules.default
    inputs.noctalia.homeModules.default
    inputs.mango.hmModules.mango
    ../../modules/home
  ];

  meadow = {
    programs = {
      spicetify.enable = false;
      zellij.enable = true;
    };

    services = {
      hypridle.enable = true;
      vicinae.enable = true;
    };

    default = {
      shell = [
        "fish"
        "zsh"
      ];
      terminal = "foot";
      wm = "hyprland";
    };
  };

  # Specific packages for this home-manager host config
  home = {
    packages = with pkgs; [
      android-tools
      lunar-client
      scrcpy
      equicord
      wdisplays
      yazi
      # affine
    ];
  };
}
