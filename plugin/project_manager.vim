if exists("g:project_name")
    finish
endif

let s:lines = readfile('.daq_pm/config.txt')
let s:props = {}
for s:line in s:lines
    let s:kv = split(s:line)
    let s:props[s:kv[0]] = s:kv[1]
endfor
let g:project_name = s:props['name']
let g:project_type = s:props['type']
if g:project_type ==? 'cpp' || g:project_type ==? 'c++'
    let g:cpp_project_props = {}
    let g:cpp_project_props['target'] = s:props['target']
    let g:cpp_project_props['build_dir'] = s:props['build_dir']
    let g:cpp_project_props['cmake_options'] = s:props['cmake_options']
    let g:cpp_project_props['program_arguments'] = s:props['program_arguments']
endif
