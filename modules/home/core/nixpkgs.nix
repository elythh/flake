{
  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-29.4.6"
    ];
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}
