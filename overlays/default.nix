# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    imgclr = prev.callPackage ../derivs/imagecolorizer.nix {
      buildPythonPackage = prev.python310Packages.buildPythonPackage;
    };
    spotdl = prev.callPackage ../derivs/spotdl.nix {
      buildPythonApplication = prev.python311Packages.buildPythonApplication;
    };
    lutgen = prev.callPackage ../derivs/lutgen.nix { };
    kaiteki = prev.callPackage ../derivs/kaiteki.nix { };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
