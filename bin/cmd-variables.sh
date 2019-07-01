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
fi
# Backup server's symmetric directory for synchronization
_DEST_DIR='/ tmp/rsync_test/html/'
if [ $? -ne 0 ]; then
	blank_error
fi
