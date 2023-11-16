" Author: Marcel Simader (marcel0simader@gmail.com)
" Date: 11.11.2023
" (c) Marcel Simader 2023

if !exists('g:Mypy_enable') | let g:Mypy_enable = 1 | endif
" Include guard and disabling mechanic
if !g:Mypy_enable || exists('g:Mypy_loaded') | finish | endif
let g:Mypy_loaded = 1

if !exists('g:Mypy_binary')
    let g:Mypy_binary = 'mypy'
endif
if !exists('g:Mypy_python_binary')
    let g:Mypy_python_binary = 'python3'
endif
if !exists('g:Mypy_python_version')
    let g:Mypy_python_version = substitute(
                \ system(g:Mypy_python_binary.' --version'),
                \ '.*Python \(\d.\d\{1,2}\).\d*.*', '\1', '')
endif
if !exists('g:Mypy_args_strict')
    let g:Mypy_args_strict = [
                \ '--follow-imports=normal',
                \ '--python-version '.g:Mypy_python_version,
                \ '--install-types',
                \ ]
endif
if !exists('g:Mypy_args')
    let g:Mypy_args = [
                \ '--follow-imports=skip',
                \ '--disable-error-code=import',
                \ '--python-version '.g:Mypy_python_version,
                \ ]
endif

