#!/bin/bash
. ./msg.sh

# Production server's ip
_SRC_IP=xxxx

# !Caution!
# In the case of a directory, add '/' of literal to the end of the path.
# ex) '/var/www/html/'

# Production server's symmetric directory for synchronization
_SRC_DIR=xxxx
if [ $? -ne 0 ]; then
	blank_error
	exit 1
fi
# Backup server's symmetric directory for synchronization
_DEST_DIR=xxxx
if [ $? -ne 0 ]; then
	blank_error
	exit 1
fi
