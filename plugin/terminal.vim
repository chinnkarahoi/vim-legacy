let g:term_insert = 0
autocmd BufEnter,BufWinEnter * if &buftype == 'terminal' | let g:term_insert = 1 | endif
silent! autocmd TermEnter * let g:term_insert = 0
silent! autocmd TermOpen * let g:term_insert = 1
autocmd CursorHold *
      \ if g:term_insert == 1 |
      \   let g:term_insert = 0 |
      \   if &buftype == 'terminal' |
      \     startinsert |
      \   endif |
      \ endif
function! SendCdToFilePath(path) abort
  if !isdirectory(a:path)
    return ''
  endif
  return 'command cd ' . a:path . "\<cr>"
endfunction
function! TermReg(...) abort
  let t = getchar()
  if t != 3
    return "\<C-\>\<C-N>\"".nr2char(t).'pi'
  else
    return "\<C-C>"
  endif
endfunction
function! TermKeyWrapper(key, functionToExecute, ...) abort
  if getbufinfo('%')[0]['variables']['term_title'] =~ 'Pending'
    return call(function(a:functionToExecute), a:000)
  else
    return a:key
  endif
endfunction
tnoremap <silent> <expr> <M-l> TermKeyWrapper("\<M-l>", 'SendCdToFilePath', @p)
tnoremap <silent> <expr> <C-r> TermReg()
tnoremap <silent> <M-[> <C-\><C-N>$
tnoremap <silent> <M-j> <c-\><c-n><c-w>w<esc>
tnoremap <silent> <M-k> <c-\><c-n><c-w>W<esc>

tnoremap <silent> <RightDrag> <nop>
tnoremap <silent> <RightMouse> <nop>
tnoremap <silent> <LeftMouse> <nop>
tnoremap <silent> <LeftRelease> <c-\><c-n><LeftMouse><c-w>gf
