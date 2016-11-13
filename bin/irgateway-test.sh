#!/bin/bash

irw | while read response; do cmd=$(echo $response | awk -F " " '{print $3}'); irsend SEND_ONCE next $cmd; echo $cmd; done
