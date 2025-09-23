set -gx NPM_PACKAGES ~/.npm-packages
fish_add_path $NPM_PACKAGES/bin
set -gx NODE_PATH $NPM_PACKAGES/lib/node_modules
set -gx -a MANPATH $NPM_PACKAGES/share/man

# Ensure the empty element is present in MANPATH
if test -n "$MANPATH[1]"; set -gx MANPATH '' $MANPATH; end
