" back forth
  function! AutoMoveSwitchForth()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    if line_start == line('.') && column_start == col('.')
      norm W
    else
      norm E
    endif
  endfunction
  function! AutoMoveSwitchBack()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    if line_start == line('.') && column_start == col('.')
      norm B
    else
      norm BBiw
    endif
  endfunction
  inoremap <M-h> <esc>vB
  inoremap <M-l> <esc>vE
  vnoremap <silent> <M-h> <esc>:<c-u>exec "norm gv"\|call AutoMoveSwitchBack()<cr>
  vnoremap <silent> <M-l> <esc>:<c-u>exec "norm gv"\|call AutoMoveSwitchForth()<cr>
