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
        "https://cachix.cachix.org"
        "https://nixpkgs.cachix.org"
        "https://noctalia.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
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
      "nix-2.24.5"
      "electron-39.8.10"
      "electron-40.10.5"
    ];

    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };

  nixpkgs.overlays = [
    inputs.millennium.overlays.default
    (_: _: { millenium = inputs.millennium.overlays.default; })
    (_: prev: { niri = prev.niri.overrideAttrs { doCheck = false; }; })
    (final: prev: {
      teleport-connect = prev.callPackage ../../../pkgs/teleport-connect { };
      mo2-lint = prev.callPackage ../../../pkgs/mo2-lint { };
    })
  ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;
  };
}
