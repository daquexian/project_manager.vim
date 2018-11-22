# project_manager.vim

## Installation

project_manager.vim depends on [fzf](https://github.com/junegunn/fzf) and [fzf.vim](https://github.com/junegunn/fzf.vim)

If you use [vim-plug](https://github.com/junegunn/vim-plug):

```
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'daquexian/project_manager.vim
```

## Usage

Map `<Plug>Build` to automatically use cmake to build your target, map `<Plug>SelectConfig` to select config using fzf. For example

```
nmap <A-b> <Plug>Build
nmap <A-s> <Plug>SelectConfig
```

## Tips

The configuration files will be placed in `project_root_dir/.daq_fm`, so you might want to add `.daq_fm` in your `.gitignore`
