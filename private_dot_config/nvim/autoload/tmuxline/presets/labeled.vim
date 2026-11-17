" tmuxline's powerline preset, with tmux's @window_label (when set) ahead of
" the window name.
let s:name = '#{?#{@window_label},#{@window_label}: ,}#W'

fun! tmuxline#presets#labeled#get()
  let bar = tmuxline#new()

  call bar.left.add('a', '#S')
  call bar.left.add_left_sep()

  call bar.right.add_right_sep()
  call bar.right.add('y', '%Y-%m-%d')
  call bar.right.add_right_alt_sep()
  call bar.right.add('y', '%H:%M')
  call bar.right.add_right_sep()

  call bar.right.add('z', '#h')

  call bar.win.add('win.dim', '#I')
  call bar.win.add_left_alt_sep()
  call bar.win.add('win', s:name)

  call bar.cwin.add_left_sep()
  call bar.cwin.add('cwin.dim', '#I')
  call bar.cwin.add_left_alt_sep()
  call bar.cwin.add('cwin', s:name)
  call bar.cwin.add_left_sep()

  let bar.options['status-justify'] = 'left'
  let bar.win_options['window-status-activity-style'] = 'none'

  return bar
endfun
