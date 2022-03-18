" GoyoWrapper
  function! GoyoWrapper(functionToExecute, ...) abort
    let goyo = 0
    if exists("#goyo")
      Goyo
      let goyo = 1
    endif
    call call(function(a:functionToExecute), a:000)
    if goyo == 1
      Goyo
      norm zz
    endif
  endfunction

" Smart Split Windows
  function! MySplit(...)
    doautocmd BufLeave
    if !exists('w:my_split_type')
      let w:my_split_type = 0
    endif
    let winid = nvim_tabpage_get_win(0)
    let next_id = -1
    for i in nvim_tabpage_list_wins(0)
      if next_id == 0
        let next_id = i
        break
      endif
      if i == winid
        let next_id = 0
      endif
    endfor
    let split_type = 0
    if next_id > 0
      if nvim_win_get_position(next_id)[1] == nvim_win_get_position(winid)[1]
        let split_type = 1
      endif
    endif
    if winwidth('%') > winheight('%') * 2.5
      let split_type = 1
    else
      let split_type = 0
    endif
    let line = line('.')
    let col = col('.')
    let bufnr = bufnr('%')
    let w:my_split_type = 1 - w:my_split_type
    let cmd = ''
    if split_type == 0
      let cmd .= 'split'
    else
      let cmd .= 'vsplit'
    endif
    for i in a:000
      let cmd .= ' ' . i
    endfor
    exec cmd
    let w:my_prev_winid = winid
    let w:my_prev_line = line
    let w:my_prev_col = col
  endfunction
  let g:split_win_stack = []
  function! MyPrevSplitWin(...) abort
    if !exists("w:my_prev_winid") || !nvim_win_is_valid(w:my_prev_winid)
      return
    endif
    let g:split_win_stack += [nvim_tabpage_get_win(0)]
    let winid = nvim_win_get_number(w:my_prev_winid)
    let line = w:my_prev_line
    let col = w:my_prev_col
    if winid >= 0
      exec winid . 'wincmd w'
      exec 'normal ' . line . 'G'
      exec 'normal ' . col . '|'
    endif
  endfunction
  function! MyNextSplitWin(...) abort
    if len(g:split_win_stack) == 0
      return
    endif
    let winid = g:split_win_stack[-1]
    let g:split_win_stack = g:split_win_stack[0:-2]
    let top_prev_winid = nvim_win_get_var(winid, 'my_prev_winid')
    let cur_winid = nvim_tabpage_get_win(0)
    if top_prev_winid == cur_winid
      let winid = nvim_win_get_number(winid)
      if winid > 0
        exec winid . 'wincmd w'
      endif
    else
      let g:split_win_stack = []
    endif
  endfunction
  function! MySplitQuit() abort
    if &filetype == 'tagbar'
      let g:TagbarOpen = 1 - g:TagbarOpen
      call AutoOpenTagBar()
      return
    endif
    try
      wall
      q!
    catch /only floating window/
      only
      q!
    catch
      q!
    endtry
  endfunction
  command! -nargs=* -complete=file
        \ Split call GoyoWrapper('MySplit', <q-args>)
  command! -nargs=*
        \ PrevSplitWin call GoyoWrapper('MyPrevSplitWin')
  command! -nargs=*
        \ NextSplitWin call GoyoWrapper('MyNextSplitWin')
  command! -nargs=*
        \ MyQuit call GoyoWrapper('MySplitQuit')
  nnoremap <silent> <M-q> :MyQuit<cr>:<c-c>

" window navigation
function SmartMj(nr) abort
  if a:nr != 0
    exec a:nr . "wincmd w"
    return
  endif
  let winnr = winnr()
  wincmd j
  if winnr() == winnr
    wincmd w
  endif
endfunction
function SmartMk(nr) abort
  let winnr = winnr()
  wincmd k
  if winnr() == winnr
    wincmd W
  endif
endfunction

" window copy cut paste
function! WinCopy() abort
  let g:win_buf_register = expand('%')
  let g:win_buf_line = line('.')
  let g:win_buf_col = col('.')
endfunction
function! WinCut() abort
  call WinCopy()
  try
    silent! wq
  catch
    q!
  endtry
endfunction
function! WinPaste(...) abort
  if a:0 == 0
    exec "split " .  g:win_buf_register
  else
    exec "vsplit " .  g:win_buf_register
  endif
  exec 'normal ' . g:win_buf_line . 'G'
  exec 'normal ' . g:win_buf_col . '|'
endfunction

" toggle window size
function! ToggleWinSize() abort
  let pw = winwidth('%')
  let ph = winheight('%')
  wincmd |
  wincmd _
  let cw = winwidth('%')
  let ch = winheight('%')
  if cw == pw && ch == ph
    if &filetype == 'floaterm'
      FloatermUpdate
    else
      wincmd =
    endif
  endif
  if &buftype == 'terminal'
    startinsert
  endif
endfunction

nnoremap <silent> <M-m> :call ToggleWinSize()<cr>
nnoremap <silent> <M-m> :Goyo<cr>
tnoremap <silent> <M-m> <c-\><c-n>:call ToggleWinSize()<cr>

nnoremap <c-w>d :call WinCut()<cr>
nnoremap <c-w>y :call WinCopy()<cr>
nnoremap <c-w>p :call WinPaste()<cr>
nnoremap <c-w>P :call WinPaste(1)<cr>
nnoremap <silent> qw :wqa<cr>
nnoremap <silent> qt :tabclose!<cr>
nnoremap <silent> qf :qa<cr>
nnoremap <silent> qo :only<cr>
nnoremap <silent> <M-h> <c-w>h
nnoremap <silent> <M-l> <c-w>l
nnoremap <silent> <M-j> :<c-u>call SmartMj(v:count)<cr>
nnoremap <silent> <M-k> :<c-u>call SmartMk(v:count)<cr>
for i in range(1, 9)
  exec "nnoremap <c-w>" . i . " " . i . "<c-w>w"
endfor
