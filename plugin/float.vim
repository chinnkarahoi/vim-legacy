function! CreateCenteredFloatingWindow() abort
    let width = &columns * 8 / 10
    let height = &lines * 8 / 10
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal', 'border': 'single'}

    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    let l:textbuf = nvim_create_buf(v:false, v:true)
    let winid = nvim_open_win(l:textbuf, v:true, opts)
    return [l:textbuf, winid]
endfunction

function! FloatingWindowHelp(query) abort
    let [l:buf,winid] = CreateCenteredFloatingWindow()
    call nvim_set_current_win(winid)
    setlocal filetype=help
    setlocal buftype=help
    try
        execute 'help ' . a:query
        call nvim_win_set_option(winid, 'signcolumn', 'yes')
    catch
        quit
    endtry
endfunction

command! -complete=help -nargs=? Help call FloatingWindowHelp(<q-args>)
