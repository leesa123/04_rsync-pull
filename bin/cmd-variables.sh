#!/bin/bash

# Production server's ip
_SRC_IP=xxxx

# !Caution!
# In the case of a directory, add '/' of literal to the end of the path.
# ex) '/var/www/html/'

# Production server's symmetric directory for synchronization
_SRC_DIR=xxxx

if [ $? -ne 0 ]; then
	_MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_5)
fi
# Backup server's symmetric directory for synchronization
_DEST_DIR=xxxx

if [ $? -ne 0 ]; then
	_MSG_TOTAL=$(expr $_MSG_TOTAL + $_MSG_NUM_9)
fi
