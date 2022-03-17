" yank
  autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}

" cursorline
  if get(g:, 'auto_cursor_line', 0) == 1
    let g:set_cursor_line=0
    augroup oh_my_cursorline
      autocmd!
      autocmd CursorHold * setlocal cursorline
      autocmd InsertEnter,TermEnter * setlocal nocursorline
    augroup END
  endif

" options
  function! MustSet() abort
    set formatoptions -=cro |
  endfunction
  autocmd BufEnter,BufWinEnter,FileType * call MustSet()

" diff
  let g:diff_bufwinenter = 0
  augroup oh_my_diff_enter
    autocmd!
    autocmd BufWinEnter * let g:diff_bufwinenter = 1
    autocmd BufEnter *
          \ if g:diff_bufwinenter == 1 |
          \   let g:diff_bufwinenter = 0 |
          \   if &diff == 1 |
          \     exec "norm zz" |
          \   endif |
          \ endif
  augroup END

" resize
  function! ResizeWin() abort
    let w = winnr()
    exec "1wincmd w"
    wincmd =
    exec w . "wincmd w"
  endfunction
  augroup oh_my_resize
    autocmd!
    autocmd VimResized,TabEnter,WinNew * call ResizeWin()
  augroup END

" auto fmt & oi
  let g:autofmt_filetype = ['go', 'json', 'jsonc']
  let g:auto_import_filetype = ['go']
  function! AutoFormatAndOi() abort
    let save = 0
    if index(g:auto_import_filetype, &filetype) >= 0
      silent! call CocAction('runCommand', 'editor.action.organizeImport')
      let save = 1
    endif
    if index(g:autofmt_filetype, &filetype) >= 0
      silent! call CocAction('format')
      let save = 1
    endif
  endfunction
  autocmd BufWritePost * call AutoFormatAndOi()
