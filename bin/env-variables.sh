# Param
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
_ZBX_SERVER_IP=xxxx
_ZBX_AGENT_HOST=xxxx
_ZBX_ITEM=xxxx
_ZBX_MSG=xxxx

# Mailx
#_ADMIN_MAIL=xxxx@xxxx.co.jp

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
