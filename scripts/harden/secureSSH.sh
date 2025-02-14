#!/bin/bash
#Script to rewrite the sshd_config file to secure the SSH server
#Based on testing, prepending the proper configuration to the start of the sshd_config file,
#the service reads the first instance and sets that value. Further changes are not implemented,
#i.e., the first time a configuration is specified, it is locked.
#Crude way to do it, instead of replacing it with a secure configuration file, but it works.

#Makes sure file is not read/append only and has all necessary permissions to complete its job
#chattr -ia /etc/ssh/sshd_config 

#Gets the current ssh configuration from the file
currentConfig=$(cat /etc/ssh/sshd_config)
#Deletes the current file
sudo rm /etc/ssh/sshd_config

#Checks if the variable, and also if the configuration file exists
if [ -n "$currentConfig" ]; then
  #Echos a secure configuration 
  #Change these statements as needed for your configuration
  #Designed for a scoreboard that accepts password updates, not for public-key authentication
  #StrictModes is set to yes and will deny SSH authentication if their home directory has too many permissions
  #or if the authorized key files have group write permissions
  echo "AllowTCPForwarding no" >> /etc/ssh/sshd_config
  echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
  echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config
  echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
  echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config
  echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config
  echo "LoginGraceTime 60" >> /etc/ssh/sshd_config
  echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config
  echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
  echo "MaxSessions 2" >> /etc/ssh/sshd_config
  echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
  echo "PermitRootLogin no" >> /etc/ssh/sshd_config
  echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config
  echo "Protocol 2" >> /etc/ssh/sshd_config
  echo "PubkeyAuthentication no" >> /etc/ssh/sshd_config
  echo "StrictModes yes" >> /etc/ssh/sshd_config
  echo "X11Forwarding no" >> /etc/ssh/sshd_config

  #Echos the rest of the configuration back into the sshd_config file
  echo "$currentConfig" >> /etc/ssh/sshd_config

  #Restarts the sshd service and checks if it restarted
  echo "SSH configuration file secured. Restarting service..."
  sudo systemctl restart sshd
  sshdStatus=$(systemctl is-active sshd)
  #If the output is active, the service restarted correctly
  if [ "$sshdStatus" = "active" ]; then
    echo "Successsfully restarted sshd service."
  else
    echo "Failed to restart sshd service."
  fi

#Else, configuration file does not exist
else
  echo "SSH configuration file does not exist."
  echo $currentConfig
  exit 1
fi