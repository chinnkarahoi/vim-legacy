let g:AutoRegIgn = ["list", "tagbar", "codi", "terminal", 'defx', 'leaderf', "diff", 'undotree', 'floaterm']
augroup oh_my_registers
  autocmd!
  autocmd VimEnter *
        \ let @p=expand('%:p:h') |
        \ let @f=expand('%') |
        \ let @r=expand('%:t:r') |
        \ let @h=getcwd() |
  autocmd BufEnter,BufWinEnter *
        \ if index(g:AutoRegIgn, &filetype) < 0 && bufname('%') != '' && bufname('%') !~ '\.in.txt$' |
        \   let @p=expand('%:p:h') |
        \   let @f=expand('%') |
        \   let @r=expand('%:t:r') |
        \   let @h=getcwd() |
        \   let $VIM_CURRENT_FILETYPE=&filetype |
        \   let $VIM_CURRENT_FILE=expand('%:p') |
        \   let $VIM_CURRENT_FILE_DIR=expand('%:p:h') |
        \ endif
augroup END
