#!/bin/bash

if [ -e /opt/rsync-pull/log ]; then
        echo "" > /dev/null
else
        mkdir -p /opt/rsync-pull/log
fi
touch -d "1 days ago" /opt/rsync-pull/log/rsync_20190613.log
touch -d "2 days ago" /opt/rsync-pull/log/rsync_20190612.log
touch -d "3 days ago" /opt/rsync-pull/log/rsync_20190611.log
touch -d "4 days ago" /opt/rsync-pull/log/rsync_20190610.log
touch -d "5 days ago" /opt/rsync-pull/log/rsync_20190609.log
touch -d "6 days ago" /opt/rsync-pull/log/rsync_20190608.log
touch -d "7 days ago" /opt/rsync-pull/log/rsync_20190607.log
touch -d "8 days ago" /opt/rsync-pull/log/rsync_20190606.log
touch -d "9 days ago" /opt/rsync-pull/log/rsync_20190605.log
touch -d "10 days ago" /opt/rsync-pull/log/rsync_20190604.log
touch -d "11 days ago" /opt/rsync-pull/log/rsync_20190603.log
touch -d "12 days ago" /opt/rsync-pull/log/rsync_20190602.log
touch -d "13 days ago" /opt/rsync-pull/log/rsync_20190601.log

# create resource directory
if [ -e /tmp/rsync_test/html ]; then
        echo "" > /dev/null
else
        mkdir -p /tmp/rsync_test/html
fi
touch /tmp/rsync_test/html/index.php
touch /tmp/rsync_test/html/local-adminer-SJs8wL1FQ.php
touch /tmp/rsync_test/html/logo_rescuenow_642_83_navy.png
touch /tmp/rsync_test/html/wp-activate.php
touch /tmp/rsync_test/html/wp-comments-post.php
touch /tmp/rsync_test/html/wp-content
touch /tmp/rsync_test/html/wp-links-opml.php
touch /tmp/rsync_test/html/wp-mail.php
touch /tmp/rsync_test/html/wp-snapshots
touch /tmp/rsync_test/html/license.txt
touch /tmp/rsync_test/html/local-phpinfo.php
touch /tmp/rsync_test/html/logorsq.png
touch /tmp/rsync_test/html/wp-admin
touch /tmp/rsync_test/html/wp-config-sample.php
touch /tmp/rsync_test/html/wp-cron.php
touch /tmp/rsync_test/html/wp-load.php
touch /tmp/rsync_test/html/wp-settings.php
touch /tmp/rsync_test/html/wp-trackback.php
touch /tmp/rsync_test/html/local-adminer-BJ8k3PHSG.php
touch /tmp/rsync_test/html/login22.html
