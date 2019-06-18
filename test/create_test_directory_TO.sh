#!/bin/bash

if [ -e /opt/rsync_pull/log ]; then
        echo "" > /dev/null
else
        mkdir /opt/rsync_pull/log
fi
touch -d "1 days ago" /opt/rsync_pull/log/rsync_20190613.log
touch -d "2 days ago" /opt/rsync_pull/log/rsync_20190612.log
touch -d "3 days ago" /opt/rsync_pull/log/rsync_20190611.log
touch -d "4 days ago" /opt/rsync_pull/log/rsync_20190610.log
touch -d "5 days ago" /opt/rsync_pull/log/rsync_20190609.log
touch -d "6 days ago" /opt/rsync_pull/log/rsync_20190608.log
touch -d "7 days ago" /opt/rsync_pull/log/rsync_20190607.log
touch -d "8 days ago" /opt/rsync_pull/log/rsync_20190606.log
touch -d "9 days ago" /opt/rsync_pull/log/rsync_20190605.log
touch -d "10 days ago" /opt/rsync_pull/log/rsync_20190604.log
touch -d "11 days ago" /opt/rsync_pull/log/rsync_20190603.log
touch -d "12 days ago" /opt/rsync_pull/log/rsync_20190602.log
touch -d "13 days ago" /opt/rsync_pull/log/rsync_20190601.log

# create resource directory
if [ -e /var/www/html ]; then
        echo "" > /dev/null
else
        mkdir /var/www/html
fi
touch /var/www/html/index.php
touch /var/www/html/local-adminer-SJs8wL1FQ.php
touch /var/www/html/logo_rescuenow_642_83_navy.png
touch /var/www/html/wp-activate.php
touch /var/www/html/wp-comments-post.php
touch /var/www/html/wp-content
touch /var/www/html/wp-links-opml.php
touch /var/www/html/wp-mail.php
touch /var/www/html/wp-snapshots
touch /var/www/html/license.txt
touch /var/www/html/local-phpinfo.php
touch /var/www/html/logorsq.png
touch /var/www/html/wp-admin
touch /var/www/html/wp-config-sample.php
touch /var/www/html/wp-cron.php
touch /var/www/html/wp-load.php
touch /var/www/html/wp-settings.php
touch /var/www/html/wp-trackback.php
touch /var/www/html/local-adminer-BJ8k3PHSG.php
touch /var/www/html/login22.html
