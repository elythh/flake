{ inputs, pkgs, ... }: {
  imports = [ inputs.fufexan-dotfiles.homeManagerModules.eww-hyprland ];

  programs.eww-hyprland = {
    enable = true;

    # default package
    package = pkgs.eww-wayland;

    # if you want to change colors
    # colors = builtins.readFile ./latte.scss;

    # set to true to reload on change
    autoReload = false;
  };
}

