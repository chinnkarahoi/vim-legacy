" n N
  function! PrevNextMap(...) abort
    silent! nunmap <buffer> n
    silent! nunmap <buffer> N
    if a:0 == 0
      nnoremap <silent> n n
      nnoremap <silent> N N
    elseif a:1 == 'gitgutter'
      nnoremap <silent> n ]c
      nnoremap <silent> N [c
    elseif a:1 == 'diff'
      nnoremap <silent> n ]czz
      nnoremap <silent> N [czz
    elseif a:1 == 'goyo'
      nnoremap <silent> n <cmd>NextSplitWin<cr>
      nnoremap <silent> N <cmd>PrevSplitWin<cr>
    elseif a:1 == 'leaderf'
      nnoremap <silent> n <cmd>Leaderf --next<cr>
      nnoremap <silent> N <cmd>Leaderf --previous<cr>
    elseif a:1 == 'tag'
      nnoremap <silent> n <cmd>silent! tn<cr>
      nnoremap <silent> N <cmd>silent! tp<cr>
    elseif a:1 == 'coc'
      nnoremap <silent> n <cmd>CocNext<cr>
      nnoremap <silent> N <cmd>CocPrev<cr>
    endif
  endfunction
  augroup oh_my_n_N
    autocmd!
    autocmd FileType leaderf call PrevNextMap('leaderf')
    autocmd FileType list call PrevNextMap('coc')
    autocmd BufEnter,BufWinEnter * if &diff == 1 | call PrevNextMap('diff') | endif
  augroup END
  nnoremap <silent> <c-]> :call PrevNextMap('tag')<cr><c-]>
  nnoremap <silent> ? :call PrevNextMap()<cr>?
  nnoremap <silent> * :call PrevNextMap()<cr>/\<<c-r><c-w>\><cr>
  nnoremap <silent> g* :call PrevNextMap()<cr>/<c-r><c-w><cr>
  nnoremap <silent> # :call PrevNextMap()<cr>viwo<esc>?\<<c-r><c-w>\><cr>
  nnoremap <silent> g# :call PrevNextMap()<cr>viwo<esc>?<c-r><c-w><cr>
  nmap <silent> ]h :GitGutterNextHunk<cr>:call PrevNextMap('gitgutter')<cr>
  nmap <silent> [h :GitGutterPrevHunk<cr>:call PrevNextMap('gitgutter')<cr>
