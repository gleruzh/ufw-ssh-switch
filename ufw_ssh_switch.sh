#!/bin/bash

# Your ddns domain
DOMAIN=example.com
# Use custom profile for ufw utility,
# where ports and protocols are specified.
SERVICENAME=ssh-custom

# Current IPv4 pointed by DOMAIN
MYIP=$(dig $DOMAIN +short)

# Just for debug
#echo "My IPv4 is "$MYIP

# IPv4 from ufw existing allow rule
ALLOWEDIP=$(ufw status | grep $SERVICENAME | tr -s [:blank:] "\t" | cut -f3)

# Just for debug
#echo "Currently allowed IPv4 is "$ALLOWEDIP

LOGFILE="/var/log/ufwswitch.log"
if [ ! -f $LOGFILE ];
then
# If file doesn't exist then touch it,
	touch $LOGFILE
# change owner and group
	chown root:adm $LOGFILE
# and set permissions.
	chmod 640 $LOGFILE
fi

if [ -z $ALLOWEDIP ];
then
# First run should add rule for MYIP.
	ufw allow from $MYIP to any app ssh-custom
# Push to LOGFILE and exit.
	echo $(date +%Y-%m-%d\ %T)": SSH access from "$MYIP" added." >> $LOGFILE
	exit
fi

# Check if different IP's then add actual and remove outdated rule.
if [ $MYIP != $ALLOWEDIP ];
then
# Add rule for MYIP
	ufw allow from $MYIP to any app ssh-custom
# Push to LOGFILE.
	echo $(date +%Y-%m-%d\ %T)": SSH access from "$MYIP" added." >> $LOGFILE
# Delete rule for ALLOWEDIP.
	ufw delete allow from $ALLOWEDIP to any app ssh-custom
# Push to LOGFILE.
	echo $(date +%Y-%m-%d\ %T)": SSH access from "$ALLOWEDIP" deleted." \
		>> $LOGFILE
fi

exit
