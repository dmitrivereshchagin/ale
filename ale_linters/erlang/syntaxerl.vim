" Author: Dmitri Vereshchagin <dmitri.vereshchagin@gmail.com>
" Description: SyntaxErl linter for Erlang files

call ale#Set('erlang_syntaxerl_executable', 'syntaxerl')

function! ale_linters#erlang#syntaxerl#Handle(buffer, lines) abort
    let l:pattern = '\v\C:(\d+):%((\d+):)?( warning:)? (.+)'
    let l:loclist = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:loclist, {
        \   'lnum': str2nr(l:match[1]),
        \   'col':  empty(l:match[2]) ? 0 : str2nr(l:match[2]),
        \   'text': l:match[4],
        \   'type': empty(l:match[3]) ? 'E' : 'W',
        \})
    endfor

    return l:loclist
endfunction

function! s:GetExecutable(buffer) abort
    return ale#Var(a:buffer, 'erlang_syntaxerl_executable')
endfunction

function! s:GetCommand(buffer) abort
    let l:Callback = function('s:GetCommandFromHelpOutput')

    return ale#command#Run(a:buffer, '%e -h', l:Callback, {
    \   'executable': s:GetExecutable(a:buffer),
    \})
endfunction

function! s:GetCommandFromHelpOutput(buffer, output, metadata) abort
    let l:has_c_option = match(a:output, '\V\C-c, --columns\>') > -1

    return l:has_c_option ? '%e -b %s -c %t' : '%e -b %s %t'
endfunction

call ale#linter#Define('erlang', {
\   'name': 'syntaxerl',
\   'callback': 'ale_linters#erlang#syntaxerl#Handle',
\   'executable': function('s:GetExecutable'),
\   'command': function('s:GetCommand'),
\})
