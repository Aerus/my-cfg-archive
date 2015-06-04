#!/bin/sh
# Usage: upgrade.sh
URLS=upgrade-urls.txt
#DIR=~/Install/links
DIR=/home/Utils/Install/links
# get links
sudo apt-get update
apt-get --print-uris -y -qq dist-upgrade | cut -d\' -f2 >  $DIR/$URLS
#convert unix newline format to windows for windows download managers
sed -i -e 's/$/\r/' $DIR/$URLS
                                 