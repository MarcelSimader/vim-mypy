" Author: Marcel Simader (marcel0simader@gmail.com)
" Date: 16.11.2023

function mypy#ToPyBinary(candidates)
    let candidates = copy(a:candidates)
    let env = environ()
    " Check if we are in a virtual environment first
    if has_key(env, 'VIRTUAL_ENV')
        let penv = get(env, 'VIRTUAL_ENV', '')
        " We wanna prepend these better binary paths
        let candidates = mapnew(candidates, {_, v -> penv.v}) + candidates
    endif
    " See if we can execute any of the candidate binaries
    let working_binary = v:none
    for candidate in candidates
        let candidate_path = exepath(candidate)
        if executable(candidate_path)
            let working_binary = candidate_path | break
        endif
    endfor
    if working_binary is v:none
        echohl ErrorMsg
        echo "No executable binary of candidate list \'".string(candidates)
                    \ ."\' found in your runtime path!"
        echohl None
        " Just return some value...
        return get(candidates, 0, '')
    endif
    return working_binary
endfunction

function mypy#PyVersion(binary)
    if exists('g:Mypy_python_version') | return g:Mypy_python_version | endif
    return substitute(
                \ system(a:binary.' --version'),
                \ '.*Python \(\d.\d\{1,2}\).\d*.*', '\1', '')
endfunction

function mypy#ExecuteMyPy(path, strict = v:false)
    if !has('terminal')
        echohl ErrorMsg
        echo 'No terminal support!'
        return
    endif

    let mypy_binary = mypy#ToPyBinary(g:Mypy_binary_candidates)
    let py_binary = mypy#ToPyBinary(g:Mypy_python_binary_candidates)

    " Delete old terminal buffer
    let [term_row, term_col] = [v:none, v:none]
    if exists('g:Mypy_term_buf') && bufloaded(g:Mypy_term_buf)
        let wininfo_list = getwininfo(bufwinid(g:Mypy_term_buf))
        if len(wininfo_list) > 0
            let wininfo = wininfo_list[0]
            call assert_true(wininfo['terminal'])
            let term_row = wininfo['height']
            let term_col = wininfo['width']
            execute wininfo['winnr'].'wincmd w'
        endif
    endif

    " Start terminal job
    update
    let args = (a:strict ? g:Mypy_args_strict : g:Mypy_args)(mypy#PyVersion(py_binary))
    let args = join(args, ' ')
    let term_name = (a:strict ? 'STRICT: ' : '')
                \ .pathshorten(mypy_binary).' [...] '.pathshorten(a:path)
    if !(term_row is v:none || term_col is v:none)
        let g:Mypy_term_buf = term_start(
                    \ mypy_binary.' '.args.' '.a:path,
                    \ #{term_finish: 'open',
                    \   term_rows: term_row,
                    \   term_cols: term_col,
                    \   term_name: term_name,
                    \   curwin: v:true})
    else
        let g:Mypy_term_buf = term_start(
                    \ mypy_binary.' '.args.' '.a:path,
                    \ #{term_finish: 'open',
                    \   term_name: term_name})
    endif
    wincmd p
endfunction
