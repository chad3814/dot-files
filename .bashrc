# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PATH="/usr/local/mono-1.1.9.1_1/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/mono-1.1.9.1_1/lib/pkgconfig:$PKG_CONFIG_PATH"
export MANPATH="/usr/local/mono-1.1.9.1_1/share/man:$MANPATH"

