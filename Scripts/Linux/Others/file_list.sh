#!/bin/bash

lsof | awk '{usage[$2 " " $1]++} END {for (idx in usage) {print usage[idx] " " idx; }}' | sort -n >> file_list.txt

echo "Total number open files" `lsof | wc -l` >> file_list.txt
