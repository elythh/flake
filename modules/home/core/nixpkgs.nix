{
  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-29.4.6"
      "nix-2.24.5"
    ];
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}
