EMACS=`which emacs`
if [[ ! -e /tmp/emacs${UID}/server ]]
then
    # start an emacs daemon
    echo
    $EMACS --daemon
fi

alias emacs="emacsclient -t -a $EMACS \$*"
alias realemacs=$EMACS
alias stopemacs='emacsclient --eval "(progn (save-some-buffers t t) (kill-emacs))"'
