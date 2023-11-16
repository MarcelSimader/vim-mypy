" Author: Marcel Simader (marcel0simader@gmail.com)
" Date: 11.11.2023
" (c) Marcel Simader 2023

" Include guard and disabling mechanic
if !g:Mypy_enable || exists('b:Mypy_ft_loaded') | finish | endif
let b:Mypy_ft_loaded = 1

command -buffer Mypy call mypy#ExecuteMyPy(bufname('%'))
command -buffer MypyAll call mypy#ExecuteMyPy(getcwd())

nnoremap <buffer> <LocalLeader>mpa <Cmd>call mypy#ExecuteMyPy(expand('%:p:h'))<CR>
nnoremap <buffer> <LocalLeader>mp  <Cmd>call mypy#ExecuteMyPy(expand('%:p'))<CR>
nnoremap <buffer> !                <Cmd>call mypy#ExecuteMyPy(expand('%:p:h'))<CR>
nnoremap <buffer> "                <Cmd>call mypy#ExecuteMyPy(expand('%:p'))<CR>
nnoremap <buffer> §                <Cmd>call mypy#ExecuteMyPy(expand('%:p:h'), v:true)<CR>

let b:undo_ftplugin = 'unmap <buffer> <LocalLeader>mpa \| unmap <buffer> <LocalLeader>mp'
            \ .' \| unmap <buffer> ! \| unmap <buffer> " \| unmap <buffer> §'
            \ .' \| delcommand -buffer Mypy \| delcommand -buffer MypyAll'

