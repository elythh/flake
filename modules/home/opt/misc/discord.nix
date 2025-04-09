{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.meadow.opt.misc.discord;
in
with config.lib.stylix.colors;
{
  options.meadow.opt.misc.discord = {
    enable = mkEnableOption "Wether to create discord custom theme";
  };

  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];
  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      discord.enable = false;
      vesktop.enable = true;
      config = {
        plugins = {
          alwaysAnimate.enable = true;
          anonymiseFileNames.enable = true;
          silentTyping.enable = true;
          typingIndicator.enable = true;
          typingTweaks.enable = true;
          whoReacted.enable = true;
          betterFolders.enable = true;
          betterSettings.enable = true;
          emoteCloner.enable = true;
          messageClickActions.enable = true;
          hideAttachments.enable = true; # Enable a Vencord plugin
          ignoreActivities = {
            # Enable a plugin and set some options
            enable = true;
            ignorePlaying = true;
            ignoreWatching = true;
          };
        };
      };
    };
  };
}
