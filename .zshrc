#
# ~tdo/.zshrc
#
# Jan 24, 2000
#

cdpath=(.)
umask 022
fignore=(.o ~)
setenv() { export $1=$2 }  # csh compatibility
hosts=(chris3 chris4 yulius4 chad3 web1 bfields2 gbenson2 kwilson2 netops{1,2}.corp.xfire.com db1 xfire-stage-{1,2} xfire-stagemysql-1 xfire-mysql-{1,2,3} xfire-utility-{1,2})
chosts=(chris3: chris4: yulius4: chad3: web1: bfields2: gbenson2: kwilson2: netops{1,2}.corp.xfire.com: db1: xfire-stage-{1,2}: xfire-stagemysql-1: xfire-mysql-{1,2,3}: xfire-utility-{1,2}:)
#PROMPT='<%B%n%b> <%~> %m%% '    # default prompt
#PROMPT='[%B%t%b] %h [%c]:%m%# ' # Old Mike standard
PROMPT='%B%t%b-%m%# '
RPROMPT=' %h:%B%c%b'
export PATH="$HOME/bin:/usr/ucb:/sbin:/usr/sbin:/usr/local/bin:/usr/bin:/bin:/usr/games:/usr/openwin/bin:/usr/X11/bin:/usr/dt/bin:/usr/etc:/opt/mysql/product/5.0.45/bin"
TZ=US/Pacific

source ~/.aliases

export MAILCALL='You have new mail.'
export YOUSAID='In %C you wrote:'
export ATTRIBUTION='%f wrote:'
export LESS=-cEX4M
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -t"
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

    xterm )
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
