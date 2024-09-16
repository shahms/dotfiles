_install_terminfo() {
  local kind="${1:-$TERM}"
  # If we already know about TERM, we're done.
  if infocmp "$kind" > /dev/null 2>&1; then
    return 0
  fi
  # Else, attempt to install terminfo into the local db.
  find ~/.local/share/terminfo -maxdepth 1 -mindepth 1 -name '*.info' |
    while read info; do
      if !grep -q "^${kind}|" "$info"; then
        # Skip info files without the current terminal.
        continue
      fi
      if tic -xe "$kind" "$info"; then
        return 0
      fi
    done
  return 1
}

_fix_term() {
  # Attempt to install the terminfo for the current terminal.
  if ! _install_terminfo; then
    local BASE_TERM="${TERM%-*}"
    # If that failed, see if there is a "base" TERM and use that.
    if [[ "$BASE_TERM" != "$TERM" ]] && _install_terminfo "$BASE_TERM"; then
      TERM="$BASE_TERM"
    fi
  fi
}

_fix_term
unset _install_terminfo _fix_term
