# vim: fdm=marker
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# {{{ zcomet
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
    command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

zcomet load romkatv/powerlevel10k #, as:theme, depth:1

zcomet load junegunn/fzf shell completion.zsh key-bindings.zsh
(( ${+commands[fzf]} )) || ~[fzf]/install --bin

zcomet load joshskidmore/zsh-fzf-history-search
zcomet load ael-code/zsh-colored-man-pages
zcomet load zpm-zsh/dircolors-neutral
zcomet load zpm-zsh/ls
zcomet load jsahlen/tmux-vim-integration.plugin.zsh

zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

zcomet compinit
# }}}
# {{{ general settings
setopt histignorealldups sharehistory
setopt autocd

export EDITOR=vim
export VISUAL=vim
export LESS='-R -F'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
# }}}
# {{{ completion
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }}}
# {{{ FZF
export FZF_DEFAULT_COMMAND="rg --files --smart-case --type-add 'idx:*.idx' -T idx -T html -T js"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}
# {{{ aliases
alias rscp="rsync -rah --progress"
[[ -x $(which batcat) ]] || echo "Install 'bat' package"
alias b=batcat
alias bat=batcat
# TODO ubuntu specific
source /etc/zsh_command_not_found || echo "Install 'command-not-found' package"

make() {
    if [[ $@ == "celan" ]]; then
        echo "Schwarze Milch der Frühe wir trinken sie abends"
    else
        command make "$@"
    fi
}
# }}}
# {{{ theme
ZSH_THEME="powerlevel10k"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time)
POWERLEVEL9K_CUSTOM_SUSPENDED_JOBS="jobs | wc -l"
POWERLEVEL9K_CUSTOM_SUSPENDED_JOBS_BACKGROUND="yellow"
POWERLEVEL9K_CUSTOM_SUSPENDED_JOBS_FOREGROUND="blue"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_CARRIAGE_RETURN_ICON=$'\uF810'
POWERLEVEL9K_MODE=nerdfont-complete
POWERLEVEL9K_ROOT_ICON=$'\uF09C'
POWERLEVEL9K_TIME_ICON=$'\uF017'
# }}}
alias luamake=/home/petran/src/lua-language-server/3rd/luamake/luamake
take() {
    if [[ -z $1 ]]; then
        echo "Make a directory and then change to it"
        return 1
    fi
    mkdir -p $1
    cd $1
}

tvpnc_clone() {
    if [[ -z $1 ]]; then
        echo "Usage: tvpnc_clone REPO_NAME"
        return 1
    fi
    git clone git@gitlab2.rscs.rsint.net:tvpnc/$1.git .
}

container() {
    CONTAINER_NAME=base-devel-db

    CONTAINER_RUNNING=$(podman container ls|grep ${CONTAINER_NAME})
    [ -z "${CONTAINER_RUNNING}" ] && podman start ${CONTAINER_NAME}
    DBUS_RUNNING=$(podman exec ${CONTAINER_NAME} ps -A|grep dbus-daemon)
    [ -z "${DBUS_RUNNING}" ] && podman exec ${CONTAINER_NAME} \
        dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

    podman exec -it --workdir=$PWD ${CONTAINER_NAME} bash
}

tvpnc_grep() {
    rg -g '!dependencies/' -g '!local-libs/' $@
}

export PATH=${PATH}:/home/petran/.local/bin
