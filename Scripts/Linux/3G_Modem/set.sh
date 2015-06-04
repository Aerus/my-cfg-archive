#!/bin/sh

cat /dev/ttyUSB2 & echo AT+CUSD=1,*111*74291686976120#,15 > /dev/ttyUSB2; sleep 3 
#*111*52579977712621#