let
  default = [
    ./core/default.nix
    ./opt/default.nix
  ];

in
{
  inherit default;
}
