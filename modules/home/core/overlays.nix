{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      qt6Packages = prev.qt6Packages.overrideScope (
        _: kprev: {
          qt6gtk2 = kprev.qt6gtk2.overrideAttrs (_: {
            version = "0.5-unstable-2025-03-04";
            src = final.fetchFromGitLab {
              domain = "opencode.net";
              owner = "trialuser";
              repo = "qt6gtk2";
              rev = "d7c14bec2c7a3d2a37cde60ec059fc0ed4efee67";
              hash = "sha256-6xD0lBiGWC3PXFyM2JW16/sDwicw4kWSCnjnNwUT4PI=";
            };
          });
        }
      );
      fabric-run-widget = inputs.fabric.packages.${pkgs.system}.run-widget;
      fabric = inputs.fabric.packages.${pkgs.system}.default;
      fabric-cli = inputs.fabric-cli.packages.${pkgs.system}.default;
      fabric-gray = inputs.fabric-gray.packages.${pkgs.system}.default;
    })
    inputs.nur.overlays.default
  ];
}
