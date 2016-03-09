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
  python <<EOF
import os
seen = {}
print ":".join(seen.setdefault(p, p)
               for p in os.environ["PATH"].split(":")
               if p not in seen)
EOF
}
export PATH="$(_bashrc_uniq_path)"
