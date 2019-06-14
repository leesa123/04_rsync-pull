#!/bin/bash

_SRC_USER=s.lee
_SRC_IP=10.146.0.13
_SRC_DIR=/home/s.lee/rsync_home
_DEST_DIR=/home/s.lee/rsync_home

_LOG_DIR=/home/s.lee/rsync_log
_LOG_FILE=$_LOG_DIR/rsync_`date +'%Y%m%d'`.log
_MAX_LOGDAY=5


_DATEFORMAT=`date +'%Y/%m/%d %H:%M:%S'`
_SSH_PRI=~/.ssh/id_rsa

_ADMIN_MAIL=s.lee@rescuenow.co.jp

delete_expired_logfile() {
	echo "[$_DATEFORMAT]: Delete expired backup files modified longger than $_MAX_LOGDAY days ago in $_LOG_DIR." >> $_LOG_FILE
	find $_LOG_DIR -mtime +"$_MAX_LOGDAY" -delete -print >> $_LOG_FILE 2>&1
	echo -e "1. Delete expired backup files modified longger than $_MAX_LOGDAY days ago in $_LOG_DIR.【 \e[32mO K\e[0m 】"
}

synchronize_from_src_to_des() {
	rsync -avz --xattrs --delete $_SRC_USER@$_SRC_IP:$_SRC_DIR/ $_DEST_DIR/ >> $_LOG_FILE 2>&1
	if [ $? -eq 0 ]; then
		echo "[$_DATEFORMAT]:3. Synchronization was successful $_SRC_IP:$_SRC_DIR <-> localhost:$_DEST_DIR." >> $_LOG_FILE
		echo -e "3. Checking Synchronization $_SRC_IP:$_SRC_DIR <-> $HOSTNAME:$_DEST_DIR. 【 \e[32mO K\e[0m 】"
	else
		echo "[$_DATEFORMAT]: Synchronization was failed with code 1" >> $_LOG_FILE
		echo -e "3. Checking Synchronization $_SRC_IP:$_SRC_DIR <-> $HOSTNAME:$_DEST_DIR. 【 \e[31mFAILED\e[0m 】"
		cat ./alert.txt | mailx -s "rsync was failed." -r $HOSTNAME $_ADMIN_MAIL
	fi
}

check_ssh_pri_key() {
	if [ -e $_SSH_PRI ]; then
		
		_PERM=`stat $_SSH_PRI | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}'`
		
		if [ '0600' -eq $_PERM ]; then
			echo "[$_DATEFORMAT]: Checking id_rsa was successful" >> $_LOG_FILE
			echo -e "2. Checking ssh private key file【 \e[32mO K\e[0m 】"
			return 0
		else
			echo "[$_DATEFORMAT]: It is required that your private key files are NOT accessible by others. Set the value '-rw-------'" >> $_LOG_FILE
			echo "[$_DATEFORMAT]: Exiting abnormally" >> $_LOG_FILE
			echo -e "2. Checking ssh private key file【 \e[31mFAILD\e[0m 】"
			return 1 
		fi	
	else
		echo "[$_DATEFORMAT]: Not exists $_SSH_PRI" >> $_LOG_FILE
		echo "[$_DATEFORMAT]: Exiting abnormally" >> $_LOG_FILE
		echo -e "2. Checking ssh private key file【 \e[31mFAILD\e[0m 】"
		return 1 
	fi
}

main() {
	if [ -e $_LOG_DIR ]; then
		echo "[$_DATEFORMAT]: Open log directory $_LOG_DIR" > $_LOG_FILE
	else
		echo "[$_DATEFORMAT]: Create log directory $_LOG_DIR" > $_LOG_FILE
        	mkdir -p $_LOG_DIR
	fi
	delete_expired_logfile
	check_ssh_pri_key
	if [ $? -eq 0 ]; then
		synchronize_from_src_to_des
	fi
}

main
