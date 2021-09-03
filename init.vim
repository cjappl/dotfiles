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
set shell=bash
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim' " Bundler
Plugin 'dense-analysis/ale' " auto syntax checking
Plugin 'ctrlpvim/ctrlp.vim' " fuzzy search file finding
Plugin 'roxma/python-support.nvim'  " requirement for some other packages
Plugin 'jremmen/vim-ripgrep' " recursive grep
Plugin 'pboettch/vim-cmake-syntax'  " syntax highlighting for cmake
Plugin 'ncm2/ncm2'      " autocomplete engine
Plugin 'roxma/nvim-yarp'   " c++ autocomplete
Plugin 'ncm2/ncm2-pyclang' " python and c++ autocomplete
Plugin 'ncm2/ncm2-jedi'  " python autocomplete
Plugin 'ncm2/ncm2-path'  " path completion
Plugin 'craigemery/vim-autotag' " auto ctagging
Plugin 'vim-airline/vim-airline'
Plugin 'ayu-theme/ayu-vim'
Plugin 'nixprime/cpsm'
Bundle 'edkolev/tmuxline.vim'
" End configuration, makes the plugins available
call vundle#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set peekaboo window so it's a bit bigger
let g:peekaboo_window = "vert bo 45new"

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

let g:ncm2_pyclang#library_path = '/usr/local/Cellar/llvm/12.0.1/lib/libclang.dylib'

let g:ncm2_pyclang#database_path = [
            \ 'compile_commands.json',
            \ 'build/compile_commands.json',
            \ 'build/ninja/studio/noopt/compile_commands.json',
            \ '../build/ninja/studio/noopt/compile_commands.json',
            \ '/Users/capple/git/game-engine/build/ninja/studio/noopt/compile_commands.json',
            \ ]

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:airline#extensions#tmuxline#enabled = 0

let g:airline#extensions#tabline#enabled = 1

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"


"let g:tmuxline_separators = {
"    \ 'left' : '',
"    \ 'left_alt': '>',
"    \ 'right' : '',
"    \ 'right_alt' : '<',
"    \ 'space' : ' '}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NOTE: ALE currently doesn't work on C++ header files: https://github.com/w0rp/ale/issues/782
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format =[' %d E ', ' %d W ', '']
let g:ale_lint_on_text_changed = 'never'  " run lint in normal mode only
" suggested linters:
"     pip-install: cmakelint, flake8, autopep8, rstcheck, pydocstyle
"     brew install: shellcheck(takes forever to install)
"     npm install: prettier (for javascript, css, json, markdown, more)
let g:ale_virtualenv_dir_names = [
            \ '.env', 'env', 've-py3', 've', 'virtualenv', 'venv',
            \ $HOME.'/.local/share/nvim/plugged/python-support.nvim/autoload/nvim_py3'
            \ ]
let g:ale_python_flake8_options = '--ignore=E501'

"'python': ['remove_trailing_lines', 'trim_whitespace'],
let g:ale_fixers = {
            \ 'python': [],
            \ 'cpp': [],
            \ 'objcpp': [],
            \ 'cmake': []
            \ }

" so the clang checker can find the compile_commands.json file
let g:ale_c_build_dir_names = ['build_osx']

let g:ale_c_clangformat_style_option = 'file'

let g:ale_cpp_clangtidy_checks = ["*,-llvmlibc-*,-google*,-llvm-header-guard,-*special-member-functions,-readability-else-after-return,-*uppercase-literal-suffix,-fuchsia-default-arguments,-readability-const-return-type,-misc-unused-parameters,-*-use-equals-default,-readability-redundant-control-flow,-readability-implicit-bool-conversion,-modernize-return-braced-init-list,-*-magic-numbers,-clang-diagnostic-error,-cert-err58-cpp,-fuchsia-statically-constructed-objects,-cppcoreguidelines-pro-bounds-array-to-pointer-decay,-hicpp-no-array-decay,-modernize-use-trailing-return-type,-fuchsia-default-arguments-calls"]

let g:ale_cpp_clang_options = '-Wall -Wpedantic'

let g:ale_linters = {'py': ['flake8'],
  \ 'objc': ['clang', 'clangcheck', 'clangtidy'],
  \ 'objcpp': ['clang', 'clangcheck', 'clangtidy'],
  \ 'cpp': ['clang', 'clangcheck', 'clangtidy'],
  \ 'hpp': ['clang', 'clangcheck', 'clangtidy'],
  \}

let g:ale_c_clangformat_use_local_file=1
let g:ale_c_clangformat_style_option="file"

let g:ale_c_parse_compile_commands=1
let g:ale_c_parse_makefile=1

" Fix on save
let g:ale_fix_on_save = 1

" use C-k/C-j to jump from error to error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Map Ctrl-C to Escape, mainly to trigger autocmd for ALE when exiting insert mode
inoremap <C-c> <Esc>
"let g:ale_lint_on_insert_leave = 1  " run lint when leaving insert mode(good when ale_lint_on_text_changed is 'normal')
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ctrlp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" disable search of certain folders
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](build|log|__pycache__|\.git|\.hg|\.svn|.+\.egg-info|*.LegacyAssemblies|*ThirdParty*|*Tools*)$',
    \ 'file': '\v\.(lst|so|swp|zip|gz|tar|png|jpg|pyc)$'
    \ }

"let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
"let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }

" Don't use git as the hierarchy, just do the current directory and lower
let g:ctrlp_working_path_mode = 'wa'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

"try
"    colorscheme desert
"catch
"endtry

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let ayucolor="dark"   " for dark version of theme
colorscheme ayu

set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use unix as the standard file type
set ffs=unix

" highlight colors
"hi Search ctermbg=grey
"hi Search ctermfg=black

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" file browsing with netrw
let g:netrw_banner=0  " disable banner
let g:netrw_browse_split=4 " open in prior window
let g:netrw_altv=1 "open splits to the right with v
let g:netrw_liststyle=3 "tree

" allow for recursive file searching
set path+=**

" Set line numbers
set number

" Sets how many lines of history VIM has to remember
set history=100

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed
set autoread

" autoread even when changed outside of vim
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader=" "

" Fast saving
nmap <leader>w :w!<cr>

" Fast search
nmap <leader>r :Rg

" Lazy macro repeat
nmap <leader>m @@

" start typing a search/replace command using current word
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Disabling auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the WiLd menu, tab completion of commands
set wildmenu
set wildmode=list:longest,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.log
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*,.tox\*,.build\*,.dist\*
endif

"Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" allows h and l to move to the next line if at a boundary
set whichwrap+=h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases, case ignored until caps typed
set smartcase

" Highlight search results
set hlsearch

" incrementally search, moving each time a key is pressed
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" split and automatically move to new pane
set splitright

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" highlight all replacements as they go, and preview in a split
if has('nvim')
    set inccommand=split
endif

" Auto jump to last spot exited in the current file
autocmd BufReadPost *
      \  if line("'\"") > 1 && line("'\"") <= line("$")
      \|   exe 'normal! g`"zvzz'
      \| endif

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
" TODO: Maybe remove?
"set lbr
"set tw=10

set ai "Auto indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Smart way to move between windows
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <silent> <leader>t :tabnew<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Splits
map <leader>v :vs<cr>

" Enable per project nvimrc
" TODO Remove?
"set exrc
"set secure

""""""""""""""""""""""""""""""
" => Debugging
""""""""""""""""""""""""""""""

" leader + insert python breakpoint
map <leader>pyd oimport pdb<ENTER>pdb.set_trace()<ESC>

" insert cjappl TODO
map <leader>c o//TODO: CJAPPL<ESC>

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Deleting whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

"autocmd BufWrite *.py :call DeleteTrailingWS()

"autocmd BufWrite *.cpp :call DeleteTrailingWS()
"autocmd BufWrite *.h :call DeleteTrailingWS()

"autocmd BufWrite *.vim :call DeleteTrailingWS()

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
map <leader>Y "*e
map <leader>p "*p
map <leader>P "*P

" Use system clipboard automatically
"set clipboard=unnamed

" set colon to semicolon
nnoremap ; :

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


function! HeaderSwitch()
    let l:extension = expand("%:e")

    if match(l:extension, "cpp") < 0 && match(l:extension, "h") < 0 && match(l:extension, "c") < 0
        echo "No matching header or cpp found"
        return
    endif

  if match(expand("%"), '\.c') > 0
    let l:next_file = substitute(".*\\\/" . expand("%:t"), '\.c\(.*\)', '.h[a-z]*', "")
  elseif match(expand("%"), "\\.h") > 0
    let l:next_file = substitute(".*\\\/" . expand("%:t"), '\.h\(.*\)', '.c[a-z]*', "")
  endif

  if exists("b:previous_file") && b:previous_file == l:next_file
    e#
  else
    let l:directory_name = fnamemodify(expand("%:p"), ":h")
    " At this point cmd might evaluate to something of the format:
    let l:cmd="find \"" . l:directory_name . "\" . -path ./contrib -prune -false -o -type f -iregex \""  . l:next_file . "\" -print -quit"

    " The substitute gets rid of the new line at the end of the result. The
    " function `filereadable` does not like the newline that `find` puts at
    " the end of the result and will not acknowledge that the file exists.
    let l:result = substitute(system(l:cmd), '\n', '', '')

    if l:result != 0
        echo l:cmd
        echo l:result
    endif

    if filereadable(l:result)
        let l:bnr = bufwinnr(l:result)
        if l:bnr > 0
            exe l:bnr . "wincmd w"
        else
          exe "vs " l:result
        endif
    endif
  endif
endfun

nnoremap <silent> <tab> :call HeaderSwitch()<CR>

" auto reload vimrc
augroup myvimrc
    au!
    au BufWritePost .vimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

function! ClangFormatFunction()
   let l:formatdiff = 1
   echom system("clang-format -style=file -i " . expand('%:p'))
   :e
endfunction
command Format   call ClangFormatFunction()

let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python'
