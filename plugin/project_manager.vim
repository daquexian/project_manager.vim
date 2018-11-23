if exists("g:project_name")
    finish
endif

let s:cwd = getcwd()
let s:config_dir = s:cwd . '/.daq_pm/configs/'
let s:status_dir = s:cwd . '/.daq_pm/status/'
let s:status_file = s:cwd . '/.daq_pm/status/config'

function s:open_build_run_term()
    let g:neoterm_autoscroll = 1
    let g:neoterm_size = 20
    if !exists("g:build_run_term_id")
        " hacky
        let g:build_run_term_id = g:neoterm.next_id() + 1
        execute 'bo Topen'
    else
        execute 'bo ' . g:build_run_term_id . 'Topen'
    endif
endfunction

function s:read_config()
    if !filereadable(s:status_file)
        return
    endif
    let s:lines = readfile(s:status_file)
    let s:status_props = {}
    for s:line in s:lines
        let s:config_file = s:config_dir . s:line
    endfor
    if !filereadable(s:config_file)
        return
    endif
    let s:lines = readfile(s:config_file)
    let s:props = {}
    for s:line in s:lines
        let s:kv = split(s:line)
        let s:props[s:kv[0]] = join(s:kv[1:], ' ')
    endfor
    let g:project_name = s:props['name']
    let g:project_type = s:props['type']

    function! s:escape_for_texec(command)
        return substitute(a:command, ' ', '\\ ', 'g')
    endfunction

    if g:project_type ==? 'cpp' || g:project_type ==? 'c++'
        let g:cpp_project_props = {}
        let g:cpp_project_props['build_type'] = get(s:props, 'build_type', 'Debug')
        let g:cpp_project_props['target'] = get(s:props, 'target', 'all')
        let g:cpp_project_props['build_dir'] = s:cwd . '/' . get(s:props, 'build_dir', 'build')
        let g:cpp_project_props['cmake_options'] = get(s:props, 'cmake_options', '')
        let g:cpp_project_props['binary'] = get(s:props, 'binary', '')

        let s:escaped_cd = s:escape_for_texec('mkdir -p ' . g:cpp_project_props['build_dir'] . ' && cd ' . g:cpp_project_props['build_dir'])
        function! g:Build()
            let l:escaped_cmake_opts = s:escape_for_texec('cmake ' . '-DCMAKE_BUILD_TYPE=' . g:cpp_project_props['build_type'] . ' ' . g:cpp_project_props['cmake_options'] . ' ..')
            let l:escaped_cmake_build = s:escape_for_texec('cmake --build . --target ' . g:cpp_project_props['target'])
            call s:open_build_run_term()
            execute 'bo Texec ' . s:escaped_cd . ' ' . l:escaped_cmake_opts . ' ' . l:escaped_cmake_build
        endfunction
        function! g:Run()
            let l:escaped_binary_com = s:escape_for_texec(g:cpp_project_props['binary'])
            call s:open_build_run_term()
            execute 'bo Texec ' . s:escaped_cd . ' ' . l:escaped_binary_com
        endfunction
        function! g:BuildAndRun()
            call g:Build()
            call g:Run()
        endfunction
        noremap <Plug>Build :call Build()<CR>
        noremap <Plug>Run :call Run()<CR>
        noremap <Plug>BuildAndRun :call BuildAndRun()<CR>
    endif

endfunction

function s:select_handler(line)
    call mkdir(s:status_dir, 'p')
    call writefile([a:line], s:status_file)
    call s:read_config()
endfunction

function g:SelectConfig()
    call mkdir(s:config_dir, 'p')
    call fzf#run({
                \ 'dir': s:config_dir,
                \ 'options': '+m',
                \ 'sink': function('s:select_handler')})
endfunction

" NewConfig is still wip
function g:NewConfig()
    call mkdir(s:config_dir, 'p')
    call mkdir(s:status_dir, 'p')
    
    let text  = ["name <project_name>"]
    " Use rst's preferred format for the time:
    call add (text, "type <project_type>")
    call add (text, "target <cmake_target>")
    call add (text, "build_dir <build_dir>")
    call add (text, "cmake_options <cmake_options>")
    call add (text, "program_arguments <program_arguments>")
    let failed = append(0, text)
endfunction

noremap <Plug>SelectConfig :call SelectConfig()<CR>
" NewConfig is still wip
noremap <Plug>NewConfig :call NewConfig()<CR>
noremap <Plug>SelectConfig :call SelectConfig()<CR>

call s:read_config()
