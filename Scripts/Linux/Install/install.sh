#!/bin/sh
# Usage: install.sh <package1> ... <packageN>
URLS=install-urls.txt
#LIST=install-list.txt
#DIR=~/Install/links
DIR=/home/Utils/Install/links
# get links
apt-get --print-uris -y -qq install $@ | cut -d\' -f2 >> $DIR/$URLS
# print names of requested packages to file
#echo $@ > $DIR/$LIST
#convert unix newline format to windows for windows download managers
sed -i -e 's/$/\r/' $DIR/$URLS
                                 