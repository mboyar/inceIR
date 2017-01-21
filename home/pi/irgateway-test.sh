#!/bin/bash

SERVER=m21.cloudmqtt.com
PORT=XXXX
KULL=XXXX
PASS=XXXX
TITLE1=XXXX

LOG_PREFIX=$(basename $0 .sh)

function lircSend(){

	local cmd=$1
	local logSrc=$2
	irsend SEND_START next $cmd; sleep 0.25
        irsend SEND_STOP next $cmd; ret=$?
        logger -t $LOG_PREFIX  "system.user:$(whoami) - source:$logSrc - command:$cmd - stat:$ret"
}

#subprocess_1
(
irw | while read response;
do
	cmd=$(echo $response | awk -F " " '{print $3}')
	lircSend $cmd "irw"
done
) &
pidIrw=$!; echo $pidIrw > /tmp/$LOG_PREFIX-irw.pid

#sub_process_2
(
mosquitto_sub -h $SERVER -p $PORT -t $TITLE1 -u $KULL -P $PASS | while read response;
do

	if [[ $response == "volup" ]]; then

		lircSend "KEY_VOLUMEUP" "mosquitto_sub"

	elif [[ $response == "voldown" ]] ; then

		lircSend "KEY_VOLUMEDOWN" "mosquitto_sub"

	elif [[ $response == "mute" ]]; then

                lircSend "KEY_MUTE" "mosquitto_sub"
	fi
	

done
)&
pidMosq1=$!; echo $pidMosq1 >/tmp/$LOG_PREFIX-mosq1.pid

