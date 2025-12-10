function _tide_item_jj
    if not command -sq jj; or not jj root --quiet &>/dev/null
        return 1
    end
    set -l log_args --no-graph --color=never --quiet --config ui.progress-indicator=false

    set change_id (jj log $log_args -r '@' -T 'change_id.shortest(8)')
    string match -qr '(?<changes>#*)(?<bookmark>\w+)' \
        (jj log $log_args \
          -r 'closest_bookmark(@)::@' -T '"#" ++ self.bookmarks()')
    set ahead (math (string length $changes) - 1)

    set jj_status (jj log $log_args -r@ -n1 -T '
    separate(" ",
        bookmarks.map(|x| if(
            x.name().substr(0, 10).starts_with(x.name()),
            x.name().substr(0, 10),
            x.name().substr(0, 9) ++ "…")
        ).join(" "),
        tags.map(|x| if(
            x.name().substr(0, 10).starts_with(x.name()),
            x.name().substr(0, 10),
            x.name().substr(0, 9) ++ "…")
        ).join(" "),
        diff.stat().total_added() ++ "+",
        diff.stat().total_removed() ++ "-",
        if(conflict, "conflict"),
        if(divergent, "divergent"),
        if(hidden, "hidden"),
    )' | string trim)
    _tide_print_item jj "$change_id $ahead⇡$bookmark $jj_status"
end
