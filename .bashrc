# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [ -f /etc/profile ]; then
     . /etc/profile;
fi

PS1="\[\e[1;32m\]\u\[\e[1;37m\]@\[\e[1;33m\]\h\[\e[1;34m\]\w\[\e[1;31m\]\$(date +%H:%M) \$ \[\e[0m\]"
#PS1='\[\e[31m\][\u@\h]\[\e[1;34m\]\w\[\e[0m\]\$ '

export PATH=$PATH:/home/mensjes/pepijno/bin
export PATH=$PATH:/usr/lib64/openmpi/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/openmpi/lib

export PATH=$PATH:~/wwwdebug/www/
export PATH=$PATH:~/wwwdebug/www/vendor/bin/

export PATH=$PATH:~/.local/bin/

setxkbmap -option compose:lwin
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#~/bin/./matrix

if [ $(expr index "$-" i) -eq 0 ]; then
	return
fi

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi
#
## set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#xterm-color)
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    ;;
#*)
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#    ;;
#esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#    ;;
#*)
#    ;;
#esac

xhost local:root &> /dev/null

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
#if [ "$TERM" != "dumb" ]; then
#    eval "`dircolors -b`"
#    alias ls='ls --color=auto'
#    #alias dir='ls --color=auto --format=vertical'
#    #alias vdir='ls --color=auto --format=long'
#fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

unset MAILCHECK

alias psa='ps aux'

mesg n

alias dibs='finger'

alias ls='ls --color=auto'

alias vuurvos='firefox'

export EDITOR=vim

function be()
{
	if [[ $# != 1 ]]; then
		echo "Gebruik: be [username]"
		return 1
	fi
	USER=$1
	/usr/bin/id $USER &>/dev/null
	if [[ $? != 0 ]]; then
		echo "Account $? bestaat niet"
		return 2
	fi
	/usr/bin/finger "$1" | /usr/bin/head -n2 
	sudo -u root /bin/su $1;
	return $?
}

function tex2pdf()
{
	EXTENSION=${1##*.}
	NAME=${1%.*}
	OPEN=$2
	if [[ $EXTENSION != "tex" ]]; then
		echo "Geef een tex-bestand"
		return 1
	fi
	if [[ $2 != 1 ]]; then
		OPEN=evince
	fi
	pdflatex $NAME.tex
	$OPEN $NAME.pdf 2> /dev/null
}

function listauthors()
{
	LINES=$(git --no-pager log --pretty=format:"%an")
	while [[ ! -z $LINES ]]; do
		line=$(echo -e "$LINES" | head -1)
		echo -n "${line}: "
		var=$(echo -e "$LINES" | grep -i "$line" | wc -l)
		echo $var
		LINES=$(echo -e "$LINES" | sed "/${line}/d")
	done
}

function authors()
{
	git shortlog -s -n --all
}

#while [ true ]
#do
#  sleep 5
#  gnome-terminal -x bash -c  "echo '___________             .__         .__         .__   
#\__    ___/______  ____ |  |   ____ |  |   ____ |  |  
#  |    |  \_  __ \/  _ \|  |  /  _ \|  |  /  _ \|  |  
#  |    |   |  | \(  <_> )  |_(  <_> )  |_(  <_> )  |__
#  |____|   |__|   \____/|____/\____/|____/\____/|____/'; read -n1" 
#done &

disp=`echo $DISPLAY`
export DISPLAY=$disp

function dev-tmux()
{
	tmux new-session -s Pep -d 'cmatrix; bash'
	#tmux split-window -v 'cmatrix'
	tmux attach -t Pep -2
}

if [[ -z ${TMUX} ]]; then
	tmux attach -t Pep || tmux -2 new-session -s Pep;
else
	matrix
	#cmatrix -u 6 -b -s
fi


#SCREENREGEXP='^screen[A-Za-z0-9._%+-]*'
#SESSIONNAME='sessie'
## Auto-screen
#if [[ "$TERM" =~ $SCREENREGEXP ]]; then
#	ISSCREENTERM=1
#else
#	ISSCREENTERM=0
#fi
#if [[ -n "$PS1" && "$ISSCREENTERM" = 0 ]]; then
#	/usr/bin/screen -d -R -S "$SESSIONNAME"
#elif [[ -n "$PS1" ]]; then
#	if [[ "$HOSTNAME" != "$SSHEXTERN" &&\
#		  "$HOSTNAME" != "$SQUARE" &&\
#		  -z "$SSH_TTY" ]]; then
#		if [[ "$ISSCREENTERM" = 0 ]]; then
#			# On another workstation (except square) locally
#	  			/usr/bin/screen -d -R -S "$SESSIONNAME"
#			# ssh -X $SSHEXTERN
#			# /bin/false
#		fi
#	fi
#fi

function git-up()
{
	echo "                        ______          _____________
                      <((((((\\\\\\       /             \\
                      /      . }\\      |   GIT UP!   |
                      ;--..--._|)      |    LAWL!    |
    (\\                '--/\\--'  )      \\_____________/
     \\\\               | '-'  ;'|  ____/
      \\\\              . -==- .-|
       \\\\              \\.__.'   \\--._
       [\\\\         __.--|       //  _/'--.
       \\ \\\\      .'-._ ('-----'/ __/      \\
        \\ \\\\    /   __>|      | '--.       |
         \\ \\\\   |  \\   |     /    /       /
          \\ '\\ /    \\  |     |  _/       /
           \\  \\      \\ |     | /        /
            \\  \\     \\        /"
	git stash
	git svn rebase
	git stash apply
}

function git-down()
{
	echo "                        ______          _____________
                      <((((((\\\\\\       /             \\
                      /      . }\\      |  GIT DOWN!  |
                      ;--..--._|)      |    LAWL!    |
    (\\                '--/\\--'  )      \\_____________/
     \\\\               | '-'  ;'|  ____/
      \\\\              . -==- .-|
       \\\\              \\.__.'   \\--._
       [\\\\         __.--|       //  _/'--.
       \\ \\\\      .'-._ ('-----'/ __/      \\
        \\ \\\\    /   __>|      | '--.       |
         \\ \\\\   |  \\   |     /    /       /
          \\ '\\ /    \\  |     |  _/       /
           \\  \\      \\ |     | /        /
            \\  \\     \\        /"
	git pull
	git push
}

alias sl='ls'

alias griep='grep -sirn'

cat ~/.headers/$(ls ~/.headers | sort -R | tail -1)

function replace-newline()
{
	sed ':a;N;$!ba;s/\n/ /g' $1
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
