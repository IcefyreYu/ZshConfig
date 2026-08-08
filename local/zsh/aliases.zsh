# Better ls
alias ls='eza --icons'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# Force zsh to show the complete history
alias history="history 0"

# =========================================================
# Core utilities
# =========================================================

eval "$(dircolors -b)"
export LS_COLORS="$LS_COLORS:ow=30;44:"

alias grep='rg --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='difft'
alias df='duf -style unicode'

function apt() {
	if [[ $1 == "up" ]]; then
		sudo apt update && sudo apt upgrade
	else
		sudo apt "$@"
	fi
}

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -'  # -- prevents - being parsed as a flag; cd - jumps to previous directory

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	LIBVA_DRIVER_NAME=disable command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

# =========================================================
# Editor
# =========================================================

alias vim='nvim'
alias spyder=/opt/spyder-6/envs/spyder-runtime/bin/spyder

# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# =========================================================
# Video
# =========================================================

alias stream='mpv av://v4l2:/dev/video4 --fullscreen --demuxer-lavf-o=input_format=mjpeg,framerate=30 --profile=low-latency --untimed'

# =========================================================
# /opt App
# =========================================================

alias bninja=/opt/binaryninja/binaryninja
