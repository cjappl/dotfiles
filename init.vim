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
" => vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shell=bash
set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

" Plugins
Plug 'ayu-theme/ayu-vim'
Plug 'dag/vim-fish', {'for': 'fish'}
Plug 'edkolev/tmuxline.vim'
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'github/copilot.vim'
Plug 'neoclide/coc.nvim' , {'branch': 'release'}
Plug 'pboettch/vim-cmake-syntax', {'for': 'cmake'}
Plug 'tpope/vim-fugitive', {'on': 'Git'}
Plug 'vim-airline/vim-airline'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'ibhagwan/fzf-lua'

" telescope
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-treesitter/nvim-treesitter'
"Plug 'nvim-telescope/telescope.nvim'
"Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

" End configuration, makes the plugins available
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set peekaboo window so it's a bit bigger
let g:peekaboo_window = "vert bo 45new"

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
" => Coc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gu <Plug>(coc-references)
nmap <leader>f <Plug>(coc-fix-current)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)

nnoremap <silent> <tab> :vs<CR>:CocCommand clangd.switchSourceHeader<CR>

let g:coc_disable_transparent_cursor = 1

inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"


" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
"inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ctrlp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" disable search of certain folders
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](build|log|__pycache__|\.git|\.hg|\.svn|.+\.egg-info|cmake-build.+|build_xcode|bin|objs|target)$',
    \ 'file': '\v\.(lst|so|swp|zip|gz|tar|png|jpg|pyc|o|a|pc|jam|la)$'
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

" visualize tabs
set listchars=tab:▷▷⋮
set invlist

" highlight all replacements as they go, and preview in a split
if has('nvim')
    set inccommand=split
endif

" Auto jump to last spot exited in the current file
autocmd BufReadPost *
      \  if line("'\"") > 1 && line("'\"") <= line("$")
      \|   exe 'normal! g`"zvzz'
      \| endif

" highlight matching paren
highlight MatchParen ctermbg=black guibg=grey

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
"let tabSize = 4
"execute "set shiftwidth=" . tabSize
"execute "set tabstop=" . tabSize
"execute "set softtabstop=" . tabSize

" temporary for llvm
set tabstop=2 softtabstop=2 shiftwidth=2

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

autocmd BufWrite *.py :call DeleteTrailingWS()

autocmd BufWrite *.c :call DeleteTrailingWS()
autocmd BufWrite *.cpp :call DeleteTrailingWS()
autocmd BufWrite *.h :call DeleteTrailingWS()
autocmd BufWrite *.ll :call DeleteTrailingWS()
"autocmd BufWrite *.rst :call DeleteTrailingWS()
autocmd BufWrite Makefile :call DeleteTrailingWS()

autocmd BufWrite *.vim :call DeleteTrailingWS()

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


lua << EOF

-- taken from the max perf, but making it always horizontal
-- https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/profiles/max-perf.lua
require'fzf-lua'.setup {
  winopts = { preview = {
    default = "bat",
    vertical       = 'down:45%',      -- up|down:size
    horizontal     = 'right:60%',     -- right|left:size
    layout         = 'horizontal',    -- horizontal|vertical|flex
    flip_columns   = 120,             -- #cols to switch to horizontal on flex
  } },
  manpages = { previewer = "man_native" },
  helptags = { previewer = "help_native" },
  lsp = { code_actions = { previewer = "codeaction_native" } },
  tags = { previewer = "bat" },
  btags = { previewer = "bat" },
  files = { fzf_opts = { ["--ansi"] = false } },
  defaults = {
    git_icons = false,
    file_icons = false,
  },
}

EOF

"nnoremap <leader>f <cmd>lua require("telescope.builtin").live_grep({ additional_args = function() return { "--trim" } end })<cr>
" nnoremap <C-p> <cmd>Telescope find_files<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>


nnoremap <c-P> <cmd>lua require('fzf-lua').files()<CR>
nnoremap <leader>r <cmd> lua require('fzf-lua').live_grep_native()<CR>
nnoremap <leader>f <cmd> lua require('fzf-lua').grep_cword()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Copilot
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

imap <silent><script><expr> <S-Tab> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
nmap <silent> <C-x> <Plug>(copilot-dismiss)
nnoremap <silent> <leader>c :call CopilotToggle()<CR>

function! CopilotToggle()
    if g:copilot_enabled == v:true
        let g:copilot_enabled = v:false
        :Copilot disable
        echo "Copilot disabled"
    else
        let g:copilot_enabled = v:true
        :Copilot enable
        echo "Copilot enabled"
    endif
endfunction

" Default disable copilot
let g:copilot_enabled = v:false


"nmap <silent> <A-n> <Plug>(copilot-next)
"nmap <silent> <A-p> <Plug>(copilot-prev)
"nmap <silent> <leader>cc <Plug>(copilot-suggest)


"""""""""" VERTICAL UP/DOWN """"

xnoremap <leader>cd /\%<C-R>=virtcol(".")<CR>v\S<CR>
xnoremap <leader>cu ?\%<C-R>=virtcol(".")<CR>v\S<CR>


function! ShowCurrentBufferPath()
    " Get the full path of the current buffer
    let l:bufferPath = expand('%:p')

    " Echo the path to the command line
    echo l:bufferPath
endfunction

highlight ColorColumn guibg=DarkGrey
call matchadd('ColorColumn', '\%82v', 100)
"set colorcolumn=82

