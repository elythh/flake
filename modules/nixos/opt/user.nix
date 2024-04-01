{pkgs, ...}: {
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
      ];
    };
    defaultUserShell = pkgs.zsh;
  };
}
