#!/bin/bash

irw | while read response;
do
	cmd=$(echo $response | awk -F " " '{print $3}')
	irsend SEND_START next $cmd; sleep 0.25
	irsend SEND_STOP next $cmd; ret=$?
	logger -i -s "inceIR" "cmd:$cmd - stat:$ret"
done
