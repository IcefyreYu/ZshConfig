# ~/.config/zsh/prompt.zsh

autoload -Uz add-zsh-hook

FUNCNEST=10000

# =========================================================
# Greeting Message
# =========================================================

_greeting_once() {
	print Welcome $USERNAME!
	date "+%Y.%m.%d. %H:%M:%S %Z%n%n"
	fastfetch
	print

	add-zsh-hook -d precmd _greeting_once
}

add-zsh-hook precmd _greeting_once

# =========================================================
# Prompt
# =========================================================

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat -p /etc/debian_chroot)
fi

if whence tput >/dev/null && (($(tput colors 2>/dev/null) >= 8)); then
	eval "$(starship init zsh)"
else
	PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi

# Transient Prompt
DISABLE_TRANSIENT=1

set-long-prompt() {
	PROMPT='$(starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="${STARSHIP_CMD_STATUS:-}" --pipestatus="${STARSHIP_PIPE_STATUS[*]:-}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
	RPROMPT='$(starship prompt --right --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="${STARSHIP_CMD_STATUS:-}" --pipestatus="${STARSHIP_PIPE_STATUS[*]:-}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
	PROMPT2="$(starship prompt --continuation)"
}

set-short-prompt() {
	PROMPT='$(starship module character)'
}

accept-line() {
	set-short-prompt
	print -Pn "\e[1A\e[G\e[1M"
	zle .reset-prompt
	zle .accept-line
}

if [ "$DISABLE_TRANSIENT" = 0 ]; then
	add-zsh-hook precmd set-long-prompt
	zle -N accept-line
fi

# Newline for Prompt
add-newline() {
	if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
		_NEW_LINE_BEFORE_PROMPT=1
	else
		print
	fi
}

add-zsh-hook precmd add-newline

# =========================================================
# Title
# =========================================================

case "$TERM" in
xterm* | rxvt* | Eterm | aterm | kterm | gnome* | alacritty)
	TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
	;;
*) ;;
esac

preexec_title() { print -Pnr -- $'\e]0;$1\a'; }
precmd_title() { print -Pnr -- "$TERM_TITLE"; }

add-zsh-hook preexec preexec_title
add-zsh-hook precmd precmd_title
