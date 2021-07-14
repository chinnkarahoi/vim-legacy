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

" emacs
  inoremap <c-n> <down>
  inoremap <c-p> <up>
  inoremap <c-b> <left>
  inoremap <c-f> <right>
  inoremap <c-e> <end>
  inoremap <silent> <c-a> <c-r>="<c-o>^"<cr>
  inoremap <silent> <M-b> <c-r>="<c-o>b"<cr>
  inoremap <silent> <M-f> <c-r>="<c-o>e"<cr><right>
  inoremap <silent> <M-u> <c-r>="<c-o>u"<cr>
  inoremap <silent> <M-U> <c-r>="<c-o><c-r>"<cr>
  inoremap <silent> <c-w> <c-g>u<c-w>
  inoremap <silent> <c-u> <c-g>u<c-u>
  inoremap <silent> <M-BS> <c-g>u<c-w>
  inoremap <silent> <M-d> <c-r>="<c-\><c-o>\"ide"<cr>
  cnoremap <c-a> <home>
  cnoremap <c-b> <left>
  cnoremap <c-f> <right>
  cnoremap <M-w> <c-w>
  cnoremap <M-BS> <c-w>
  cnoremap <M-b> <S-Left>
  cnoremap <M-f> <S-Right>
  cnoremap <c-j> <c-n>
  cnoremap <c-k> <c-p>
  nnoremap <silent> <c-j> <cr>
  nnoremap <silent> <c-k> k

