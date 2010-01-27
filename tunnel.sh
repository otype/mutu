#!/bin/bash

#############################################################
# CONSTANTS/GLOBALS
#############################################################

SSH_CMD="/usr/bin/ssh"
SSH_SOCKS_PORT=$1
SSH_USER=$2
SSH_SERVER=$3
DATE=`date`
HOSTNAME=`hostname`
E_PARAM_ERR=-198    # If less than 2 params passed to function.

#############################################################
# FUNCTIONS
#############################################################

OTLog() {
	logstr=$1
	if [ -z "$logstr" ]; then		# Is parameter #1 zero length?
		echo "Missing parameter!"		
		return $E_PARAM_ERR
	fi
	
	echo "$DATE $HOSTNAME tunnel.sh: $logstr"
	return 0
}

#############################################################
# MAIN
#############################################################

OTLog "SSH_SOCKS_PORT = $SSH_SOCKS_PORT"
OTLog "SSH_USER = $SSH_USER"
OTLog "SSH_SERVER = $SSH_SERVER"

# Execute command
$SSH_CMD -D $SSH_SOCKS_PORT -N $SSH_USER@$SSH_SERVER
