#!/bin/bash
#####
##### iphitus' screenshot script :D
#####
#####RENAME THIS FILE EXTENSION FROM .txt to .sh
#####-edit as needed
#####-execute from a terminal or run dialog with
#####sh info.sh

# screenshot dir
ssdir="$HOME/screenie/"
# screenshot description
ssdesc="$HOME/screenie"
# screenshot format
ss=`date +%d%m%Y`.png

# Extra hdd details?
hdddetails=0
# Use comments file?
comments=0
# Automatically grab gnome theme info
autognome=1

#echo
#date
echo
echo "Kernel:         `uname -r`"
#echo "Distro:         `cat /etc/*release`"
. /etc/lsb-release
echo "Distro:         $DISTRIB_ID $DISTRIB_RELEASE $DISTRIB_CODENAME"
echo "Uptime:         `uptime |cut --delimiter=" " -f 2`"
echo ___________________________________________________________________
echo "CPU:           `grep "model name" /proc/cpuinfo|cut --delimiter=":" -f 2`" 
echo "Speed:         `grep "cpu MHz" /proc/cpuinfo|cut --delimiter=":" -f 2` mhz"
echo "Bogomips:      `grep "bogomips" /proc/cpuinfo|cut --delimiter=":" -f 2` bogomips"
echo ___________________________________________________________________
let memtotal=`grep "MemTotal" /proc/meminfo|cut -c 12-22|indent -i0`/1024
echo "Memory Total:   $memtotal mb"
let memfree=`grep "MemFree" /proc/meminfo|cut -c 12-22|indent -i0`/1024
let memcache=`grep "Cached" /proc/meminfo|cut -c 12-22|indent -i0`
let memcache=$memcache/1024
let memfreetotal=$memfree+$memcache
echo "Memory Free:    $memfreetotal mb"
echo ___________________________________________________________________
#echo "Graphics:       `grep "Product" /proc/fb0/vbe_info|cut --delimiter=" " -f 5`" 
cat /proc/driver/nvidia/version
echo ___________________________________________________________________
if [ $autognome == 1 ]; then
  echo "GTK2:           		`gconftool-2 --get /desktop/gnome/interface/gtk_theme`"
  echo "Metacity:                       `gconftool-2 --get /apps/metacity/general/theme`"
  echo "Icons:          		`gconftool-2 --get /desktop/gnome/interface/icon_theme`"
#  echo "Titlebar Font:      		`gconftool-2 --get /apps/metacity/general/titlebar_font`"
  echo "Application Font:  		`gconftool-2 --get /desktop/gnome/interface/font_name`"
  echo "Terminal Font:  		`gconftool-2 --get /apps/gnome-terminal/profiles/Default/font`"
fi
sleep 4
scrot $ss
echo
exit 0
