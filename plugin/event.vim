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

" norm zz
  let g:norm_zz = 0
  func! s:my_norm_zz()
    if g:norm_zz == 1 && g:vim_enter_no_zz == 0
      norm zz
    endif
    let g:norm_zz = 0
    let g:vim_enter_no_zz = 0
  endfunc
  let g:vim_enter_no_zz = 0
  autocmd BufWinEnter,WinNew * let g:norm_zz = 1
  autocmd BufWinLeave,WinClosed * let g:norm_zz = 0
  autocmd VimEnter * let g:vim_enter_no_zz = 1
  autocmd CursorHold * call s:my_norm_zz()

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

" filetype
  function SetFiletype(...) abort
    let cnt = {}
    let max_cnt = 0
    let set_ft = ''
    let winlist = range(1, tabpagewinnr(tabpagenr(), '$'))
    for i in winlist
      let ft = getwinvar(i, '&filetype')
      if &buflisted == 0
        continue
      endif
      if ft == '' || getwinvar(i, 'weak_filetype') == 1
        continue
      endif
      if !has_key(cnt, ft)
        let cnt[ft] = 0
      endif
      let cnt[ft] += 1
      if cnt[ft] > max_cnt
        let max_cnt = cnt[ft]
        let set_ft = ft
      endif
    endfor
    if set_ft != ''
      for i in winlist
        if getwinvar(i, '&filetype') == '' || getwinvar(i, 'weak_filetype') == 1
          let bufnr = winbufnr(i)
          call setbufvar(bufnr, '&filetype', set_ft)
          call setbufvar(bufnr, 'weak_filetype', 1)
        endif
      endfor
    endif
  endfunction
  autocmd CursorHold * call SetFiletype()

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
    if save == 1
      noautocmd silent! wall
      set ei=BufWinEnter
      try
        let v = winsaveview()
        noautocmd write
        edit
        call winrestview(v)
      catch
      finally
        set ei=
      endtry
    endif
  endfunction
  autocmd BufWritePost * call AutoFormatAndOi()
