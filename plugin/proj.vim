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
