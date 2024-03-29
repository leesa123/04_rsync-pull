#!/bin/bash

usage() {
cat <<_EOT_
Usage:
        $0 [The One of the Options]

Description:
        This is a tool to synchronize by pulling method. 
        We recommend to use '--dry-run' or '--dry-run-diff' before use '--run' or '--run-diff'          

Options:
        --dry-run       Perform a trial run with no changes mode.
                        You can check target files from the log file.
                        (recommend)

        --dry-run-diff  It has the some functionality as '--dry-run'.
                        Additionly, you can use checksum to check data differences. not mod-time & size
                        You can check target files from the log file.

        --run           It is not trial mode. Actually synchronized.
                        The target to be synchronized can be confirmed in '--dry-run'. 
                        
        --run-diff      It has the some functionality as '--run'.
                        The target to be synchronized can be confirmed in '--dry-run-diff'.

_EOT_
exit 1
}

blank_error() {
cat <<_EOT_
Error:  
        $1 in the cmd-variables.conf contains a space or tab character

Risk:
        Mistakes result in unintended results being copied. This can cause fatal errors on Linux OS system.
        Check it again please.

Incorrect ex:

        [_SRC_DIR]         [_DEST_DIR]

        / var/www/html/ -> /var/www/html/
        /var/lib/mysql/ -> / var/lib/mysql/

_EOT_
exit 1
}

ngdir_error() {
cat <<_EOT_
Error:
        Variables [$1] : $2 in the cmd-variables.conf contains NG-value 

Risk:
        Mistakes result in unintended results being copied. This can cause fatal errors on Linux OS system.
        Check it again please.

_EOT_
exit 1

}
