wjoin () {
  local usage="usage: wjoin <sep> <arg1> ..."
  local sep=${1:?$usage}
  shift

  local IFS=$sep
  echo "$*"
}

wremove () {
  if [ "$#" -lt "2" -o "$#" -gt "3" ]; then
    echo "usage: wremove <word> <string> [<sep>]"
    return 1;
  fi

  local word=$(echo "$1" | sed -e 's|/|\\\/|g')
  local values=$2
  if [ "$3" ]; then
    local IFS=$3
    for part in $word; do
      values=$(echo "$values" |
               sed -re "s/^$part$IFS|$IFS$part($IFS)|$IFS$part\$/\\1/g")
    done
    echo "$values"
  else
    echo "$values" | sed -re "s/$word//g"
  fi
}

append () {
  if [ "$#" -lt "2" -o "$#" -gt "3" ]; then
    echo "usage: append <varname> <values> [<sep>]"
    return 1;
  fi

  local varname=$1
  local extra=$2
  local sep=${3:-':'}

  local value=$(eval "echo \$$varname")
  local value=$(wjoin "$sep" $(wremove "$extra" "$value" "$sep") $extra)
  eval "$varname='$value'"
}

prepend () {
  if [ "$#" -lt "2" -o "$#" -gt "3" ]; then
    echo "usage: prepend <varname> <values> [<sep>]"
    return 1;
  fi

  local varname=$1
  local extra=$2
  local sep=${3:-':'}

  local value=$(eval "echo \$$varname")
  local value=$(wjoin "$sep" $extra $(wremove "$extra" "$value" "$sep"))
  eval "$varname='$value'"
}

shellquote () {
  sed -e "s/'/'\"'\"'/g;s/\(.*\)/'\1'/"
}
