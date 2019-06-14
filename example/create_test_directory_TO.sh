#!/bin/bash

# create log directory
if [ -e ~/rsync_log ]; then
	echo "" > /dev/null	
else
	mkdir ~/rsync_log
fi
touch -d "1 days ago" ~/rsync_log/rsync_20190613.log
touch -d "2 days ago" ~/rsync_log/rsync_20190612.log
touch -d "3 days ago" ~/rsync_log/rsync_20190611.log
touch -d "4 days ago" ~/rsync_log/rsync_20190610.log
touch -d "5 days ago" ~/rsync_log/rsync_20190609.log
touch -d "6 days ago" ~/rsync_log/rsync_20190608.log
touch -d "7 days ago" ~/rsync_log/rsync_20190607.log
touch -d "8 days ago" ~/rsync_log/rsync_20190606.log
touch -d "9 days ago" ~/rsync_log/rsync_20190605.log
touch -d "10 days ago" ~/rsync_log/rsync_20190604.log
touch -d "11 days ago" ~/rsync_log/rsync_20190603.log
touch -d "12 days ago" ~/rsync_log/rsync_20190602.log
touch -d "13 days ago" ~/rsync_log/rsync_20190601.log

# create resource directory
if [ -e ~/rsync_home ]; then
	echo "" > /dev/null	
else
	mkdir ~/rsync_home
fi
touch ~/rsync_home/index.php
touch ~/rsync_home/local-adminer-SJs8wL1FQ.php
touch ~/rsync_home/logo_rescuenow_642_83_navy.png
touch ~/rsync_home/wp-activate.php
touch ~/rsync_home/wp-comments-post.php
touch ~/rsync_home/wp-content
touch ~/rsync_home/wp-links-opml.php
touch ~/rsync_home/wp-mail.php
touch ~/rsync_home/wp-snapshots
touch ~/rsync_home/license.txt
touch ~/rsync_home/local-phpinfo.php
touch ~/rsync_home/logorsq.png
touch ~/rsync_home/wp-admin
touch ~/rsync_home/wp-config-sample.php
touch ~/rsync_home/wp-cron.php
touch ~/rsync_home/wp-load.php
touch ~/rsync_home/wp-settings.php
touch ~/rsync_home/wp-trackback.php
touch ~/rsync_home/local-adminer-BJ8k3PHSG.php
touch ~/rsync_home/login22.html
