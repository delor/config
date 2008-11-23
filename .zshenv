#!/bin/zsh
#
# Dircolors...
eval `dircolors -b ~/.dircolors`

# Kill flow control
if tty -s ; then
    stty -ixon
    stty -ixoff
fi

# Exports
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/opt/mozilla/bin:/opt/java/jre/bin:/home/gig/bin:/home/gig/hacks
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LOCALE=en_US.UTF-8
export BROWSER=firefox3
export MAIL=/home/gig/.mail/default
export MAILCHECK=0
export PACKAGER="Gigamo <gigamo@gmail.com>"
export CVS_RSH="ssh"
export OOO_FORCE_DESKTOP="gnome"
export EDITOR=vim
export VISUAL=vim
export HISTCONTROL=ignoredups
export IGNOREEOF=3

# watch for people
watch=(notme)                   # watch for everybody but me
LOGCHECK=300                    # check every 5 min for login/logout activity

# Make framebuffer colors look like in X
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0222222" #black
    echo -en "\e]P8222222" #darkgrey
    echo -en "\e]P1803232" #darkred
    echo -en "\e]P9982b2b" #red
    echo -en "\e]P25b762f" #darkgreen
    echo -en "\e]PA89b83f" #green
    echo -en "\e]P3aa9943" #brown
    echo -en "\e]PBefef60" #yellow
    echo -en "\e]P4324c80" #darkblue
    echo -en "\e]PC2b4f98" #blue
    echo -en "\e]P5706c9a" #darkmagenta
    echo -en "\e]PD826ab1" #magenta
    echo -en "\e]P692b19e" #darkcyan
    echo -en "\e]PEa1cdcd" #cyan
    echo -en "\e]P7ffffff" #lightgrey
    echo -en "\e]PFdedede" #white
    clear #for background artifacting
fi

bindkey "\e[1~" beginning-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[3~" delete-char

bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history

WATCHFMT="%B->%b %n has just %a %(l:tty%l:%U-Ghost-%u)%(m: from %m:)"

# Automatically start X and log out after when logging into vc/1
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/vc/1 ]]; then
  dbus-launch startx >& .myXLog
  logout
fi
