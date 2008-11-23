# ~/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

[ -z "$PS1" ] && return # If not running interactively, don't do anything

# Enable colors for ls, etc.  Prefer ~/.dir_colors
if [[ -f ~/.dir_colors ]] ; then
	eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
	eval $(dircolors -b /etc/DIR_COLORS)
fi

# disable ^S/^Q flow control
stty -ixon

# bash options
shopt -s cmdhist	# save multi-line commands in history as single line
shopt -s checkwinsize	# update the values of LINES and COLUMNS after each command
shopt -s histappend	# append (not overwrite) the history file
shopt -s extglob	# enable egrep-style pattern matching
shopt -s cdspell	# autocorrects cd misspellings

# set variables

# add ~/bin to PATH if it exists
if [ -d ~/bin ] ; then
   PATH=~/bin:"${PATH}"
fi

# command history settings
alias hist='history | grep $1' # search cmd history
export HISTFILE="$HOME/.bash_history_`hostname`" # Hostname appended to bash history filename
export HISTSIZE=10000 # the bash history should save n commands
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=erasedups # erase duplicate cmds (also avail: ignorespace, ignoreboth, ignoredups)
# don't append the following to history: consecutive duplicate
# commands, ls, bg and fg, and exit
HISTIGNORE='\&:fg:bg:ls:pwd:cd ..:cd ~-:cd -:cd:jobs:set -x:ls -l:ls -l'
HISTIGNORE=${HISTIGNORE}':%1:%2:htop:top:mutt:sshfs*:ssh*:shutdown*'
export HISTIGNORE

#export MAILPATH=${HOME}/mail/inbox"?You've got mail"'!' # Mail prompt
#export MAILPATH=/var/spool/mail/$USER"?You've got mail"'!' # Mail prompt
export BROWSER="links '%s' &"

# define editors and pagers
# worst-case choices
export EDITOR=/usr/bin/vi
export PAGER=/bin/more
# best-case choices
my_editor=vim
my_pager=less
type $my_editor >/dev/null 2>&1 && export EDITOR=$my_editor
type $my_pager >/dev/null 2>&1 && export PAGER=$my_pager

# bash completion
complete -cf sudo	# sudo tab-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# general aliases
alias ls='ls --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto -F'
alias ll='ls -lh'
alias la='ls -a'
alias p="sudo pacman-color"
alias yogurt="yaourt"	#if English is your native tongue ;)
alias exit="clear; exit"
alias x="startx"
alias pacsearch="pacman-color -Sl | cut -d' ' -f2 | grep " #lets you search through all available packages simply using 'pacsearch packagename'
alias pacup='sudo pacman-color -Syu'
alias pac='sudo pacman-color -S'

alias alan="ssh -i /home/delor/.ssh/alan_rsa bpiech@alan"	# lazy
alias proxy-alan="ssh -i /home/delor/.ssh/alan_rsa bpiech@alan -D 8080"	# lazy
alias liza="ssh bpiech@liza"	# lazy

alias pacs="color_pacsearch"
color_pacsearch () {
	echo -e "$(pacman -Ss $@ | sed \
	-e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
	-e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
	-e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
	-e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
}

#PS1='[\u@\h \W]\$ '
PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
export OOO_FORCE_DESKTOP=gnome

# Kolorowanie less do obslugi man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# bash functions

# extract archives -- usage: extract <file>
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar e $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# create archives -- usage: roll <foo.tar.gz> ./foo ./bar
roll () {
    FILE=$1
    case $FILE in
        *.tar.bz2) shift && tar cjf $FILE $* ;;
        *.tar.gz) shift && tar czf $FILE $* ;;
        *.tgz) shift && tar czf $FILE $* ;;
        *.zip) shift && zip $FILE $* ;;
        *.rar) shift && rar $FILE $* ;;
    esac
}

rmspaces() {
ls | while read -r FILE
do
    mv -v "$FILE" `echo $FILE | tr ' ' '_' `
done
}

makepasswords() {
    perl <<EOPERL
        my @a = ("a".."z","A".."Z","0".."9",(split //, q{#@,.<>$%&()*^}));
        for (1..10) {
            print join "", map { \$a[rand @a] } (1..rand(3)+10);
            print qq{\n}
        }
EOPERL
}

