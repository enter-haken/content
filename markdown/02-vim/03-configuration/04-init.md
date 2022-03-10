# putting all together 

Now with everything set up we have a `/.config/nvim` folder with different files

<!--more-->

These files are part of my [NeoVim config][1].

## init.vim

```
runtime! plugins.vim
runtime! settings.vim
runtime! ctrlp.vim
runtime! NERDTree.vim
runtime! lsp.vim
runtime! autoformat.vim
runtime! coc.vim
```

# plugins.vim

```
call plug#begin()

" themes
Plug 'nanotech/jellybeans.vim'
Plug 'arcticicestudio/nord-vim'

" general stuff
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'chiel92/vim-autoformat'
Plug 'tpope/vim-fugitive'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Syntax highlighting for json files with comments
" https://github.com/neoclide/jsonc.vim/blob/master/ftdetect/jsonc.vim
Plug 'neoclide/jsonc.vim'

" elixir
Plug 'elixir-editors/vim-elixir'

call plug#end()
```

# settings.vim

```
colorscheme nord

let mapleader=','

set title
set number
set ignorecase

" Umlaute
set termencoding=utf8
set enc=utf8
set fileencoding=utf8

set tabstop=2
set softtabstop=2
set shiftwidth=2

" ignore case in search when no uppercase search
set incsearch
set ignorecase
set smartcase

set autoindent
set expandtab

" disable swap files
set noswapfile
set nobackup
set nowritebackup        

"disable folding
set nofoldenable 

" switch buffers without saving
set hidden

" robot framework filetype detection
autocmd BufNewFile,BufRead *.robot setlocal filetype=robot

" TODO: move to own file
let g:formatters_tf = ['terraform_format']

let g:netrw_dirhistmax = 0
```

# ctrlp.vim

```
" add an artificial anchor to bigger projects to improve search experience
let g:ctrlp_root_markers = ['.ctrlp_anchor']
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
```

# nerdtree.vim

```
let NERDTreeShowHidden=1

nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>f :NERDTreeFind<CR>
```

# lsp.vim

**this part is in review**

```
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
```

# autoformat.vim

```
" needed for chiel92/vim-autoformat
" https://github.com/vim-autoformat/vim-autoformat#requirement
"
" requirements:
"
" python3 -m pip install pynvim
"
let g:python3_host_prog='/usr/bin/python3'

nmap <Leader>a :Autoformat<CR>
```

# coc.vim

**this part is in review**

```
let g:coc_global_extensions = [
      \'coc-css', 
      \'coc-docker',
      \'coc-elixir', 
      \'coc-html', 
      \'coc-json', 
      \'coc-prettier', 
      \'coc-pyright',
      \'coc-python', 
      \'coc-sh',
      \'coc-snippets', 
      \'coc-tailwindcss',
      \'coc-tsserver', 
      \'coc-yaml'
      \]

autocmd FileType scss setl iskeyword+=@-@
```

[1]: https://github.com/enter-haken/neovim-config
