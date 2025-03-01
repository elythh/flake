{
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
      "/var/db/sudo"
    ];

    files = [
      "/etc/machine-id"
      "/home/gwen/.ssh/id_default"
    ];
  };
}
