#!/bin/bash

# This script needs to be run after the unattended installation
# and contains all the necessary commands to set up the target machine

# Variables
LOG=/root/postinstall.log

# Updates and new packages
apt-get update 2> $LOG
apt-get upgrade -y 2> $LOG
apt-get install -y vim dconf-cli 2> $LOG
apt-get autoremove 2> $LOG

# Locale
dconf reset -f /org/gnome/terminal 2> $LOG
apt-get remove gnome-terminal -y 2> $LOG
apt-get install gnome-terminal -y 2> $LOG
locale-gen --purge en_US.UTF-8 2> $LOG
update-locale 2> $LOG

# DHCP interfaces
sed -i 's/manual/dhcp/g' /etc/network/interfaces 2> $LOG

# Testing if script has been executed
if [ ! -f $LOG ]; then
    echo "Post install script ended successfully" > $LOG
fi
