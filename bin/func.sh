#!/bin/bash
. ./msg.sh

check_param_num() {
	if [ $_PARAM_NUM -ne 1 ]; then
		usage
	fi
}

check_dirpath_isblank() {
	echo $_SRC_DIR | egrep --only-matching '[[:blank:]]'
	if [ $? -eq 0 ]; then
		_MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_1)
	fi
	
	echo $_DEST_DIR | egrep --only-matching '[[:blank:]]' 
	if [ $? -eq 0 ]; then
		_MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_3)
	fi
	blank_error_param $_MSG_TOTAL
}

blank_error_param() {
	# [blank-point-Info] _MSG_TOTAL 

	# ※ Promise symbol ※
        # In the case of setting variable by quotatio -> Q
        # In the case of setting variable by non-quotation -> NQ
	# 
	# [Symbol]	[DIR]			[TOTAL]
	# Q		_SRC_DIR		1
	# Q		_DEST_DIR		3
	# NQ		_SRC_DIR		5
	# NQ		_DEST_DIR		9
	# Q|Q		_SRC_DIR|_DEST_DIR	4
	# Q|NQ		_SRC_DIR|_DEST_DIR	10
	# NQ|Q		_SRC_DIR|_DEST_DIR	8
	# NQ|NQ		_SRC_DIR|_DEST_DIR	14

	_SYMBOL_QUOTATION='Q'
	_SYMBOL_NONQUOTATION='NQ'
	_DIR_SRC_DIR='_SRC_DIR'
	_DIR_DEST_DIR='_DEST_DIR'

	case "$_MSG_TOTAL" in
		1)	blank_error $_SYMBOL_QUOTATION $_DIR_SRC_DIR ;;
		3)	blank_error $_SYMBOL_QUOTATION $_DIR_DEST_DIR ;;
		5)	blank_error $_SYMBOL_NONQUOTATION $_DIR_SRC_DIR ;;
		9)	blank_error $_SYMBOL_NONQUOTATION $_DIR_DEST_DIR ;;
		4)	blank_error $_SYMBOL_QUOTATION'|'$_SYMBOL_QUOTATION $_DIR_SRC_DIR', '$_DIR_DEST_DIR ;;
		10)	blank_error $_SYMBOL_QUOTATION'|'$_SYMBOL_NONQUOTATION $_DIR_SRC_DIR', '$_DIR_DEST_DIR ;;
		8)	blank_error $_SYMBOL_NONQUOTATION'|'$_SYMBOL_QUOTATION $_DIR_SRC_DIR', '$_DIR_DEST_DIR ;;
		14)	blank_error $_SYMBOL_NONQUOTATION'|'$_SYMBOL_NONQUOTATION $_DIR_SRC_DIR', '$_DIR_DEST_DIR ;; 
	esac
	
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
        /usr/bin/zabbix_sender -v -c $_ZBX_CONFIG -k "$_ZBX_ITEM" -o "$_ZBX_MSG" >> $_LOG_FILE
}
