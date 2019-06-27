#!/bin/bash

check_param_num() {
	if [ $_PARAM_NUM -ne 1 ]; then
		usage
		exit 1
	fi
}

delete_expired_logfile() {
        echo "[`date +"$_DATEFORMAT"`]: Delete expired backup files modified longger than $_MAX_LOGDAY days ago in $_LOG_DIR." >> $_LOG_FILE
        tmpwatch -m $(( $_MAX_LOGDAY * 24 )) $_LOG_DIR --verbose >> $_LOG_FILE 2>&1
        echo -e "1. Delete expired backup files modified longger than $_MAX_LOGDAY days ago in $_LOG_DIR.【 \e[32mO K\e[0m 】"
}

set_synchronize_mode() {
	case "$_PARAM_1" in
		"--dry-run" ) _OPTION=`echo ${MODE[--dry-run]}` ;;
		"--dry-run-diff" ) _OPTION=`echo ${MODE[--dry-run-diff]}` ;;
		"--run" ) _OPTION=`echo ${MODE[--run]}` ;;
		"--run-diff" ) _OPTION=`echo ${MODE[--run-diff]}` ;;
		* ) usage ;;
	esac
}

synchronize_from_src_to_des() {
        echo "[`date +"$_DATEFORMAT"`]: Start synchronization." >> $_LOG_FILE
        rsync $_OPTION $_SRC_USER@$_SRC_IP:$_SRC_DIR $_DEST_DIR >> $_LOG_FILE 2>&1
        if [ $? -eq 0 ]; then
                echo "[`date +"$_DATEFORMAT"`]:3. Synchronization was successful $_SRC_IP:$_SRC_DIR <-> $_DEST_IP:$_DEST_DIR." >> $_LOG_FILE
                echo -e "4. Checking Synchronization $_SRC_IP:$_SRC_DIR <-> $_DEST_IP:$_DEST_DIR. 【 \e[32mO K\e[0m 】"

		return 0;
        else
                echo "[`date +"$_DATEFORMAT"`]: Synchronization was failed with code 1" >> $_LOG_FILE
                echo -e "4. Checking Synchronization $_SRC_IP:$_SRC_DIR <-> $_DEST_IP:$_DEST_DIR. 【 \e[31mFAILED\e[0m 】"
                echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server.($_ZBX_SERVER_IP) " >> $_LOG_FILE
	
		return 1;
        fi
}

check_ssh_pri_key() {
        if [ -e $_SSH_PRI ]; then

                _PERM=`stat $_SSH_PRI | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}'`

                if [ '0600' -eq $_PERM ]; then
                        echo "[`date +"$_DATEFORMAT"`]: Checking id_rsa was successful" >> $_LOG_FILE
                        echo -e "2. Checking ssh private key file【 \e[32mO K\e[0m 】"

                        return 0
                else
                        echo "[`date +"$_DATEFORMAT"`]: It is required that your private key files are NOT accessible by others. Set the value '-rw-------'" >> $_LOG_FILE
                        echo "[`date +"$_DATEFORMAT"`]: Exiting abnormally" >> $_LOG_FILE
                        echo -e "2. Checking ssh private key file【 \e[31mFAILD\e[0m 】"
                        echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server.($_ZBX_SERVER_IP) " >> $_LOG_FILE

                        return 1
                fi
        else
                echo "[`date +"$_DATEFORMAT"`]: Not exists $_SSH_PRI" >> $_LOG_FILE
                echo "[`date +"$_DATEFORMAT"`]: Exiting abnormally" >> $_LOG_FILE
                echo -e "2. Checking ssh private key file【 \e[31mFAILD\e[0m 】"
                echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server.($_ZBX_SERVER_IP) " >> $_LOG_FILE

                return 1
        fi
}

check_ssh_knownhost() {
	ssh-keygen -F $_SRC_IP > /dev/null
	if [ $? -eq 0 ]; then
                echo "[`date +"$_DATEFORMAT"`]: $_SRC_IP is registered in $_SSH_KNOWN" >> $_LOG_FILE
                echo -e "3. $_SRC_IP is registered in $_SSH_KNOWN【 \e[32mO K\e[0m 】"
		return 0;
	else
                echo "[`date +"$_DATEFORMAT"`]: Not exists $_SRC_IP in $_SSH_KNOWN" >> $_LOG_FILE
                echo "[`date +"$_DATEFORMAT"`]: Exiting abnormally" >> $_LOG_FILE
                echo -e "3. $_SRC_IP is not registered in $_SSH_KNOWN【 \e[31mFAILD\e[0m 】"
                echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server.($_ZBX_SERVER_IP) " >> $_LOG_FILE
		return 1;
	fi
}

notify_error() {
	# Zabbix
        /usr/bin/zabbix_sender -v -z $_ZBX_SERVER_IP -s "$_ZBX_AGENT_HOST" -k "$_ZBX_ITEM" -o "$_ZBX_MSG" >> $_LOG_FILE
        #cat $_BIN_DIR/alert.txt | mailx -s "rsync was failed." -r $HOSTNAME $_ADMIN_MAIL
}

usage() {
cat <<_EOT_
Usage:
  	$0 [--dry-run, --dry-run-diff, --run, --run-diff]

Description:
 	This is a tool to synchronize by pulling method. 
	If you hit without specifying any option, '--dry-run' will be executed.		

Options:
	--dry-run	Perform a trial run with no changes mode.
			You can check target files from the log file.
			(default)
  	--dry-run-diff	It has the some functionality as '--dry-run'.
			Additionly, you can use checksum to check data differences. not mod-time & size
			You can check target files from the log file.

  	--run		It is not trial mode. Actually synchronized.
			The target to be synchronized can be confirmed in '--dry-run'. 
			
  	--run-diff	It has the some functionality as '--run'.
			The target to be synchronized can be confirmed in '--dry-run-diff'.


_EOT_
exit 1
}
