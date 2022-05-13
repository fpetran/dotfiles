# vim: fdm=marker

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# autoload -Uz promptinit
# promptinit
# prompt adam1

setopt histignorealldups sharehistory
setopt autocd

export EDITOR=vim
export VISUAL=vim
export LESS='-R'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

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
# {{{ plugins
# [[ ! -d ${HOME}/.zgen ]] && git clone https://github.com/tarjoilija/zgen.git ${HOME}/.zgen
# source "${HOME}/.zgen/zgen.zsh"
# if ! zgen saved; then
#     zgen load zsh-users/zsh-syntax-highlighting
#     zgen load ael-code/zsh-colored-man-pages
#     zgen load rjcoelho/zsh-dircolors

#     zgen load zsh-users/zsh-history-substring-search
#     zgen load junegunn/fzf

#     zgen load romkatv/powerlevel10k powerlevel10k

#     zgen save
# fi

[[ ! -d ~/.zplug ]] && git clone https://github.com/b4b4r07/zplug ~/.zplug
source ~/.zplug/init.zsh

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "zsh-users/zsh-history-substring-search"
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf

zplug "ael-code/zsh-colored-man-pages"
zplug "zdharma/fast-syntax-highlighting"
zplug "zpm-zsh/material-colors"
zplug "zpm-zsh/ls"

zplug "jsahlen/tmux-vim-integration.plugin.zsh"

# zplug "jeffreytse/zsh-vi-mode"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load
# }}}

# FZF
export FZF_DEFAULT_COMMAND="rg --files --smart-case --type-add 'idx:*.idx' -T idx -T html -T js"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# theme
ZSH_THEME="powerlevel10k"
# {{{ aliases
alias rscp="rsync -rah --progress"
[[ -x $(which batcat) ]] || echo "Install 'bat' package"
alias b=batcat
# }}}
# {{{ keobuilder
function keobuilder() {
    BS_VERSION="2.2.0-snapshot"
    BS_TARBALL=keo_build_system-${BS_VERSION}-build.tar.gz
    if [[ ! -e ./keo_builder.py ]]; then
        wget http://artifactory.local.keo-connectivity.de/artifactory/native-snapshot-local/keo_build_system/${BS_VERSION:u}/${BS_TARBALL}
        tar xzvf ${BS_TARBALL}
        rm -f ${BS_TARBALL}
    fi
    ./keo_builder.py $@
}
# }}}
# TODO ubuntu specific
source /etc/zsh_command_not_found || echo "Install 'command-not-found' package"

make() {
    if [[ $@ == "celan" ]]; then
        echo "Schwarze Milch der Frühe wir trinken sie abends"
    else
        command make "$@"
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir_writable dir vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time)
# POWERLEVEL9K_CUSTOM_SUSPENDED_JOBS="jobs | wc -l"
# POWERLEVEL9K_CUSTOM_SUSPENDED_JOBS_BACKGROUND="yellow"
# POWERLEVEL9K_CUSTOM_SUSPENDED_JOBS_FOREGROUND="blue"
# POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# # F810
# POWERLEVEL9K_CARRIAGE_RETURN_ICON=$'\uF810'
# POWERLEVEL9K_MODE=nerdfont-complete
# POWERLEVEL9K_ROOT_ICON=$'\uF09C'
# POWERLEVEL9K_TIME_ICON=$'\uF017'

reset_dns() {
    sudo resolvectl dns enp0s3 172.18.10.1
}
