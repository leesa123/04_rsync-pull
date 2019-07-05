#!/bin/bash

# Param
_PARAM_NUM=$#
_PARAM_1=$1

# Rsync
_SRC_USER=root
_SSH_PRI=~/.ssh/id_rsa

# App log
_ROOT_DIR=/opt/rsync-pull
_BIN_DIR=$_ROOT_DIR/bin
_LOG_DIR=$_ROOT_DIR/log
_LOG_FILE=$_LOG_DIR/rsync_`date +'%Y%m%d'`.log
_MAX_LOGDAY=10
_DATEFORMAT='%Y/%m/%d %H:%M:%S'
_DEST_IP=`hostname -i`
_SSH_KNOWN='~/.ssh/known_hosts'

# Zabbix
_ZBX_CONFIG=/etc/zabbix/zabbix_agentd.conf
_ZBX_ITEM='test.trapper'
_ZBX_MSG='failed'

# Excute Mode
declare -A MODE;

MODE=(
["--dry-run"]="-avzn --xattrs --delete"
["--dry-run-diff"]="-avzcn --xattrs --delete"
["--run"]="-avz --xattrs --delete"
["--run-diff"]="-avzc --xattrs --delete"
)

# Option
_OPTION='Default value is --dry-run'

# Blank_error 
_MSG_TOTAL=0
_MSG_NUM_1=1
_MSG_NUM_3=3
_MSG_NUM_5=5
_MSG_NUM_9=9
