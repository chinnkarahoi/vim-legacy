" PROJ
  function! s:get_vcs_dir(path)
    let path = fnamemodify(a:path, ':p:h')
    if !isdirectory(path)
      return getcwd()
    else
      let vcspath = finddir('.git', escape(path, ' ') . ';')
      if vcspath == ''
        return path
      else
        return fnamemodify(fnameescape(fnamemodify(vcspath, ':h')), ':p:h')
      endif
    endif
  endfunction
  let g:vcs_full_dir = s:get_vcs_dir(getcwd())
  if g:vcs_full_dir == $HOME
    let g:vcs_base_dir = 'home'
  else
    let g:vcs_base_dir = fnamemodify(g:vcs_full_dir, ':t')
  endif
  let g:proj_config_root_dir = $HOME . '/.config/project'
  let g:proj_config_dir = g:proj_config_root_dir . '/' . g:vcs_base_dir
  let $PROJ_CONFIG_DIR = g:proj_config_dir
  let g:proj_config_env = g:proj_config_dir . '/.env'
  let g:proj_config_exrc = g:proj_config_dir . '/.exrc'
  let g:proj_config_memo = g:proj_config_dir . '/memo.md'
  let g:proj_config_makefile = g:proj_config_dir . '/project.mk'
  let g:proj_config_vimspector = g:proj_config_dir . '/.vimspector.json'
  let g:proj_config_input_dir = g:proj_config_dir . '/input'
  let g:proj_config_script_dir = g:proj_config_dir . '/scripts'
  let g:proj_config_runner_file = g:proj_config_root_dir . '/runner.mk'
  let g:proj_config_base_makefile = g:proj_config_root_dir . '/base.mk'

" exrc
  function! LoadExrc() abort
    silent! exec "source " . g:proj_config_exrc
  endfunction
  augroup oh_my_dotenv
    autocmd!
    autocmd VimEnter call LoadExrc()
    autocmd BufWritePost * if bufname('%') =~ '.exrc' | call LoadExrc() | endif
  augroup END

" makelist
  function! s:indent() abort
    if expand("%") =~ 'gql.in.txt$' || expand("%") =~ 'graphql.in.txt$'
      set ft=json
    endif
  endfunction
  autocmd FileType,BufEnter * call s:indent()
  function! OpenInputFile(...) abort
    let g:inputDir = g:proj_config_input_dir
    if !isdirectory(g:inputDir)
      call mkdir(g:inputDir, 'p')
    endif
    let g:inputFile = g:inputDir . '/' . expand('%:t') . '.in.txt'
    if a:0 > 0
      let g:inputFile .= a:1
    endif
    return g:inputFile
  endfunction
  let g:make_dry_run_dir = '/tmp/vim-make'
  function TargetFile(data) abort
    return g:make_dry_run_dir . '/' . substitute(a:data, '/', '-', 'g') . '.sh'
  endfunction
  function! MakelistProvider() abort
    return system('makelist | grep -E "(^run-|^debug-)"')
  endfunction
  function! FullMakelistProvider() abort
    return system('makelist')
  endfunction
  function! FileMakelistProvider() abort
    return system('makelist -f ' . expand('%'))
  endfunction
  call mkdir(g:make_dry_run_dir, 'p')
  function! MakelistPreviewer(data) abort
    let file = TargetFile(a:data)
    call system('make -Brn -f ' . g:proj_config_base_makefile . ' ' . a:data . ' > ' . file . ' 2>&1')
    return file
  endfunction
  let g:make_not_keep = ["debug-.*"]
  let g:make_recent_script = g:proj_config_script_dir . '/recent.sh'
  function! MakelistConsumer(data) abort
    let cmd = ''
    let cmd .= "make -s -f " . g:proj_config_base_makefile . " " . a:data
    let runner = 'FloatermNewKeep'
    for i in g:make_not_keep
      if a:data =~ i
        let runner = 'FloatermNew'
        break
      endif
    endfor
    exec runner . " " . escape(cmd, ' ')

    call mkdir(g:proj_config_script_dir, 'p')
    let f1 = readfile(TargetFile(a:data))
    let sub = 0
    for i in range(len(f1))
      let n = len(f1[i])
      if sub == 0
        if f1[i][n-1] == '\'
          let f1[i] = '( ' . f1[i]
          let sub = 1
        else
          let f1[i] = '( ' . f1[i] . ' )'
        endif
      else
        if f1[i][n-1] == '\'
          let f1[i] = f1[i]
        else
          let f1[i] = f1[i] . ' )'
          let sub = 0
        endif
      endif
    endfor
    let f1 = ['cd ' . getcwd()] + f1
    call writefile(f1, g:make_recent_script)
  endfunction
  let g:leaderf_makelist = "Leaderf make --provider MakelistProvider --previewer MakelistPreviewer --consumer MakelistConsumer"
  let g:leaderf_full_makelist = "Leaderf make --provider FullMakelistProvider --previewer MakelistPreviewer --consumer MakelistConsumer"
  let g:leaderf_file_makelist = "Leaderf make --provider FileMakelistProvider --previewer MakelistPreviewer --consumer MakelistConsumer"
  nnoremap <silent> <M-v> :exec g:leaderf_full_makelist<cr>
  nnoremap <silent> <M-1> :exec "FloatermNewKeep sh " . g:make_recent_script<cr>
  nnoremap <silent> <M-2> :exec "FloatermNewKeep sh " . g:make_recent_script<cr>
  nnoremap <silent> <M-3> :exec "FloatermNewKeep make -f " . g:proj_config_base_makefile . " real-time"<cr>
  nnoremap <silent> <M-4> :exec "FloatermNewKeep make -f " . g:proj_config_base_makefile . " real-time-1"<cr>
  nnoremap <silent> <M-5> :exec "FloatermNewKeep make -f " . g:proj_config_base_makefile . " real-time-2"<cr>
  nnoremap <silent> <M-r> :call MakelistPreviewer("run-current-file")<cr>:call MakelistConsumer("run-current-file")<cr>
  nnoremap <silent> <M-g> :exec g:leaderf_file_makelist<cr>
  nnoremap <silent> <M-G> :exec g:leaderf_makelist<cr>

" Special Files
  nnoremap <silent> ei :exec "Split " . OpenInputFile()<cr>
  nnoremap <silent> ep :exec "Split " . g:proj_config_makefile<cr>

" REPL
  let g:proj_repl_file = g:proj_config_script_dir . '/repl.vim'
  function! OpenVimReplWin() abort
    call mkdir(g:proj_config_script_dir, 'p')
    let winnr=winnr()
    exec "Split " . g:proj_repl_file
    nnoremap <silent><buffer> <M-r> :call RunVimRepl()<cr>
    let w:winnr = winnr
  endfunction
  function! RunVimRepl() abort
    if bufname() =~ 'repl\.vim'
      let winnr = winnr()
      exec w:winnr . "wincmd w"
      exec "source " . g:proj_repl_file
      exec winnr . "wincmd w"
    endif
  endfunction
  nnoremap <silent> er :call OpenVimReplWin()<cr>
