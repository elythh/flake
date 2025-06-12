{
  pkgs,
  inputs,
  ...
}:
{
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.lix.systems"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operator"
        "lix-custom-sub-commands"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      auto-optimise-store = true;
      warn-dirty = false;
    };

    channel.enable = false;

    gc = {
      automatic = true;
      options = "--delete-older-than 1d";
      dates = "22:30";
    };

    optimise.automatic = true;
  };

  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-27.3.11"
      "electron-30.5.1"
      "nix-2.24.5"
    ];

    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      fabric-run-widget = inputs.fabric.packages.${pkgs.system}.run-widget;
      fabric = inputs.fabric.packages.${pkgs.system}.default;
      fabric-cli = inputs.fabric-cli.packages.${pkgs.system}.default;
      fabric-gray = inputs.fabric-gray.packages.${pkgs.system}.default;
    })
    inputs.nur.overlays.default
  ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
}
