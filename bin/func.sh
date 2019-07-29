#!/bin/bash

check_param_num() {
        if [ $_PARAM_NUM -ne 1 ]; then
                usage
        fi
}

check_directory_path() {
	check_dirpath_isblank_q
	check_dirpath_ng
}

# The function 'check_dirpath_isblank_nq' is being in the trap.sh
# checking quatation values of '_SRC_DIR or _DEST_DIR'
check_dirpath_isblank_q() {
        echo $_SRC_DIR | egrep --only-matching '[[:blank:]]'
        if [ $? -eq 0 ] || [ -z "$_SRC_DIR" ]; then
                _MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_1)
        fi

        echo $_DEST_DIR | egrep --only-matching '[[:blank:]]'
        if [ $? -eq 0 ] || [ -z "$_DEST_DIR" ]; then
                _MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_2)
        fi
	
        if [ $_MSG_TOTAL -ne 0 ]; then
		# [blank-point-Info] _MSG_TOTAL

       		# ※ Rule ※
        	#
        	# [DIR]                   [TOTAL]
        	# _SRC_DIR                1
        	# _DEST_DIR               2
        	# _SRC_DIR, _DEST_DIR     3

        	case "$_MSG_TOTAL" in
                	1)      blank_error $_DIR_SRC_DIR  ;;
                	2)      blank_error $_DIR_DEST_DIR ;;
			3)      blank_error '['$_DIR_SRC_DIR'], ['$_DIR_DEST_DIR']' ;;
                	*)      echo "Program error. Please contact the administrator." && exit 1;
        	esac
        fi
}

check_dirpath_ng() {
	
	_MSG_TOTAL_LOCAL=0
	_SRC_DIR_NG_VAL='Value detected from if statement.'
	_DEST_DIR_NG_VAL='Value detected from if statement.'
	
	# 
        for _e in ${NGDIR[@]}
        do
                if [ $_SRC_DIR = $_e ]; then
			_MSG_TOTAL_LOCAL=$(expr $_MSG_TOTAL_LOCAL + $_MSG_NUM_1)
			_SRC_DIR_NG_VAL=$_e
		fi

                if [ $_DEST_DIR = $_e ]; then
			_MSG_TOTAL_LOCAL=$(expr $_MSG_TOTAL_LOCAL + $_MSG_NUM_2)
			_DEST_DIR_NG_VAL=$_e
		fi
        done
	
	if [ $_MSG_TOTAL_LOCAL -ne 0 ]; then
		case "$_MSG_TOTAL_LOCAL" in
			1)	ngdir_error $_SRC_DIR_NG_VAL $_DIR_SRC_DIR ;;
			2)	ngdir_error $_DEST_DIR_NG_VAL $_DIR_DEST_DIR ;;
			3)	ngdir_error $_SRC_DIR_NG_VAL'|'$_DEST_DIR_NG_VAL $_DIR_SRC_DIR'|'$_DIR_DEST_DIR ;;
			*)	echo "Program error. Please contact the administrator." && exit 1;
		esac
	fi

}

delete_expired_logfile() {
        echo "[`date +"$_DATEFORMAT"`]: Delete expired backup files modified longger than $_MAX_LOGDAY days ago in $_LOG_DIR." >> $_LOG_FILE
        tmpwatch -m $(( $_MAX_LOGDAY * 24 )) $_LOG_DIR --verbose >> $_LOG_FILE 2>&1
        echo -e "1. Delete expired backup files modified longger than $_MAX_LOGDAY days ago in $_LOG_DIR.【 \e[32mO K\e[0m 】"
}

set_synchronize_mode() {
	_OPTION=${MODE["$_PARAM_1"]}
	if [ -z "$_OPTION" ]; then
		usage
	fi
}

synchronize_from_src_to_des() {
        if [ $? -eq 0 ]; then
                echo "[`date +"$_DATEFORMAT"`]:3. Synchronization was successful $_SRC_IP:$_SRC_DIR <-> $_DEST_IP:$_DEST_DIR." >> $_LOG_FILE
                echo -e "4. Checking Synchronization $_SRC_IP:$_SRC_DIR <-> $_DEST_IP:$_DEST_DIR. 【 \e[32mO K\e[0m 】"

		return 0;
        else
                echo "[`date +"$_DATEFORMAT"`]: Synchronization was failed with code 1" >> $_LOG_FILE
                echo -e "4. Checking Synchronization $_SRC_IP:$_SRC_DIR <-> $_DEST_IP:$_DEST_DIR. 【 \e[31mFAILED\e[0m 】"
                echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server." >> $_LOG_FILE
	
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
                        echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server." >> $_LOG_FILE

                        return 1
                fi
        else
                echo "[`date +"$_DATEFORMAT"`]: Not exists $_SSH_PRI" >> $_LOG_FILE
                echo "[`date +"$_DATEFORMAT"`]: Exiting abnormally" >> $_LOG_FILE
                echo -e "2. Checking ssh private key file【 \e[31mFAILD\e[0m 】"
                echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server." >> $_LOG_FILE

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
                echo "[`date +"$_DATEFORMAT"`]: Notify zabbix-server." >> $_LOG_FILE
		return 1;
	fi
}

notify_error() {
	# Zabbix
        /usr/bin/zabbix_sender -v -c $_ZBX_CONFIG -k "$_ZBX_ITEM" -o "$_ZBX_MSG" >> $_LOG_FILE
}
