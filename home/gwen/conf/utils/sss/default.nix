{ config, inputs, ... }: {
  imports = [ inputs.sss.nixosModules.home-manager ];

  programs.sss = {
    enable = true;

    # General Config
    general = with config.colorscheme.palette; {
      author = "gwen";
      # copy = true;
      colors = {
        background = "#${accent}";
        author = "#${foreground}";
        shadow = "#${darker}";
      };
      fonts = "Product Sans=12.0";
      radius = 8;
      save-format = "png";
      shadow = true;
      shadow-image = true;
    };
  };
}
