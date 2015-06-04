#!/bin/bash

case "$1" in

m)  echo "Mount TC Volume"
    truecrypt -t /path_to_tc_file /media/mount_path -k /path_to_key_file --protect-hidden=no
    ;;
u)  echo  "Unmount TC Volume"
    truecrypt -d
    ;;
*) echo "Signal number $1 is not processed"
   ;;
esac