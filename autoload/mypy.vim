function mypy#ExecuteMyPy(path, strict = v:false)
    if !executable(g:Mypy_binary)
        echohl ErrorMsg
        echo "The mypy executable was not found in your runtime path"
        return
    elseif !has('terminal')
        echohl ErrorMsg
        echo "No terminal support!"
        return
    endif

    " Delete old terminal buffer
    let [term_row, term_col] = [v:none, v:none]
    if exists('g:Mypy_term_buf') && bufloaded(g:Mypy_term_buf)
        let wininfo_list = getwininfo(bufwinid(g:Mypy_term_buf))
        if len(wininfo_list) > 0
            let wininfo = wininfo_list[0]
            if wininfo['terminal']
                let term_row = wininfo['height']
                let term_col = wininfo['width']
            endif
        endif
        execute ':'.bufnr(g:Mypy_binary).'bdelete'
    endif
    " Start terminal job
    update
    let args = join(a:strict ? g:Mypy_args_strict : g:Mypy_args, ' ')
    if !(term_row is v:none || term_col is v:none)
        let g:Mypy_term_buf = term_start(
                    \ g:Mypy_binary.' '.args.' '.a:path,
                    \ #{term_finish: 'open', term_rows: term_row, term_cols: term_col})
    else
        let g:Mypy_term_buf = term_start(
                    \ g:Mypy_binary.' '.args.' '.a:path,
                    \ #{term_finish: 'open'})
    endif
    wincmd p
endfunction
