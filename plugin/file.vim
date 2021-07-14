" autoread
  " https://github.com/neovim/neovim/issues/1380
  autocmd BufEnter * exec "noautocmd checktime " . bufnr()
  set autoread
  function! AutoReadCallback(...)
    if g:auto_read == 1
      noautocmd silent! checktime
    endif
  endfunction
  let g:auto_read = 1
  autocmd CursorMoved * let g:audo_read = 0
  autocmd CursorHold * let g:audo_read = 1
  call timer_start(1000, 'AutoReadCallback', {'repeat': -1})

" autosave
  function! AutoSave(...) abort
    if mode() != 'n'
      return
    endif
    if getbufvar('%', "&mod")
      try
        w
      catch
      endtry
    endif
    let g:start_saved_timer = 0
  endfunction
  let g:saved_timer = 0
  let g:start_saved_timer = 1
  augroup oh_my_autosave
    autocmd!
    autocmd InsertLeave,TextChanged * let g:start_saved_timer = 1
    autocmd InsertEnter * call timer_stop(g:saved_timer)
    autocmd CursorHold *
          \ if g:start_saved_timer == 1 |
          \   call timer_stop(g:saved_timer) |
          \   let g:saved_timer = timer_start(1000, 'AutoSave', {'repeat': 1}) |
          \ endif
    autocmd BufLeave,TabLeave,WinLeave,VimResized,VimSuspend,FocusLost * silent! wall
  augroup END
