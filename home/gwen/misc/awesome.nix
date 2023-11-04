{ pkgs, config, nix-colors, ... }:
let
  colors = config.colorscheme.colors;
in
{

  home.file.".config/awesome/theme/colors.lua".text = ''
    local M = {}

    M.name  = '${colors.name}'
    M.ow = '${colors.wallpaper}'
    M.wall  = '~/.config/awesome/theme/wallpapers/${colors.name}/${colors.wallpaper}'
    M.ok    = "#${colors.color2}"
    M.warn  = "#${colors.color3}"
    M.err   = "#${colors.color1}"
    M.pri   = "#${colors.color4}"
    M.dis   = "#${colors.color5}"
    M.bg    = "#${colors.background}"
    M.mbg   = "#${colors.mbg}"
    M.bg2   = "#${colors.bg2}"
    M.bg3   = "#${colors.color0}"
    M.bg4   = "#${colors.color8}"
    M.fg    = "#${colors.foreground}"
    M.fg2   = "#${colors.color7}"
    M.fg3   = "#${colors.color15}"
    M.fg4   = "#${colors.comment}"
    M.iconTheme = "/nix/store/8n15bqfh8n1lq289928fgpslcqxvwz7n-Reversal/share/icons/Reversal"

    return M
  '';
}

