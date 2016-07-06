" Make Vim more useful
set nocompatible

" Enable line numbers
set number

" Smart case search
set ignorecase
set smartcase

" Highlight searches
set hlsearch

" Use bash shell, required by syntastic plugin
set shell=bash

" VUNDLE PLUGINS
filetype off " required for Vundle
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
" Code folding
Plugin 'tmhedberg/SimpylFold'

" Autocompletion
Bundle 'Valloric/YouCompleteMe'

"Syntax highlighting
Plugin 'scrooloose/syntastic'

"Syntax checking (PEP8)
Plugin 'nvie/vim-flake8'

"Powerline
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

"PaperColor
Plugin 'NLKNguyen/papercolor-theme'

" All of your Plugins must be added before the following line
call vundle#end() " required
filetype plugin on " required

" Vim-flake8 setup
autocmd BufWritePost *.py call Flake8() " run the Flake8 check every time you write a Python file
let g:flake8_show_quickfix=1 " show the quickfix window
let g:flake8_show_in_file=1 " show signs in the file

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za
let g:SimpylFold_docstring_preview = 1

" PEP8 indentation
"au BufNewFile,BufRead *.py 
"    \ set tabstop=4 |
"    \ set softtabstop=4 | 
"    \ set shiftwidth=4 |
"    \ set textwidth=99 |
"    \ set expandtab |
"    \ set autoindent |
"    \ set fileformat=unix

"au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

"UTF8 support
set encoding=utf-8

" Flagging unnecessary whitespace
"define BadWhitespace before using in a match
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"Additional autocompletion setup
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

"Syntax highlighting
let python_highlight_all=1
syntax on

" Always show statusline
set laststatus=2

" Use light PaperColor theme
set t_Co=256 " Use 256 colours (if terminal allows it)
set background=light 
colorscheme PaperColor

"Markdown hl
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
