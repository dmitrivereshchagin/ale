" Author: Dmitri Vereshchagin <dmitri.vereshchagin@gmail.com>
" Description: LSP linter for Erlang files

call ale#Set('erlang_erlang_ls_executable', 'erlang_ls')
call ale#Set('erlang_erlang_ls_log_dir', '')
call ale#Set('erlang_erlang_ls_log_level', 'info')

function! s:GetCommand(buffer) abort
    let l:log_dir = ale#Var(a:buffer, 'erlang_erlang_ls_log_dir')
    let l:log_level = ale#Var(a:buffer, 'erlang_erlang_ls_log_level')

    let l:command = '%e'

    if !empty(l:log_dir)
        let l:command .= ' --log-dir=' . ale#Escape(l:log_dir)
    endif

    let l:command .= ' --log-level=' . ale#Escape(l:log_level)

    return l:command
endfunction

call ale#linter#Define('erlang', {
\   'name': 'erlang_ls',
\   'executable': {b -> ale#Var(b, 'erlang_erlang_ls_executable')},
\   'command': function('s:GetCommand'),
\   'lsp': 'stdio',
\   'project_root': {b -> ale#erlang#FindProjectRoot(b, [
\       'erlang_ls.config',
\       '.kerl_config',
\   ])},
\   'aliases': ['erlang-ls'],
\})
