{ pkgs, ... }: {
  users = {
    users.gwen = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "libvirtd"
        "docker"
        "uinput"
      ];
    };
    defaultUserShell = pkgs.zsh;
  };
}
