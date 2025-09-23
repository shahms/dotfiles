function fish_prompt
  string join '' -- (set_color blue) "[$USER@" (prompt_hostname) ':' (prompt_pwd) "]"
  string join '' -- (set_color red) '$ ' (set_color normal)
end
