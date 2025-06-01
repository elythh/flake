{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    astal,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = astal.lib.mkLuaPackage {
      inherit pkgs;
      name = "astal-bar"; # how to name the executable
      src = ./.; # should contain init.lua

      # add extra glib packages or binaries
      extraPackages = with astal.packages.${system};
        [
          battery
          astal3
          io
          apps
          bluetooth
          mpris
          network
          notifd
          powerprofiles
          tray
          wireplumber
          hyprland
        ]
        ++ (with pkgs; [
          sass
        ]);

      extraLuaPackages = ps:
        with ps; [
          luautf8
        ];
    };
  };
}
