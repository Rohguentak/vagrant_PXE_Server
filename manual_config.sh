#!/bin/bash

# This script should be run manually and with admin privileges.
# It will prompt the user for new values of certain parameters.
# E.g.: hostname, user password, ...

# Hostname
echo "Type this PC's hostname:"
read hostname
hostnamectl set-hostname $hostname
sed -i "s/127.0.1.1.*/127.0.1.1   $hostname/" /etc/hosts

# Password
echo "Type password for user 'investigator':"
read -s password
echo "$password\n$password" | passwd investigator
