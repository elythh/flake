{ config, ... }:

{
  home.file.".config/kanshi/config".text = ''

    profile {
    	output eDP-1 disable
      output HDMI-A-1 mode 1920x1080 position 2560,0
      output DP-5 mode 2560x1440@60 position 0,0
    }
    
    profile {
      output eDP-1 disable
      output "BNQ BenQ BL2480 JBL0008901Q" mode 1920x1080@60 position 1920,0
      output "BNQ BenQ BL2480 RAL0223001Q" mode 1920x1080@60 position 0,0
   }

   profile {
     output eDP-1 mode 1920x1080 position 0,0
   }
  '';
}
