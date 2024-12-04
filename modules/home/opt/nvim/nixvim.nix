{
  inputs,
  config,
  lib,
  ...
}:
let
  nixvim' = inputs.nixvim.packages."x86_64-linux".default;
  nixvim = nixvim'.extend {
    config = {
      theme = lib.mkForce "${config.theme}";
      colorschemes.base16 = {
        colorscheme = lib.mkForce {
          inherit (config.lib.stylix.colors.withHashtag)
            base00
            base01
            base02
            base03
            base04
            base05
            base06
            base07
            base08
            base09
            base0A
            base0B
            base0C
            base0D
            base0E
            base0F
            ;
        };
      };
      plugins = {
        obsidian = {
          enable = lib.mkForce false;
          settings = {
            workspaces = lib.mkForce [
              {
                name = "work";
                path = "~/obsidian/work";
              }
              {
                name = "home";
                path = "~/obsidian/home";
              }
            ];
            daily_notes = {
              template = "~/obsidian/templates/daily_note_template.md";
              folder = "~/obsidian/work/daily_notes";
            };
            templates = {
              subdir = "~/obsidian/templates";
              substitutions = {
                monday.__raw = ''
                  function()
                    local currentDate = os.date("*t")
                    local diff = (currentDate.wday + 5) % 7
                    currentDate.day = currentDate.day - diff
                    return os.date("%Y-%m-%d", os.time(currentDate))
                  end
                '';
                tuesday.__raw = ''
                  function()
                    local currentDate = os.date("*t")
                    local diff = (currentDate.wday + 4) % 7
                    currentDate.day = currentDate.day - diff
                    return os.date("%Y-%m-%d", os.time(currentDate))
                  end
                '';
                wednesday.__raw = ''
                  function()
                    local currentDate = os.date("*t")
                    local diff = (currentDate.wday + 3) % 7
                    currentDate.day = currentDate.day - diff
                    return os.date("%Y-%m-%d", os.time(currentDate))
                  end
                '';
                thursday.__raw = ''
                  function()
                    local currentDate = os.date("*t")
                    local diff = (currentDate.wday + 2) % 7
                    currentDate.day = currentDate.day - diff
                    return os.date("%Y-%m-%d", os.time(currentDate))
                  end
                '';
                friday.__raw = ''
                  function()
                    local currentDate = os.date("*t")
                    local diff = (currentDate.wday + 1) % 7
                    currentDate.day = currentDate.day - diff
                    return os.date("%Y-%m-%d", os.time(currentDate))
                  end
                '';
              };
            };
          };
        };
        avante.enable = lib.mkForce true;
      };
      assistant = "copilot";
    };
  };
in
{
  home.packages = [ nixvim ];
}
