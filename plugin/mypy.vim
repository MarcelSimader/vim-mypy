" Author: Marcel Simader (marcel0simader@gmail.com)
" Date: 11.11.2023
" (c) Marcel Simader 2023

if !exists('g:Mypy_enable') | let g:Mypy_enable = 1 | endif
" Include guard and disabling mechanic
if !g:Mypy_enable || exists('g:Mypy_loaded') | finish | endif
let g:Mypy_loaded = 1

if !exists('g:Mypy_binary_candidates')
    let g:Mypy_binary_candidates = ['mypy']
endif
if !exists('g:Mypy_python_binary_candidates')
    let g:Mypy_python_binary_candidates = ['python3', 'python']
endif
if !exists('g:Mypy_python_version')
    " This could be defined to override automatic mode
endif
if !exists('g:Mypy_args_strict')
    let g:Mypy_args_strict = {v -> [
                \ '--python-version '.v,
                \ '--follow-imports=normal',
                \ '--install-types',
                \ ]}
endif
if !exists('g:Mypy_args')
    let g:Mypy_args = {v -> [
                \ '--python-version '.v,
                \ '--follow-imports=skip',
                \ '--disable-error-code=import',
                \ '--show-error-context',
                \ '--show-column-numbers',
                \ '--show-error-end',
                \ '--pretty',
                \ ]}
endif

