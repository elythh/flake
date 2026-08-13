{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.gsr-ui-nix.nixosModules.default
  ];

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
    fish.enable = true;
    dconf.enable = true;
    wshowkeys.enable = true;
    gpu-screen-recorder = {
      enable = true;
      package = inputs.gsr-ui-nix.packages.${pkgs.stdenv.hostPlatform.system}.gpu-screen-recorder;
      ui.enable = true;
    };
  };
}
