#!/bin/bash

## metamail is the package
#OUT=president
#OUT=lisa.freitag-consulting.de
#OUT=hafre@messwagen42.de
#OUT=217.24.218.177
OUT=zem@fnordpol.de
#OUT=wenzel.president.eu.org
SSH=ssh
#SSH=./ssh-lisa.sh

if [ -e $HOME/Mail/.outgoing ] 
then
	echo -n Send spooled mail....
	(
		echo "which mimencode > /dev/null || exit 1"
		cat $HOME/Mail/.outgoing
	)| $SSH $OUT || exit 1
	rm $HOME/Mail/.outgoing
	echo done.
else
	echo no mail...
fi
