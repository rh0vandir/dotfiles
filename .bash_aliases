# QOL
alias ..='cd .. '
alias ...='cd ../.. '
alias o='less'
alias tailf='tail -f '
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias cpv='rsync -ah --info=progress2'
alias lsdisks='lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID,MODEL,SERIAL,REV,PTTYPE'

# colorfull things - use eza or exa if available, fallback to ls with colors
if command -v eza >/dev/null 2>&1; then
    alias l='eza -alF --color=auto'
    alias ls='eza -a --color=auto'
    alias lt='eza --tree --color=auto'
    alias ll='eza -la --color=auto'
elif command -v exa >/dev/null 2>&1; then
    alias l='exa -alF --color=auto'
    alias ls='exa --color=auto'
    alias la='exa -a --color=auto'
    alias lt='exa --tree --color=auto'
    alias ll='exa -la --color=auto'
else
    alias l='ls -alF --color=auto'
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
    alias la='ls -a --color=auto'
    alias lt='ls --human-readable --size -1 -S --classify'
fi

# Logs (only create aliases if the logs exist)
[ -f /var/log/syslog ]      && alias syslog='less /var/log/syslog '
[ -f /var/log/auth.log ]    && alias authlog='less /var/log/auth.log '
[ -f /var/log/dpkg.log ]    && alias dpkglog='less /var/log/dpkg.log '
[ -f /var/log/faillog ]     && alias faillog='less /var/log/faillog '
[ -f /var/log/fail2ban.log ]&& alias fail2banlog='less /var/log/fail2ban.log '
[ -f /var/log/kern.log ]    && alias kernlog='less /var/log/kern.log '
[ -f /var/log/mail.log ]    && alias maillog='less /var/log/mail.log '

# Git
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gcp='git cherry-pick'
alias gr='git rebase'
