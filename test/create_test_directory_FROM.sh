#!/bin/bash

# create resource directory
if [ -e /tmp/rsync_test/html ]; then
        echo "" > /dev/null
else
        mkdir -p /tmp/rsync_test/html
fi
touch -d "1 days ago" /tmp/rsync_test/html/index.php
touch -d "2 days ago" /tmp/rsync_test/html/local-adminer-SJs8wL1FQ.php
touch -d "3 days ago" /tmp/rsync_test/html/logo_rescuenow_642_83_navy.png
touch -d "4 days ago" /tmp/rsync_test/html/wp-activate.php
touch -d "5 days ago" /tmp/rsync_test/html/wp-comments-post.php
touch -d "6 days ago" /tmp/rsync_test/html/wp-content
touch -d "7 days ago" /tmp/rsync_test/html/wp-links-opml.php
touch -d "8 days ago" /tmp/rsync_test/html/wp-mail.php
touch -d "9 days ago" /tmp/rsync_test/html/wp-snapshots
touch -d "10 days ago" /tmp/rsync_test/html/license.txt
touch -d "11 days ago" /tmp/rsync_test/html/local-phpinfo.php
touch -d "12 days ago" /tmp/rsync_test/html/logorsq.png
touch -d "13 days ago" /tmp/rsync_test/html/wp-admin
touch -d "14 days ago" /tmp/rsync_test/html/wp-config-sample.php
touch -d "15 days ago" /tmp/rsync_test/html/wp-cron.php
touch -d "16 days ago" /tmp/rsync_test/html/wp-load.php
touch -d "17 days ago" /tmp/rsync_test/html/wp-settings.php
touch -d "18 days ago" /tmp/rsync_test/html/wp-trackback.php
touch -d "19 days ago" /tmp/rsync_test/html/local-adminer-BJ8k3PHSG.php
touch -d "20 days ago" /tmp/rsync_test/html/login22.html
