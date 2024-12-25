let s:project_root_markers = [
\   '_checkouts/',
\   '_build/',
\   'deps/',
\   'rebar.lock',
\   'erlang.mk',
\]

function! ale#erlang#FindProjectRoot(buffer, ...) abort
    let l:markers = s:project_root_markers + get(a:, 1, [])

    for l:marker in l:markers
        let l:path = l:marker[-1:] is# '/'
        \   ? ale#path#FindNearestDirectory(a:buffer, l:marker)
        \   : ale#path#FindNearestFile(a:buffer, l:marker)

        if !empty(l:path)
            return ale#path#Dirname(l:path)
        endif
    endfor

    return ''
endfunction
