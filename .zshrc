# mbp
# set up a fancy prompt
autoload colors zsh/terminfo
# don't bother checking for $terminfo[colors] > 8 before calling colors
# (to initialize $fg and $bg arrays) -- all terms have color these days
colors

# see "which colors" for more codes
for color in RED REEN YELLOW BLUE MAGENTA CYAN WHITE GREEN BLACK GREY; do
        eval FG_$color='%{$fg[${(L)color}]%}'
        eval BG_$color='%{$bg[${(L)color}]%}'
        eval FG_B_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval BG_B_$color='%{$terminfo[bold]$bg[${(L)color}]%}'
done
FG_NO_COLOR="%{$terminfo[sgr0]%}"

typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}

PR_SET_CHARSET="%{$terminfo[enacs]%}"
PR_SHIFT_IN="%{$terminfo[smacs]%}"
PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
PR_HBAR=${altchar[q]:--}
PR_ULCORNER=${altchar[l]:--}
PR_LLCORNER=${altchar[m]:--}
PR_LRCORNER=${altchar[j]:--}
PR_URCORNER=${altchar[k]:--}


case $TERM in (xterm*|screen)
        set_title_curdir () { print -Pn "\e]0;%n@%m: %~\a" }
        set_title_curexe () { print -Pn "\e]0;%n@%m [$1]\a" }
        ;;
*)
        set_title_curdir () {}
        set_title_curexe () {}
        ;;
esac

precmd ()
{
        prev_return_val=$?

        local TERMWIDTH
        # rprompt has 1 space to the right, so account for that
        ((TERMWIDTH = ${COLUMNS}))

        # ${# gives length; ${(%) inteprets as prompt, ${:-[string]} lets you
        # treat a string as a var       
        local promptsize=${#${(%):-%n@%m --}} # use - as spacer for []
        local pwdsize=${#${(%):-%~}}

        PR_FILLBAR=""
        PR_PWDLEN=""

        if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
                ((PR_PWDLEN=$TERMWIDTH - $promptsize))
        else
                PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
        fi

        set_title_curdir

        # username is red if root
        # no color, bold hostname
        # grey fillbar
        # green brackets around pwd
        # if nonzero exit, red error code display
        PS1="${PR_SET_CHARSET}%(!.${FG_B_RED}.${FG_B_GREEN})\
%n${FG_NO_COLOR}@%B%m%b\
${FG_B_GREY}${PR_SHIFT_IN}${(e)PR_FILLBAR}${PR_SHIFT_OUT}${FG_NO_COLOR}\
${FG_B_GREEN}[${FG_NO_COLOR}\
%${PR_PWDLEN}<...<%~%<<${FG_B_GREEN}\
]${FG_NO_COLOR}
%(0?.${FG_NO_COLOR}.${BG_B_RED}[${prev_return_val}])\
${FG_NO_COLOR}%# "
}

preexec ()
{
        set_title_curexe $1
}

RPS1="(%!)"

MAILCHECK=0

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
# make history work sanely with multiple shells
setopt INC_APPEND_HISTORY
# keep command duration information, etc, in history
# see history -d, -f -and -D
setopt EXTENDED_HISTORY
# keep just 1 copy if you run a command multiple times
setopt HIST_IGNORE_DUPS
# tidy up meaningless blanks
setopt HIST_REDUCE_BLANKS

export EDITOR=vim
export VISUAL=vim
export PAGER=less

setopt CORRECT
setopt NOBEEP

# get good tab completion
autoload -U compinit
compinit

bindkey    "^[[3~"          delete-char
# haven't needed this other term magic yet:
# bindkey    "^[3;5~"         delete-char

bindkey -e
PATH=$PATH:/opt/local/bin
MANPATH=/opt/local/share/man:$MANPATH
alias vim=/opt/local/bin/vim
