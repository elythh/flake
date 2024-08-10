{
  programs = {
    direnv = {
      silent = true;
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash.enable = true;
  };
}
