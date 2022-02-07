# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

for rcfile in $(ls ~/.bash.d/??-*.sh | sort -n); do
  source "$rcfile"
done

_bashrc_uniq_path() {
  declare -A seen
  local new_path
  IFS=":"
  for entry in "$PATH"; do
    if [[ "${seen[$entry]}" ]]; then
      continue
    else
      seen[$entry]=1
      append new_path "$entry"
    fi
  done
  echo "$new_path"
}
export PATH="$(_bashrc_uniq_path)"
