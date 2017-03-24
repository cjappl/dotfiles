"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CJAPPL .vimrc 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        .OO
"                       .OOOO
"                      .OOOO'
"                      OOOO'          .-~~~~-.
"                      OOO'          /   (o)(o)
"              .OOOOOO `O .OOOOOOO. /      .. |
"          .OOOOOOOOOOOO OOOOOOOOOO/\    \____/
"        .OOOOOOOOOOOOOOOOOOOOOOOO/ \\   ,\_/
"       .OOOOOOO%%OOOOOOOOOOOOO(#/\     /.
"      .OOOOOO%%%OOOOOOOOOOOOOOO\ \\  \/OO.
"     .OOOOO%%%%OOOOOOOOOOOOOOOOO\   \/OOOO.
"     OOOOO%%%%OOOOOOOOOOOOOOOOOOO\_\/\OOOOO
"     OOOOO%%%OOOOOOOOOOOOOOOOOOOOO\###)OOOO
"     OOOOOO%%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
"     OOOOOOO%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
"     `OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
"   .-~~\OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
"  / _/  `\(#\OOOOOOOOOOOOOOOOOOOOOOOOOOOO'
" / / \  / `~~\OOOOOOOOOOOOOOOOOOOOOOOOOO'
"|/'  `\//  \\ \OOOOOOOOOOOOOOOOOOOOOOOO'
"       `-.__\_,\OOOOOOOOOOOOOOOOOOOOO'
"           `OO\#)OOOOOOOOOOOOOOOOOOO'
"             `OOOOOOOOO''OOOOOOOOO'
"               `""""""'  `""""""'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Plugins
Plugin 'VundleVim/Vundle.vim' " Bundler
Plugin 'Valloric/YouCompleteMe' " Auto completion
Plugin 'scrooloose/syntastic' " auto syntax checking
Plugin 'ctrlpvim/ctrlp.vim' " fuzzy search file finding

" End configuration, makes the plugins available
call vundle#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" =>Pathogen
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: This has been replaced by my use of Vundle, just keeping things here
"       in case things break

" Sets runtimepath to all files in bundle area
" call pathogen#infect()
" call pathogen#helptags()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore=E501,E402,E731'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YCM 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_confirm_extra_conf = 0 
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set line numbers
set number

" Sets how many lines of history VIM has to remember
set history=100

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Disabling auto commenting 
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=3

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*,.tox\*,.build\*,.dist\*
endif

"Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
"set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

try
    colorscheme desert
catch
endtry

set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use unix as the standard file type
set ffs=unix

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Splits
map <leader>v :vs<cr>

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Simplify pasting and copying to system clipboard
map <leader>y "*y
map <leader>Y "*Y
map <leader>p "*p
map <leader>P "*P

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction
