{ config, ... }:

{
  home.file.".config/kanshi/config".text = ''

    profile {
    	output eDP-1 disable
      output "Philips Consumer Electronics Company 247ELH AU01243009967" mode 1920x1080 position 2560,0
      output "XMI Mi Monitor 3342300023271" mode 2560x1440@60 position 0,0
    }
    
    profile {
      output eDP-1 disable
      output "BNQ BenQ BL2480 JBL0008901Q" mode 1920x1080@60 position 1920,0
      output "BNQ BenQ BL2480 RAL0223001Q" mode 1920x1080@60 position 0,0
    }

    profile {
      output eDP-1 disable
      output "BNQ BenQ BL2480 JBL0040201Q" mode 1920x1080 position 0,0
      output "Fujitsu Siemens Computers GmbH B22T-7 LED PG YV6J068403" mode 1920x1080 position 1920,0
    }

   profile {
     output eDP-1 mode 1920x1080 position 0,0
   }
  '';
}
