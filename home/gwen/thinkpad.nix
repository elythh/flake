{
  inputs,
  pkgs,
  config,
  ...
}: {
  theme = "tokyo";
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
    rbw.enable = true;
    sss.enable = true;
    zsh.enable = true;
  };

  default = {
    bar = "ags";
    terminal = "wezterm";
  };

  home = {
    packages = with pkgs; [
      (pkgs.callPackage ../../derivs/phocus.nix {inherit config;})
      (discord.override {withVencord = true;})
      scrcpy
      stremio
      yazi
      showmethekey
    ];
  };
}
