# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

typeset -U PATH path

path=('$HOME/.poetry/bin' $path)
export PATH
fpath+=~/.zfunc

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-readurl \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit wait lucid for \
  atinit"zicompinit; zicdreplay"  \
        zdharma/fast-syntax-highlighting \
      OMZP::colored-man-pages \
  as"completion" \
        OMZP::docker/_docker

: zinit light zdharma/zui
: zinit light zdharma/zplugin-crasis # broke for name change and for loop additions

zinit wait lucid id-as='system-completions' as='completion' \
    atclone='print Installing system completions...; \
      mkdir --parents $ZPFX/funs; \
      command cp --force /usr/share/zsh/functions/^_* $ZPFX/funs; \
      zinit creinstall -q /usr/share/zsh/functions' \
    atload='zicompinit; zicdreplay; \
      fpath=( ${(u)fpath[@]:#/usr/share/zsh/*} ); \
      fpath+=( $ZPFX/funs )' \
    atpull="%atclone" run-atpull for zdharma/null


# pyenv, virtual-env
zinit pack for pyenv
eval "$(pyenv virtualenv-init -)"

# Theame
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Realllly import to put poetry above the pyenv PATH hackery fray.
export PATH="$HOME/.poetry/bin:$PATH"

alias server='python -m SimpleHTTPServer 8000'
alias -g L='| less'
alias -g G='| grep'
alias ls="exa -bh --color=auto"
alias l="ls"      l.='ls -d .*'   la='ls -a'   ll='ls -lbt created'  rm='command rm -i'
alias df='df -h'  du='du -h'      cp='cp -v'   mv='mv -v'      plast="last -20"
alias reload="exec $SHELL -l -i"  grep="command grep --colour=auto --binary-files=without-match --directories=skip"
alias hisg="history G"
alias lsperm="stat -c '%A %a %n'" # List octal form of permissions
alias time='/usr/bin/time -f "%C\nTime: %E real,\t%U user,\t%S sys\nSize: %K memory,\t%t set size,\t%X shared text\nCPU: %P"'
alias mkcd='foo(){ mkdir -p "$1"; cd "$1" }; foo '
alias myip="curl http://ipecho.net/plain; echo"
alias svi='sudo vi'
alias update='sudo apt-get update && sudo apt-get upgrade'
alias apt-get='sudo apt-get'
## get rid of command not found ##
alias cd..='cd ..'
 
## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'


alias ports='netstat -tulanp'

## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'
 
# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

## this one saved by butt so many times ##
alias wget='wget -c'



