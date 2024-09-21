#!/bin/bash
. ./functions.sh

TELNET_STATUS=$(systemctl is-active telnet.socket)

if [ "$TELNET_STATUS" = 'active' ]; then
	WARN "TELNET service is active."
	if [-f '/etc/securetty']; then
		grep -q 'pts/' '/etc/securetty'
		if [ $? -eq 0 ]; then
			WARN 'there is a pts/# in /etc/securetty'
		else
			OK 'there is no pts/# in /etc/securetty'
		fi
	else 
		WARN "/etc/securetty doesn't exist"
	fi

	if [-f '/etc/pam.d/login']; then
		FILE="/etc/pam.d/login"
		LINE="auth required /lib/security/pam_securetty.so"
		check_Annotation "$LINE" "$FILE"
		result=$?
		if [ $result -eq 2 ]; then
			OK '$LINE not Annotated'
		elif [ $result -eq 1 ]; then
			WARN '$LINE Annotated'
		elif [ $result -eq 3 ]; then
			WARN '$LINE line not Exist'
		fi
	else
		WARN 'etc/pam.d/login does not Exist'
	fi
	
else
	OK "TELNET service is not active." 
fi

SSH_STATUS=$(systemctl is-active sshd.service)

if [ "$SSH_STATUS" = 'active' ]; then
	INFO "SSH service is active."
	FILE="/etc/ssh/sshd_config"
	LINE="PermitRootLogin No"
	if [ -f "$FILE" ]; then
		INFO "$FILE Exists"
		check_Annotation "$LINE" "$FILE"
		result=$?
		if [ $result -eq 1 ]; then
			WARN "$LINE Annotated. You should not annotate it"
		elif [ $result -eq 2 ]; then
			OK "$LINE not Annotated."
		elif [ $result -eq 3 ]; then
			WARN "$LINE line not Exist. You should add it"
		else
			echo "$result" 
		fi
	else
		WARN "$FILE does not Exist."
	fi
	
else
	OK "SSH service is not active." 
fi
