#!/bin/bash

# checking non-quatation values of '_SRC_DIR or _DEST_DIR'
check_dirpath_isblank_nq(){
	
	_CATCH_VALUE=`echo $1 | awk -F'[=]' '{print $1}'` 

	case "$_CATCH_VALUE" in
		_SRC_DIR)	_MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_5) ;;
		_DEST_DIR)	_MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_9) ;;
	esac
	
}
