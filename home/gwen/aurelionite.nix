{
  inputs,
  pkgs,
  ...
}: {
  theme = "paradise";

  imports = [
    inputs.anyrun.homeManagerModules.default
    ../../modules/home
  ];

  modules = {
    anyrun.enable = true;
    hyprland.enable = true;
    k9s.enable = true;
    lazygit.enable = true;
    rofi.enable = true;
    rbw.enable = true;
    spicetify.enable = true;
    sss.enable = true;
    zellij.enable = true;
    zsh.enable = true;
  };

  default = {
    de = "hyprland";
    bar = "ags";
    lock = "hyprlock";
    terminal = "foot";
  };

  home = {
    packages = with pkgs; [
      teeworlds # very important to work
    ];
  };
}
