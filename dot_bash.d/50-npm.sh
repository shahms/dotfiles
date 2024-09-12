export NPM_PACKAGES="$HOME/.npm-packages"
prepend PATH "$NPM_PACKAGES/bin"
prepend NODE_PATH "$NPM_PACKAGES/lib/node_modules"
# Add npm man paths to the front.
prepend MANPATH "$NPM_PACKAGES/share/man"
# Then ensure it ends with a ':' so that `manpath` appends the
# configured paths automatically.
export MANPATH="${MANPATH%:}:"
export NODE_PATH
