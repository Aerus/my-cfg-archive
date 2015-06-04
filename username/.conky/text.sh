vnstat -m | grep "date +"%b"" | awk '{print $3 $4}'
#vnstat -m | grep "`date +"%b '%y"`" | awk '{print $3 $4}'