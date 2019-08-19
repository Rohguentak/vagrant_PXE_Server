#!/bin/bash

# This script needs to be run after the unattended installation
# and contains all the necessary commands to set up the target machine

# Variables
LOG=/root/postinstall.log

# Updates and new packages
apt-get update 2>> $LOG
apt-get upgrade -y 2>> $LOG
apt-get autoremove 2>> $LOG

# Configure display manager
echo lightdm shared/default-x-display-manager select lightdm | debconf-set-selections 2>> $LOG

# GRUB configuration
#sed -i 's/quiet//g' /etc/default/grub 2>> $LOG
sed -i 's/splash//g' /etc/default/grub 2>> $LOG
sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub 2>> $LOG
update-grub 2>> $LOG

# Download manual config script
wget -O /root/manual_config.sh --tries=2 http://192.168.0.3/manual_config.sh
chmod 750 /root/manual_config.sh

# Testing if script has been executed
if [ ! -s $LOG ]; then
    echo "Post install script ended successfully" > $LOG
fi
