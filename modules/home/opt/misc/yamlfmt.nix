{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.meadow.opt.misc.yamlfmt;
in
{
  options.meadow.opt.misc.yamlfmt = {
    enable = mkEnableOption "Wether to enable Yamlfmt";
  };
  config = mkIf cfg.enable {
    home.file.".config/yamlfmt/.yamlfmt".text = ''
      formatter:
        type: basic
        disallow_anchors: false
        include_document_start: false
        retain_line_breaks: true
        drop_merge_tag: true
        indentless_arrays: false
    '';
  };
}
