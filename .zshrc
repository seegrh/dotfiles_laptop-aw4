#scratch# Oh-My-Zsh
 export ZSH=/home/ether/.oh-my-zsh
#ZSH_THEME="powerline"    #kardan agnoster af-magic bira clean candy gentoo terminalparty
#ZSH_THEME="agnoster"    #bullet-train gnzh kardan agnoster af-magic bira clean candy gentoo terminalparty
#ZSH_THEME="robbyrussell"
ZSH_THEME="bureau"
#ZSH_THEME="arrow"
#ZSH_THEME="af-magic"
#ZSH_THEME="suvash"

#POWERLINE_RIGHT_A="date"
#POWERLINE_RIGHT_A="exit-status"
#POWERLINE_FULL_CURRENT_PATH="true"
#POWERLINE_SHOW_GIT_ON_RIGHT="true"
#POWERLINE_DATE_FORMAT="%D{%d-%m}"
#POWERLINE_HIDE_HOST_NAME="true"
#POWERLINE_DETECT_SSH="true"
#POWERLINE_GIT_CLEAN="✔"
#POWERLINE_GIT_DIRTY="✘"
#POWERLINE_GIT_ADDED="%F{green}✚%F{black}"
#POWERLINE_GIT_MODIFIED="%F{blue}✹%F{black}"
#POWERLINE_GIT_DELETED="%F{red}✖%F{black}"
#POWERLINE_GIT_UNTRACKED="%F{cyan}✭%F{black}"
#POWERLINE_GIT_RENAMED="➜"
#POWERLINE_GIT_UNMERGED="═"
#POWERLINE_RIGHT_A_COLOR_FRONT="black"
#POWERLINE_RIGHT_A_COLOR_BACK="red"

# Colors.
red='\e[0;31m'
RED='\e[1;31m'
green='\e[0;32m'
GREEN='\e[1;32m'
yellow='\e[0;33m'
YELLOW='\e[1;33m'
blue='\e[0;34m'
BLUE='\e[1;34m'
purple='\e[0;35m'
PURPLE='\e[1;35m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Default Programs
#export NMON=cmknt
export EDITOR="vim"
export PAGER="less"
export BROWSER="qutebrowser"
export BROWSERCLI="w3m"
export MOVPLAY="mpv"
export PICVIEW="feh"
export SNDPLAY="mpv"
export TERMINAL="uxterm"
export PULSE_LATENCY_MSEC=60
#export TERM="xterm-256color"

# File Extensions
for ext in html org php com net no;    do alias -s $ext=$BROWSER; done
for ext in txt tex py PKGBUILD;        do alias -s $ext=$EDITOR; done
for ext in png jpg gif;            do alias -s $ext=$PICVIEW; done
for ext in mpg wmv avi mkv;        do alias -s $ext=$MOVPLAY; done
for ext in wav mp3 ogg;            do alias -s $ext=$SNDPLAY; done

########################################################
######################## ALIASES ####################### 
########################################################

# System
alias Shutdown='sudo shutdown -P now'
alias Suspend='sudo pm-suspend'
#alias Suspend='sudo systemctl suspend'
alias Hibernate='hibernate'		#uses sys-power/hibernate-script
alias Stat='uname -a;systemd-analyze time;wc -l /lib/modules/$(uname -r)/modules.order;lsinitcpio -a /boot/initramfs-linux.img'
alias keys='xev'
#alias unblock-wireless='rfkill unblock all && ifconfig set wlp6s0 up'
#alias toggle-wifi='sudo ifconfig wlp6s0 down && sudo ifconfig wlp6s0 up'
#alias audit='lynis --auditor MoJo'

# Mount Encrypted Drives Manually
alias OpenData='sudo cryptsetup --type luks open /dev/sdbe hdd6t'
alias MountData='sudo mount /dev/mapper/hdd6t /mnt/hdd6t'

# Systemd
# check for errors: sudo systemctl --failed
# check for errors in log files: sudo journalctl -p 3 -xb

# Git
alias cdG='cd ~/Git'
alias GitStatus='git status -u no'
alias GitCommit='git commit -m'

# Configs
alias Config='cd ~/.config'
#alias Background='~/.config/awesome/themes/ether/wall.jpg'

# Fonts
alias Fonts='fc-cache -vf ~/.fonts'
alias font-check='echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"'

# SSH

## Flash iso to usb drive
#dd bs=4M if=/path/to/archlinux.iso of=/dev/sdb status=progress && sync

## Packages
#alias extract='dtrx'
alias gz='tar -xzf'
alias xz='tar -xJf'
alias bz='tar -xvjf'
alias bz2='tar -jxvf'

## Arch
alias UU='sudo pacman -Syyu'
#alias UU='packer -Syyu && rm /tmp/off.updates && rm /tmp/aur.updates'
#alias UU='packer -Syyu'
alias UUA='yaourt -Syyua --devel'
#alias Cleanup='sudo pacman -Rns $(pacman -Qtdq)'
#alias P='packer --noconfirm'
alias PI='pacman -S --noconfirm'
alias PR='pacman -Rs'
alias Y='yaourt'
#alias YY='yaourt-gui'
#alias pac='sudo pacman -S'
#alias pac-r='sudo pacman -R'
alias Log='tail -f /var/log/pacman.log'
alias Unlock='sudo rm /var/lib/pacman/db.lck'

## Awesome 
alias eA='cd ~/.config/awesome && vim rc.lua'
#alias eW='cd ~/.config/awesome && vim wi.lua'
alias eT='cd ~/.config/awesome/themes/ether-aw4-bluecat && vim theme.lua' 
alias cdA='cd ~/.config/awesome'
#alias cdD='cd ~/.config/awesome/PROFILES/Default'
#alias cdM='cd ~/.config/awesome/PROFILES/msjche'
alias cdT='cd ~/.config/awesome/themes'

## Tmux
#alias TM='~/.tmuxgo'
#alias eTM='vim ~/.tmux.conf'

## Directories
alias space='ncdu'
alias space-color='cdu'
alias ll='ls -l'
alias la='ls -ltra'
alias l='ls'
alias C='clear'
alias se='sudo vim'
alias e='vim'
#alias home='cd ~'
alias ..='cd ..'
alias ...='cd ...'
alias ....='cd ....'
alias .....='cd .....'
alias k='exit'
#alias te='trash-empty'
#alias tl='trash-list'
#alias del='trash-put'
#alias tr='trash-rm'
#alias lsTrash='ls ~/.local/share/Trash/files/'
#alias cdTrash='cd ~/.local/share/Trash/files/'
alias lD='ls ~/Downloads'
alias D='cd ~/Downloads'

## X Resources Stuff
alias eX='vim ~/.Xresources'
alias XTR='xrdb -merge ~/.Xresources'

## Zsh Stuff
alias eZ='vim ~/.zshrc'
alias Z='source ~/.zshrc'

## Vim Stuff
alias eV='vim ~/.vimrc'
alias e='vim'

## Net
#alias googs='googler $1'
alias NM='sudo /etc/init.d/NetworkManager restart'
#alias WW='wicd-curses'
#alias hogs='sudo nethogs wlp6s0'
#alias net-driftnet='echo "see pics from other computers on network" && sudo driftnet -i wlp6s0'
#alias net-ettercap='echo "set up interface to capture network data" && sudo ettercap -TQM arp -i wlp6s0//'
#alias net-snarf='echo "see which websites others on network are visiting" && sudo snarf -i wlp6s0|cut -d\" -f4'
#alias net-scan='sudo arp-scan -l -I wlp6s0'
#alias net-stat='netstat -t -v -c -ee'
#alias net-traf='sudo iptraf-ng'
#alias net-bmon='bmon'
#alias net-nmap='nmap -v -sn 191.168.1.0/24'
#alias net-fping='fping -c1 -gds 192.168.1.0/24 2>&1| egrep -v "ICMP|xmt"'
#alias net-dump='sudo tcpdump -i wlp6s0'
#alias net-wifi='wavemon'
#alias net-nmon='nmon'
#alias net-speedtest='speedtest-cli'
#alias net-graph='speedometer -r wlp6s0 -t wlp6s0'
#alias graph='nbwmon -i wlp6s0'
#alias iftop='sudo iftop -p -n'
#alias slurm='slurm -i wlp6s0'

## Power
#alias bat='acpi'
#alias bat-all='acpi -V'
#alias Power='sudo powertop'

###########################################################
########################### ZSH ###########################
###########################################################

# enable vim mode on commmand line
#bindkey -v

# no delay entering normal mode
# https://coderwall.com/p/h63etq
# https://github.com/pda/dotzsh/blob/master/keyboard.zsh#L10
# 10ms for key sequences
#KEYTIMEOUT=1

# show vim status
# http://zshwiki.org/home/examples/zlewidgets
#function zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

# add missing vim hotkeys
# fixes backspace deletion issues
# http://zshwiki.org/home/zle/vi-mode
#bindkey -a u undo
#bindkey -a '^R' redo
#bindkey '^?' backward-delete-char
#bindkey '^H' backward-delete-char

# history search in vim mode
# http://zshwiki.org./home/zle/bindkeys#why_isn_t_control-r_working_anymore
#bindkey -M viins '^s' history-incremental-search-backward
#bindkey -M vicmd '^s' history-incremental-search-backward

###########################################################
######################## FUNCTIONS ######################## 
###########################################################

# Awesome Logout
Logout() { echo 'awesome.restart()' | awesome-client ;}

## Check Internal and External IPs ##
my-ip() {
        echo "--------------- Network Information ---------------"
	# newer system like arch
	ip addr | awk '/global/ {print $1,$2}' | cut -d\/ -f1
	ip addr | awk '/global/ {print $3,$4}'
	ip addr | awk '/ether/ {print $1,$2}'
	ip addr | awk '/scope link/ {print $1,$2}' | cut -d\/ -f1
	# older system like debian
    ifconfig | awk '/inet addr/ {print $1,$2}' | awk -F: '{print $1,$2}'
    ifconfig | awk '/Bcast/ {print $3}' | awk -F: '{print $1,$2}'
    ifconfig | awk '/inet addr/ {print $4}' | awk -F: '{print $1,$2}'
    ifconfig | awk '/HWaddr/ {print $4,$5}'
    ifconfig | awk '/Scope:Link/ {print $1,$3}' | cut -d\/ -f1
    echo Current IP $(curl -s http://checkip.dyndns.org/ | grep -o "[[:digit:].]\+")
    echo "---------------------------------------------------"
}

## Google Translate Functions ##
#say() { 
#
#	mplayer -user-agent Mozilla \
#	"http://translate.google.com/translate_tts?ie=UTF-8&tl="$1"&q=$(echo "$@" \
#	| cut -d ' ' -f2- | sed 's/ /\+/g')" > /dev/null 2>&1 ;}
#
#say-translation() { 
#
#	lang=$1
#	trans=$(translate {=$lang} "$(echo "$@" | cut -d ' ' -f2- | sed 's/ /\+/g')" )	
#	echo $trans
#	mplayer -user-agent Mozilla \
#	"http://translate.google.com/translate_tts?ie=UTF-8&tl=$lang&q=$trans" > /dev/null 2>&1 ;}

##########################################################
########################## MODS ########################## 
##########################################################

#plugins=(git archlinux vi-mode themes zsh-completions color-command)
#plugins=(git archlinux themes zsh-completions color-command)
source ~/Git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/oh-my-zsh.sh

