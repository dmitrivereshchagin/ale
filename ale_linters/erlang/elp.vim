" Author: Dmitri Vereshchagin <dmitri.vereshchagin@gmail.com>
" Description: LSP linter for Erlang files

call ale#Set('erlang_elp_executable', 'elp')

call ale#linter#Define('erlang', {
\   'name': 'elp',
\   'executable': {b -> ale#Var(b, 'erlang_elp_executable')},
\   'command': '%e server',
\   'lsp': 'stdio',
\   'project_root': {b -> ale#erlang#FindProjectRoot(b, ['.elp.toml'])},
\   'aliases': ['erlang-language-platform'],
\})
