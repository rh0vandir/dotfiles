# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Add timestamps to history
export HISTTIMEFORMAT="%Y-%m-%d %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Show Git branch in prompt with status
parse_git() {
  local branch
  local status=""
  
  # Get current branch
  branch=$(git branch 2>/dev/null | grep '*' | sed 's/* //')
  
  if [ -n "$branch" ]; then
    # Check for staged changes (added but not committed)
    if ! git diff --cached --quiet 2>/dev/null; then
      status="${status} ★"  # Staged files
    fi
    
    # Check for unstaged changes (modified but not staged)
    if ! git diff --quiet 2>/dev/null; then
      status="${status} ●"  # Unstaged changes
    fi
    
    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
      status="${status} ○"  # Untracked files
    fi
    
    # Check if ahead/behind remote
    local ahead_behind
    ahead_behind=$(git rev-list --count --left-right @{u}...HEAD 2>/dev/null)
    if [ -n "$ahead_behind" ]; then
      local ahead=$(echo "$ahead_behind" | cut -f1)
      local behind=$(echo "$ahead_behind" | cut -f2)
      if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
        status="${status}↕"  # Diverged
      elif [ "$ahead" -gt 0 ]; then
        status="${status}↑"  # Local commits not pushed
      elif [ "$behind" -gt 0 ]; then
        status="${status}↓"  # Behind remote
      fi
    else
      # No upstream branch set, check if we have any commits
      local commit_count=$(git rev-list --count HEAD 2>/dev/null)
      if [ "$commit_count" -gt 0 ]; then
        status="${status}⚠"  # Has commits but no upstream
      fi
    fi
    
    # Return branch name with status indicators
    if [ -n "$status" ]; then
      echo "(${branch}${status})"
    else
      echo "($branch)"
    fi
  fi
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h \[\033[01;33m\]\w\[\033[01;32m\] $(parse_git) \[\033[01;35m\]\$ \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
# for local customizations, like custom paths
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

# Autojump - load safely to avoid syntax errors
if [ -s /usr/share/autojump/autojump.sh ]; then
    . /usr/share/autojump/autojump.sh 2>/dev/null || true
elif [ -s /usr/share/autojump/autojump.bash ]; then
    . /usr/share/autojump/autojump.bash 2>/dev/null || true
fi

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
#export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export HISTTIMEFORMAT="%Y-%m-%d %T "  # add timestamps to history
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
function hstrnotiocsti {
    { READLINE_LINE="$( { </dev/tty hstr ${READLINE_LINE}; } 2>&1 1>&3 3>&- )"; } 3>&1;
    READLINE_POINT=${#READLINE_LINE}
}
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind -x '"\C-r": "hstrnotiocsti"'; fi
export HSTR_TIOCSTI=n

