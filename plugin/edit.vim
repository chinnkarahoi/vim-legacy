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
  inoremap <c-b> <left>
  inoremap <c-f> <right>
  inoremap <silent> <M-b> <c-c>:norm b<cr>i
  inoremap <silent> <M-f> <c-c>:norm e<cr>a
  inoremap <silent> <c-e> <c-c>:norm $<cr>a
  inoremap <silent> <c-a> <c-c>:norm ^<cr>i

  imap <silent> <M-BS> <c-g>u<c-w>
  inoremap <silent> <c-w> <c-g>u<c-w>
  inoremap <silent> <c-u> <c-g>u<c-u>

  cnoremap <c-a> <home>
  cnoremap <c-b> <left>
  cnoremap <c-f> <right>
  cnoremap <M-w> <c-w>
  cnoremap <M-BS> <c-w>
  cnoremap <M-b> <S-Left>
  cnoremap <M-f> <S-Right>
  cnoremap <c-j> <c-n>
  cnoremap <c-k> <c-p>

