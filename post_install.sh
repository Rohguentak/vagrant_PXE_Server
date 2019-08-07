#!/bin/bash

# This script needs to be run after the unattended installation
# and contains all the necessary commands to set up the target machine

apt-get update
apt-get upgrade -y
apt-get install -y vim
apt-get autoremove

