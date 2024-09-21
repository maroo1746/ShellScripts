#!/bin/bash

function INFO() {
	echo -e '\033[35m'"[ 정보 ] : $*"'\033[0m';
}

function WARN() {
	echo -e '\033[31m'"[ 취약 ] : $*"'\033[0m';
}

function OK() {
	echo -e '\033[32m'"[ 양호 ] : $*"'\033[0m';
}

function check_Annotation() {

	# return value 1 : The line has been annotated
	# return value 2 : The line has not annotated
	# return value 3 : There isn't such line in file
	
	line="$1"
	file_name="$2"
		
	if grep -q "^[[:space:]]*#[[:space:]]*$line" "$file_name"; then
		return 1 
	elif grep -q "^[[:space:]]*$line" "$file_name"; then
		return 2
	else
		return 3	
	fi
}
