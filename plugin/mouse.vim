function! MapDoubleClick() abort
  if g:map_double_click != 1
    return
  endif
  if &filetype == 'help' || &filetype == 'man'
    nmap <silent><buffer> <cr> <c-]>
  endif
  let d = maparg("<cr>", "n", v:false, v:true)
  if has_key(d, 'buffer') && d.buffer != 0
    nmap <silent><buffer> <2-LeftMouse> <cr>
  endif
endfunction
nnoremap <silent><2-LeftMouse> <nop>
let g:map_double_click = 0
augroup oh_my_mouse
  autocmd!
  autocmd BufEnter,FileType * let g:map_double_click = 1
  autocmd CursorHold * call MapDoubleClick()
augroup END
vnoremap <silent> <RightMouse> y
nnoremap <silent> <RightMouse> <esc><LeftMouse>:Translate<cr>
inoremap <silent> <RightMouse> <esc><LeftMouse>:Translate<cr>
