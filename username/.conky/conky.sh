#!/bin/sh
killall conky
sleep 5
conky -d -c ~/.conky/conky_sys &
conky -d -c ~/.conky/conky_top &
#sleep 5
#conky -d -c ~/.conky/conkyforecast &

