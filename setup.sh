#!/bin/bash

# For Debian 10-11 only!

SSHD_CONFIG_PATH="/etc/ssh/sshd_config"
JAIL_LOCAL_PATH="/etc/fail2ban/jail.local"

if [[ "$EUID" -ne 0 ]]; then
	echo "Script must be run as root!"
	exit
fi

echo "Doing system update and upgrade..."
apt update
apt upgrade -y

echo "Installing fail2ban..."
apt install fail2ban -y

if [[ -f "$SSHD_CONFIG_PATH.bak" ]]; then
	echo "Old sshd_config found, skipping back up..."
else
	echo "Backing up sshd_config..."
	cp "$SSHD_CONFIG_PATH" "$SSHD_CONFIG_PATH.bak"
fi

echo "Modifying sshd_config..."
cp ./sshd_config $SSHD_CONFIG_PATH

if [[ -f "$JAIL_LOCAL_PATH.bak" ]]; then
	echo "Old jail.local found, skipping back up..."
elif [[ -f "$JAIL_LOCAL_PATH" ]]; then
	echo "Backing up jail.local..."
	cp "$JAIL_LOCAL_PATH" "$JAIL_LOCAL_PATH.bak"
fi

echo "Modifying jail.local..."
cp ./jail.local $JAIL_LOCAL_PATH

echo "Done!"
