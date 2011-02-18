export PATH=/usr/local/bin:$PATH

export EMACS=`which emacs`
alias emacs='emacsclient -t -a "" $*'
alias realemacs=$EMACS
alias stopemacs='emacsclient --eval "(progn (save-some-buffers t t) (kill-emacs))"'
