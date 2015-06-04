#!/bin/sh

cat /dev/ttyUSB2 & echo AT+CUSD=1,*100#,15 > /dev/ttyUSB2; sleep 3 
#*100#
#*111*52579977712621#