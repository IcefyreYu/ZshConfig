# ~/.config/zsh/prompt.zsh

autoload -Uz add-zsh-hook

FUNCNEST=10000

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat -p /etc/debian_chroot)
fi

if whence tput >/dev/null && (( $(tput colors 2>/dev/null) >= 8 )); then
  # Prevent Python virtualenv from polluting the prompt
  export VIRTUAL_ENV_DISABLE_PROMPT=1

  eval "$(starship init zsh)"
else
  PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

preexec_title() { print -Pnr -- $'\e]0;$1\a' }
precmd_title() { print -Pnr -- "$TERM_TITLE" }

add-zsh-hook preexec preexec_title
add-zsh-hook precmd precmd_title

