declare -A PROMPT_DIRREPL  # An associative array of CWD replacements.
PROMPT_DIRREPL=([$HOME]="~") # Replace $HOME with ~ by default.

prompt_pwd() {
  for repl in "${!PROMPT_DIRREPL[@]}"; do
    local NWD="${PWD/#$repl/${PROMPT_DIRREPL[$repl]}}"
    if [ "$NWD" != "$PWD" ]; then
      echo "$NWD"
      return
    fi
  done
  echo "$PWD"
}

_escaped () {
    echo -n "\\[$1\\]"
}

_setprompt() {
  # escape codes alone
  local REVON_='\033[7m'
  local REVOFF_='\033[27m'
  local UNDERON_='\033[4m'
  local UNDEROFF_='\033[24m'
  local BLACK_='\033[30m'
  local RED_='\033[31m'
  local GREEN_='\033[32m'
  local BROWN_='\033[33m'
  local BLUE_='\033[34m'
  local MAGENTA_='\033[35m'
  local CYAN_='\033[36m'
  local WHITE_='\033[37m'
  # single command esacpes
  local REVON=$(_escaped "$REVON_")
  local REVOFF=$(_escaped "$REVOFF_")
  local UNDERON=$(_escaped "$UNDERON_")
  local UNDEROFF=$(_escaped "$UNDEROFF_")
  local BLACK=$(_escaped "$BLACK_")
  local RED=$(_escaped "$RED_")
  local GREEN=$(_escaped "$GREEN_")
  local BROWN=$(_escaped "$BROWN_")
  local BLUE=$(_escaped "$BLUE_")
  local MAGENTA=$(_escaped "$MAGENTA_")
  local CYAN=$(_escaped "$CYAN_")
  local WHITE=$(_escaped "$WHITE_")

  local RESET=$(_escaped '\033[0m')
  local PATHSTART=$(_escaped "${UNDERON_}${RED_}")
  local PATHEND=$(_escaped "${UNDEROFF_}${BLUE_}")
  local PSx="${BLUE}[$USER@$HOSTNAME:${PATHSTART}\$(prompt_pwd)${PATHEND}]\\n${RED}\\\$${RESET} "

  case $TERM in
    xterm* | rxvt* | gnome | konsole | vt??? | screen* | tmux* | alacritty)
      # enable UTF-8 support
      export LANG=en_US.UTF-8
      echo -ne '\033%G'
      # Set window terminal title
      export PROMPT_COMMAND='echo -ne "\033]2;$USER@$HOSTNAME:$(prompt_pwd)\007"'
      export PS1="$PSx"
      ;;
    linux)
      export PS1="$PSx"
      ;;
    *)
      export PS1='[\h:\w]\$ '
      ;;
  esac
}

_setprompt
unset _escaped _setprompt
