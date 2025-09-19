{ inputs, ... }:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];
  networking.hostName = "voidling"; # Define your hostname.

  documentation.enable = true;
  documentation.man.enable = false;
  documentation.doc.enable = false;

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "elyth";

    autoMigrate = true;

    # Optional: Declarative tap management
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };

  services.tailscale.enable = true;

  homebrew.brews = [
    {
      name = "font-sf-pro";
      args = [ "cask" ];
    }
  ];
}
