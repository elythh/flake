{
  pkgs,
  config,
  lib,
  ...
}:
let
  ax-shell = builtins.fetchGit {
    url = "https://github.com/Axonide/Ax-Shell.git";
    ref = "main";
    rev = "5568c0db692c7dc3d6532d41ca5334a2f4aec0c9";
  };
  cfg = config.meadow.programs.ax-shell;

  inherit (lib) mkIf mkEnableOption;
in
{
  options.meadow.programs.ax-shell = {
    enable = mkEnableOption "ax-shell";
  };

  config = mkIf cfg.enable {
    home.file.".local/share/fonts/tabler-icons.ttf" = {
      source = "${ax-shell}/assets/fonts/tabler-icons/tabler-icons.ttf";
    };
    home.packages = with pkgs; [
      pkgs.nur.repos.HeyImKyu.fabric-cli
      (pkgs.nur.repos.HeyImKyu.run-widget.override {
        extraPythonPackages = with python3Packages; [
          python-dotenv
          psutil
        ];
        extraBuildInputs = [
          pkgs.nur.repos.HeyImKyu.fabric-gray
        ];
      })
    ];
  };
}
