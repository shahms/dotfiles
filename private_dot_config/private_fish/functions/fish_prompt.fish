function fish_prompt
    string join '' -- (set_color blue) "[$USER@" (prompt_hostname) ':' (set_color red) (prompt_pwd) (set_color blue) "]"
    string join '' -- (set_color red) '$ ' (set_color normal)
end
