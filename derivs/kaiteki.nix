{ lib, appimageTools, fetchurl, pkgs }:
appimageTools.wrapType2 {
  # or wrapType1
  name = "kaiteki";
  src = fetchurl {
    url = "https://github.com/Kaiteki-Fedi/Kaiteki/releases/download/weekly-2023-21/Kaiteki-x86_64.AppImage";
    sha256 = "0fhd0fsah7p4sgqn9qlsrkxw8bzvisgji4wk4irva7mk4wmq5xgn";
  };
  extraPkgs = pkgs: with pkgs; [ ];
}
