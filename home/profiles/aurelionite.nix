{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./shared
    inputs.stylix.homeModules.stylix
    ../../modules/home
  ];
  meadow = {
    programs = {
      spicetify.enable = true;
      zellij.enable = true;
    };

    services = {
      hypridle.enable = true;
    };

    default = {
      shell = [
        "fish"
        "zsh"
      ];
      terminal = "foot";
    };
  };

  # Specific packages for this home-manager host config
  home = {
    packages = with pkgs; [
      teeworlds # very important to work
      distrobox
    ];
  };
}
