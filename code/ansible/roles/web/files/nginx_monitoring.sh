#!/bin/bash

RETRIES=0

while [ $RETRIES -eq 3 ]
do 
    /usr/bin/curl -S -o /dev/null http://localhost
    EXIT_CODE=$?
    if [ ! $EXIT_CODE == 0 ]; then
      echo "fail"
      RETRIES=$(( $RETRIES + 1 ))
    else
      exit 0
    fi   
done
logger -p syslog.warn "Restarting nginx process"
/usr/bin/systemctl start nginx
/usr/bin/curl -S -o /dev/null http://localhost
EXIT_CODE_AFTER_RESTART=$?
if [ ! $EXIT_CODE_AFTER_RESTART == 0 ]; then
   logger -p syslog.err "nginx couldn't be able to restart. Quit retrying"
fi
