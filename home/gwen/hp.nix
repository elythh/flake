{
  inputs,
  pkgs,
  config,
  ...
}: {
  theme = "stardewnight";
  colorScheme = {
    palette = import ../shared/cols/${config.theme}.nix {};
    name = "${config.theme}";
  };

  imports = [
    inputs.anyrun.homeManagerModules.default
    ../../modules/home
  ];

  modules = {
    anyrun.enable = true;
    hyprland.enable = true;
    k9s.enable = true;
    sss.enable = true;
    zsh.enable = true;
  };

  default = {
    bar = "waybar";
    terminal = "wezterm";
  };

  home = {
    packages = with pkgs; [
      (pkgs.callPackage ../../derivs/phocus.nix {inherit config;})
      teeworlds # very important to work
    ];
  };
}
