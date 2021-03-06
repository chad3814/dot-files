#
# ~tdo/.zshrc
#
# Jan 24, 2000
#

cdpath=(.)
umask 022
ulimit -n 2560
fignore=(.o ~)
setenv() { export $1=$2 }  # csh compatibility
hosts=(stage prod utility stage.grokker.com grokker.com utility.gr0k.us atlas atlas.corp.grokker.com polyphemus polyphemus.corp.grokker.com)
chosts=(stage: prod: utility: stage.grokker.com: grokker.com: utility.gr0k.us: atlas: atlas.corp.grokker.com: polyphemus: polyphemus.corp.grokker.com:)
#PROMPT='<%B%n%b> <%~> %m%% '    # default prompt
#PROMPT='[%B%t%b] %h [%c]:%m%# ' # Old Mike standard
#PROMPT='%B%t%b-%m%# '
#RPROMPT=' %h:%B%c%b'
export PATH="$HOME/bin:/opt/local/bin:/Applications/Aquamacs.app/Contents/MacOS/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/bin:/bin:/usr/X11/bin:/opt/mysql/product/5.0.45/bin:/usr/local/git/bin"
TZ=US/Pacific

if [ -e ~/.aliases ] ; then
    source ~/.aliases
fi

export MAILCALL='You have new mail.'
export YOUSAID='In %C you wrote:'
export ATTRIBUTION='%f wrote:'
export LESS=-cEXMz-2R
export EDITOR="emacsclient"
export VISUAL="emacsclient"
export FLEX_HOME=/opt/flex_sdk_3.5

export PATH=$FLEX_HOME/bin:$PATH
export PAGER=`which less`
export READNULLCMD=`which less`

bindkey -e       # emacs key bindings
bindkey '^[;' spell-word

stty erase '^H'

compctl -x 'r[-man,---]' -g '*.man *.[1-9]' -- nroff
compctl -g '*(-/)' cd
compctl -k hosts telnet rlogin rsh ncftp ftp ping traceroute rstat slogin ssh
compctl -f -k chosts rcp scp

###
# Experimental stuff taken from Steve Leung's .cshrc
#####

case $TERM in

    sun-cmd )
	alias winheader='echo -n "]l$host : ${PWD}\";echo -n "]L$host\"'
    ;;

    xterm* )
	alias winheader='echo -n "]2;"$host" : ${PWD}]1;"$host""'
    ;;

    * )
	alias winheader='echo -n ""'
    ;;
esac

ls () {
    /bin/ls -aCF $* | ${PAGER:-more}
}

cd () {
    builtin cd $*;
    winheader;
}

winheader

wiki() {
    lookup=${1// /_}
    dig +short txt $lookup.wp.dg.cx
}

# git branch completion
autoload -U compinit && compinit

# Prompts...
autoload -U colors && colors
autoload -Uz vcs_info

local reset white green red yellow
reset="%{${reset_color}%}"
white="%{$fg[white]%}"
green="%{$fg_bold[green]%}"
red="%{$fg[red]%}"
yellow="%{$fg[yellow]%}"

# Set up VCS_INFO
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:*' max-exports 5

zstyle ':vcs_info:git*' formats "[${yellow}%r${white}-${green}%b%u%c${reset}]" "%8.8i:${yellow}" "%m" "%S" "%r"
zstyle ':vcs_info:git*' actionformats "[${yellow}%r${white}-${green}%b%u%c${white}|${red}%a${reset}]" "${red}%8.8i${reset}:${yellow}%S${reset}" "%m" "%S" "%r"

zstyle ':vcs_info:git*:*' stagedstr "${green}+${white}"
zstyle ':vcs_info:git*:*' unstagedstr "${red}!${white}"

# zstyle ':vcs_info:*+*:*' debug true

zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name --abbrev-ref 2>/dev/null)}

    if [[ -n ${remote} ]] ; then
	# split remote into remote-name and branch
	rbranch=${remote#*/}
	remote_name=${remote%%/*}

        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | awk '{print $NF}')

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | awk '{print $NF}')

	if [[ "$remote_name" = "origin" ]] ; then
	    if [[ "$rbranch" = "${hook_com[branch]}" ]] ; then
		remote=""
	    else
		remote=$rbranch
	    fi
	fi
        hook_com[branch]="${hook_com[branch]} ${white}[${yellow}${remote}${green}+${ahead}${white}/${red}-${behind}${white}]"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        hook_com[misc]=$(git stash list 2>/dev/null | wc -l)
    fi
}

# Executed before each prompt
function precmd {
    vcs_info
    setprompt
}

function setprompt() {
    local infoline

    # first look to see if we're not on the local machine
    [[ -n $SSH_CLIENT ]] && infoline=( "${infoline}%m " )

    # add the time
    infoline=( "${infoline}%B%t%b" )

    # pull in the git info
    [[ -n ${vcs_info_msg_0_} ]] && infoline+=( "${vcs_info_msg_0_}" )

    ### Finally, set the prompt
    PROMPT="${infoline}%# $reset"

    # handle the right prompt
    [[ -n ${vcs_info_msg_3_} ]] && [[ ${vcs_info_msg_3_} = '.' ]] && infoline=( "${vcs_info_msg_4_}" ) || infoline=( "${vcs_info_msg_3_}" )
    [[ -n ${vcs_info_msg_1_} ]] && RPROMPT=" ${vcs_info_msg_1_}$infoline${reset}" || RPROMPT=' %h:%B%c%b'
    [[ -n ${vcs_info_msg_2_} ]] && RPROMPT=" ${red}${vcs_info_msg_2_}\$ ${white}${vcs_info_msg_1_}$infoline${reset}"
}

eval $(thefuck --alias)

export NVM_DIR="/Users/chad/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$HOME/.yarn/bin:$PATH"

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
