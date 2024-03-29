#!/bin/bash

# 1. Import files
# cmd-variables.conf : Import command-variables for using in rsync
# env-variables.sh : Import environment-variables for using in func.sh 
# func.sh : Import function was consist of deleting log, cheking ssh-private ...etc 
. ~/.bash_profile
. ./msg.sh
. ./env-variables.sh 
. ./cmd-variables.conf > /dev/null 2>&1
. ./func.sh

main() {
	
	# 1. Preprocessing
	check_param_num
	set_synchronize_mode
	check_directory_path
	
	# 2. Mainprocessing
	if [ -e $_LOG_DIR ]; then
		echo "[`date +"$_DATEFORMAT"`]: Open log directory $_LOG_DIR" > $_LOG_FILE
	else
		echo "[`date +"$_DATEFORMAT"`]: Create log directory $_LOG_DIR" > $_LOG_FILE
        	mkdir -p $_LOG_DIR
	fi

	delete_expired_logfile

	check_ssh_pri_key
	if [ $? -eq 0 ]; then
		check_ssh_knownhost
		if [ $? -eq 0 ]; then
			synchronize_from_src_to_des
			if [ $? -eq 0 ]; then
				echo "[`date +"$_DATEFORMAT"`]: Execution was successful. Ended Normally" >> $_LOG_FILE
				echo "[`date +"$_DATEFORMAT"`]: Ended Normally" >> $_LOG_FILE
			else
				notify_error
			fi
		else
			notify_error
		fi
	else
		notify_error
	fi
}

main
