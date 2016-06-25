# Basics {{{
alias ls="ls --color=always"
alias l="ls -lhF"
alias ll="ls -alhF"
alias vi="vim"
alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v"
alias mkdir="mkdir -pv"
# }}}

# Server {{{
alias restart-nginx="supervisorctl restart nginx"
alias restart-php-fpm="supervisorctl restart php-fpm"
# }}}

# Git {{{
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gsts="git stash show"
alias gf="git fetch"
# }}}

# vim: foldmethod=marker foldlevel=0
