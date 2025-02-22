username:
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./system.nix
    ./audio.nix
    ./locale.nix
    ./nautilus.nix
    ./hyprland.nix
  ];

  hyprland.enable = true;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  users = {
    users.${username} = {
      isNormalUser = true;
      initialPassword = username;
      extraGroups = [
        "nixosvmtest"
        "networkmanager"
        "wheel"
        "audio"
        "video"
        "libvirtd"
        "docker"
      ];
    };
    defaultUserShell = pkgs.fish;
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [ ./home.nix ];
    };
  };

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = [ "Gnome" ];
      hyprland.enable = true;
    };
  };
}
