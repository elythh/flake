{
  nixpkgs.overlays = [
    (self: super: {gg-sans = super.callPackage ../../../derivs/gg-sans {};})
  ];
}
