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
        enable = lib.mkForce true;
      };
      plugins.obsidian = {
        enable = lib.mkForce true;
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
                    -- Get the current date
                    local currentDate = os.date("*t")

                    -- Calculate the difference in days to the first day of the week (Monday)
                    local diff = (currentDate.wday + 5) % 7

                    -- Subtract the difference to get the date of the first day of the week
                    currentDate.day = currentDate.day - diff

                    -- Return the date of the first day of the week
                    return os.date("%Y-%m-%d", os.time(currentDate))
                end
              '';
              tuesday.__raw = ''
                function()
                    -- Get the current date
                    local currentDate = os.date("*t")

                    -- Calculate the difference in days to the first day of the week (Monday)
                    local diff = (currentDate.wday + 4) % 7

                    -- Subtract the difference to get the date of the first day of the week
                    currentDate.day = currentDate.day - diff

                    -- Return the date of the first day of the week
                    return os.date("%Y-%m-%d", os.time(currentDate))
                end
              '';
              wednesday.__raw = ''
                function()
                    -- Get the current date
                    local currentDate = os.date("*t")

                    -- Calculate the difference in days to the first day of the week (Monday)
                    local diff = (currentDate.wday + 3) % 7

                    -- Subtract the difference to get the date of the first day of the week
                    currentDate.day = currentDate.day - diff

                    -- Return the date of the first day of the week
                    return os.date("%Y-%m-%d", os.time(currentDate))
                end
              '';
              thursday.__raw = ''
                function()
                    -- Get the current date
                    local currentDate = os.date("*t")

                    -- Calculate the difference in days to the first day of the week (Monday)
                    local diff = (currentDate.wday + 2) % 7

                    -- Subtract the difference to get the date of the first day of the week
                    currentDate.day = currentDate.day - diff

                    -- Return the date of the first day of the week
                    return os.date("%Y-%m-%d", os.time(currentDate))
                end
              '';
              friday.__raw = ''
                function()
                    -- Get the current date
                    local currentDate = os.date("*t")

                    -- Calculate the difference in days to the first day of the week (Monday)
                    local diff = (currentDate.wday + 1) % 7

                    -- Subtract the difference to get the date of the first day of the week
                    currentDate.day = currentDate.day - diff

                    -- Return the date of the first day of the week
                    return os.date("%Y-%m-%d", os.time(currentDate))
                end
              '';
            };
          };
        };
      };
      plugins.indent-blankline.enable = lib.mkForce false;
      assistant = "copilot";
    };
  };
in
{
  home.packages = [ nixvim ];
}
