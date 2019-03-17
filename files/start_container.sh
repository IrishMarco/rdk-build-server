#!/bin/bash

# If you have something to start (service?)
# this is the right place
sudo  /etc/init.d/shellinabox start

# Start the SSH daemon and keep it running
sudo /usr/sbin/sshd -eD
