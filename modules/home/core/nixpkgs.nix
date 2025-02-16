{
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
}
