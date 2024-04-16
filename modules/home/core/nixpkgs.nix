{
  nixpkgs.config = {
    permittedInsecurePackages = ["electron-25.9.0"];
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}
