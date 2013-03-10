#!/bin/bash
OUTBOX=~/Mail/.outgoing

# metamail is the package 

which mimencode > /dev/null || exit 1 

echo "mimencode -u << EOF-MAILTEXT-DARKZONE-QWERTZ | /usr/lib/sendmail -oi -oem $*" >> $OUTBOX
mimencode >> $OUTBOX
echo EOF-MAILTEXT-DARKZONE-QWERTZ >> $OUTBOX
