{ config, nix-colors, pkgs, ... }:

{
  programs.k9s = {
    enable = true;
    skin = {
      k9s = with config.colorscheme.colors;{
        body = {
          fgColor = "#${foreground}";
          bgColor = "#${background}";
          logoColor = "#${color5}";
        };
        # Command prompt styles;
        prompt = {
          fgColor = "#${foreground}";
          bgColor = "#${background}";
          suggestColor = "#${color5}";
        };
        # ClusterInfoView styles.;
        info = {
          fgColor = "#${color13}";
          sectionColor = "#${foreground}";
          # Dialog styles.;
        };
        dialog = {
          fgColor = "#${foreground}";
          bgColor = "#${background}";
          buttonFgColor = "#${foreground}";
          buttonBgColor = "#${color5}";
          buttonFocusFgColor = "#${color3}";
          buttonFocusBgColor = "#${color13}";
          labelFgColor = "#${color11}";
          fieldFgColor = "#${foreground}";
        };
        frame = {
          # Borders styles.;
          border = {
            fgColor = "#${mbg}";
            focusColor = "#${bg2}";
          };
          menu = {
            fgColor = "#${foreground}";
            keyColor = "#${color13}";
            # Used for favorite namespaces;
            numKeyColor = "#${color13}";
          };
          # CrumbView attributes for history navigation.;
          crumbs = {
            fgColor = "#${foreground}";
            bgColor = "#${bg2}";
            activeColor = "#${bg2}";
          };
          # Resource status and update styles;
          status = {
            newColor = "#${color6}";
            modifyColor = "#${color5}";
            addColor = "#${color2}";
            errorColor = "#${color1}";
            highlightColor = "#${color11}";
            killColor = "#${comment}";
            completedColor = "#${comment}";
          };
          # Border title styles.;
          title = {
            fgColor = "#${foreground}";
            bgColor = "#${bg2}";
            highlightColor = "#${color11}";
            counterColor = "#${color5}";
            filterColor = "#${color13}";
          };
        };
        views = {
          # Charts skins...;
          charts = {
            bgColor = "#${background}";
          };
          # TableView attributes.
          table = {
            fgColor = "#${foreground}";
            bgColor = "#${background}";
            # Header row styles.;
            header = {
              fgColor = "#${foreground}";
              bgColor = "#${background}";
              sorterColor = "#${color6}";
            };
          };
          # Xray view attributes.;
          xray = {
            fgColor = "#${foreground}";
            bgColor = "#${background}";
            cursorColor = "#${bg2}";
            graphicColor = "#${color5}";
            showIcons = false;
          };
          # YAML info styles.;
          yaml = {
            keyColor = "#${color13}";
            colonColor = "#${color5}";
            valueColor = "#${foreground}";
          };
          # Logs styles.;
          logs = {
            fgColor = "#${foreground}";
            bgColor = "#${background}";
            indicator = {
              fgColor = "#${foreground}";
              bgColor = "#${color5}";
            };
          };
        };

      };
    };
  };
}
