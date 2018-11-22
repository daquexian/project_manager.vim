echom 'hi!'
if exists("g:project_name")
    finish
endif

let s:lines = readfile('.daq_pm/config.txt')
let s:props = {}
for s:line in s:lines
    let kv = split(s:line)
    s:props[kv[0]] = kv[1]
endfor
let g:project_name = s:props['name']
let g:project_type = s:props['type']
if g:project_type ==? 'cpp' or g:project_type ==? 'c++'
    let g:cpp_project_props = {}
    g:cpp_project_props['target'] = s:props['target']
    g:cpp_project_props['build_dir'] = s:props['build_dir']
    g:cpp_project_props['cmake_options'] = s:props['cmake_options']
    g:cpp_project_props['program_arguments'] = s:props['program_arguments']
endif
