# ufw-ssh-switch

I need to access  a server via ssh only from the one IPv4, which is connected with a public domain, but the IP is dynamic. So I need to force ufw reload rule when IP changes

## Requirements

Linux with bash, systemd, ufw, dig

## Installation

1. ### Download code

  git clone https://github.com/leruzh/ufw-ssh-switch.git

  cd ufw-ssh-switch

2. ### Setup service and port to allow by ufw.

  *My example is SSH with custom port 2222*
  
    1. Edit file to change port
    2. Edit filename to change service
    3. Copy config file to /etc/

  sudo cp ufw/ssh-custom /etc/ufw/applications.d/

3. ### Edit script file.

  *My example domain is example.com*
  
    1. Change domain name
    2. If you do changes at 2.2, change service name.
    3. Copy script file to /usr/local/bin/
    
  sudo cp ufw_ssh_switch.sh /usr/local/bin/

4. ### Add Systemd units

  sudo cp systemd/ufw-ssh-switch.* /etc/systemd/system/
  
  sudo systemctl daemon reload
  
  sudo systemctl enable --now ufw-ssh-switch.service
  
  sudo systemctl enable --now ufw-ssh-switch.timer

5. ### Check log file

   sudo tail -f /var/log/ufwswitch.log
