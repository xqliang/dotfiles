if (has("win32") || has("win64"))
    let g:isUnix=0
else
    let g:isUnix=1
endif

function! MakeDir (dir)
    """Make directory if `dir` not exists"""
    if !isdirectory(a:dir)
        if exists("*mkdir")
            call mkdir(a:dir, 'p')
            echo "Created directory: " . a:dir
        else
            echo "Please create directory: " . a:dir
        endif
    endif
endfunction

call MakeDir($HOME . '/.vim/backup')
call MakeDir($HOME . '/.vim/swap')

set nocompatible
set backup writebackup
set backupdir=$HOME/.vim/backup " Where to put backup file
set directory=$HOME/.vim/swap   " Where to put swap file
"set mouse=a
set noerrorbells novisualbell
set hlsearch incsearch
set ignorecase smartcase        " Searches case-sensitive only if they
                                " contains upper-case letter
set shortmess+=I                " Hide the launch screen
set viminfo='20,\"50            " Store command/search/.. history in .viminfo
set showcmd
set wildmenu wildignore=*.o,*~,*.pyc
if g:isUnix
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif


" Encoding
set ambiwidth=double
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk
set fileformats=unix,dos,mac
set termencoding=utf-8
if (!g:isUnix && has("gui_running"))
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    " Remove guioptions: left,right,bottom scroll bars, menu bar, toolbar
    set go-=L
    set go-=l
    set go-=R
    set go-=b
    set go-=m
    set go-=T
endif


" Editor
set autoindent
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set cursorline
set expandtab
set foldmethod=syntax
set foldlevel=100        " Do not fold when open file
set foldcolumn=0         " No fold column
set nonumber
set nolist listchars=tab:»\ ,trail:-,extends:>
set scrolloff=3          " Keep more context when scrolling off the end of a buffer
set shiftwidth=4
set smartindent
set smarttab
set tabstop=4
"set textwidth=78
if v:version >= 703
    call MakeDir($HOME . '/.vim/undo')
    set undofile        " Keep a persistent undo file
    set undodir=$HOME/.vim/undo,/tmp
    au BufWritePre ~/.vim/undo/* setlocal noundofile
    au BufWritePre /tmp/* setlocal noundofile
endif
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
" Or put it to .bashrc: export LESS="-X"
set t_ti= t_te=
set timeout timeoutlen=800 ttimeoutlen=100


" Color
syntax enable
filetype plugin on

" Hilight text over length (set colorcolumn=80)
au BufEnter *.py,*.c,*.cpp,*.h let w:over80=matchadd('ErrorMsg', '\%>80v.\+', -1)
au filetype python,java,javascript,css setlocal number
au filetype vim,python,java,rst,ruby,javascript,css setlocal list

" Have Vim jump to the last position when reopening a file
au BufReadPost * exe "normal! g`\""


" Custom key mappings
let mapleader=","
nnoremap ; :
cnoremap ;; <C-U><Esc>
" Quickly get out of insert mode without your fingers having to leave the
" home row, equals to <ESC>,<C-C>,<C-[>
inoremap ;; <Esc>
inoremap jj <Esc>
inoremap jw <Esc>:w<CR>a
" Quickly Esc, save file, close file and reload vimrc
nnoremap <leader><leader>w :w<CR>
nnoremap <leader><leader>q :q<CR>
nnoremap <leader><leader>r :so $MYVIMRC<CR>
" Pull word under cursor into LHS of a substitute (for search and replace)
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#
" Clear out a search
nnoremap <leader><space> :noh<CR>
" Keep only this window/tabpage open
nnoremap <leader>ow :only<CR>
nnoremap <leader>ot :tabonly<CR>
" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %
" Force saving files that require root permission
cnoremap W<CR> w !sudo tee > /dev/null %<CR>

" Switch window
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Split window
nnoremap \ :vsp<space>
nnoremap - :sp<space>

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" Move cursor together with the screen
nnoremap <DOWN> gj<C-E>
nnoremap <UP> gk<C-Y>


" Translate
" INSTALL:
"   $ sudo apt-get install sdcv
"   $ mkdir -p ~/.stardict/dic
"   $ wget http://abloz.com/huzheng/stardict-dic/zh_CN/stardict-langdao-ec-gb-2.4.2.tar.bz2
"   $ tar -xvjf stardict-langdao-ec-gb-2.4.2.tar.bz2 -C ~/.stardict/dic
" KEYS:
"   F Translate word under cursor in normal mode
function! DictTranslate()
    let expl=system('sdcv --utf8-output -n ' . expand("<cword>"))
    windo if expand("%")=="__startdict__" | q! | endif
    35vsp __startdict__
    setlocal buftype=nofile bufhidden=hide noswapfile
    1s/^/\=expl/
    1
endfunction
nnoremap F :call DictTranslate()<CR>


" Run
set makeprg=g++\ -Wall\ -o\ %<.exe\ %
func! CompileRun()
    exec "w"
    if &filetype == "c"
        exec "!gcc % -g -o %<.exe"
        exec "!./%<.exe"
    elseif &filetype == "cpp"
        exec "!g++ % -g -o %<.exe"
        exec "!./%<.exe"
    elseif &filetype == "java"
        exec "!javac %"
        exec "!java %<"
    elseif &filetype == "ruby"
        exec "!ruby %<.rb"
    elseif &filetype == "haskell"
        exec "!ghc --make %<.hs -o %<"
        exec "! %<.exe"
    elseif &filetype == "perl"
        exec "!perl %<.pl"
    elseif &filetype == "python"
        exec "!python %<.py"
    elseif &filetype == "lua"
        exec "!lua %<.lua"
    elseif &filetype == "sh"
        exec "!bash %<.sh"
    elseif &filetype == "go"
        exec "!gccgo -Wall %<.go -o %<"
        exec "! ./%<"
    elseif &filetype == "make"
        exec "!colormake"
        exec "! ./app"
    elseif &filetype == "io"
        exec "!io %<.io"
    endif
endfunc
map <F5> :call CompileRun()<CR>


" Vundle
"
"   The plug-in manager for Vim
"
" INSTALL:
"   $ sudo apt-get install git
"   $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"   $ vim +BundleInstall +qall
"
" Brief help
"   :BundleList          - list configured bundles
"   :BundleInstall(!)    - install (update) bundles
"   :BundleSearch(!) foo - search (or refresh cache first) for foo
"   :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle commands are not allowed.

set nocompatible              " be iMproved
filetype off                  " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


" Let Vundle manage Vundle, required!
Bundle 'gmarik/vundle'


" Python syntax check on the fly
Bundle 'pyflakes.vim'


" Auto generate tags & scope files, for python, install pycsope==0.3
"   $ sudo pip install pycscope==0.3
" KEYS:
"   <F4> (re)Generate tags&cscope.out
"   <F3> Add addtional ctags file
Bundle 'autotags'
let g:autotags_ctags_opts="--python-kinds=-iv --c++-kinds=+p --fields=+ialS
        \ --extra=+q"
let g:autotags_cscope_file_extensions=".py .cpp .cc .cxx .m .hpp .hh .h .hxx
        \ .c .idl"
au BufEnter *.py let g:autotags_no_global=1 | if executable('pycscope.py') |
        \ let g:autotags_cscope_exe="pycscope.py -i cscope.files -- " | endif
au BufLeave *.py let g:autotags_cscope_exe="cscope"


" Cscope key mapping
" KEYS:
"   <C-\>{s|g|d|c|t|e|f|i} Find symbol|definition|called by|calling this|
"                          text string|egrep|file|files #including this file
Bundle 'steffanc/cscopemaps.vim'


" Text Objects based on Indentation Level
" KEYS:
"   vai, vii, vaI
Bundle 'vim-indent-object'


" Expand/shrink region in V mode
" KEYS:
"   + Expand region
"   - Shrink region
Bundle 'terryma/vim-expand-region'


" Pairs of handy bracket mappings
" KEYS:
"   co{c|w|n|l|h|i|p} Toggle cursorline,wrap,number,list,hlsearch,
"                     ignorcase,paste
"   ]q                is :cnext
"   [q                is :cprevious
"   ]a                is :next
"   [b                is :bprevious
Bundle 'tpope/vim-unimpaired.git'
nnoremap cop :setlocal paste!<cr>


" Toggle locationlist, quickfix: <leader>l|q
Bundle 'Valloric/ListToggle'
nnoremap coq :QToggle<CR>
nnoremap coL :LToggle<CR>


" Status line (replace vim-powerline)
Bundle 'bling/vim-airline'
set laststatus=2 " Always show the statusline
set t_Co=256     " Explicitly tell Vim that the terminal supports 256 colors
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_z='%2p%% %2l:%-2c'


" Show function prototype in command line when type '('
Bundle 'echofunc.vim'


" Show buffers in command line when open/write file
" KEYS:
"   {n}<c-^> n'th buffer
"   <c-^>    Prev buffer
"   :e#      Next buffer
"   :ls      List buffers
Bundle 'buftabs'
nnoremap <leader>bt :call Buftabs_show(-1)<CR>
let g:buftabs_only_basename=1
let g:buftabs_separator=" "


" Insert or delete brackets, parens, quotes in pair
Bundle 'jiangmiao/auto-pairs'
" NOTE: Not auto pair (, because it shadow the echofunc
let g:AutoPairs={'[':']', '{':'}',"'":"'",'"':'"', '`':'`'}


" Fast and Easy Find and Replace Across Multiple Files
" KEYS:
"   <leader>{vv|vV|va|vA|vr|vo} Grep for the word under the cursor, match all
"                               occurences
"   :ReplaceUndo                Undoes the last :Replace operation
Bundle 'EasyGrep'


" Fuzzy file, buffer, mru, tag, etc finder
" KEYS:
"   <C-P>
Bundle 'kien/ctrlp.vim.git'
let g:ctrlp_cmd='CtrlPMixed'
let g:ctrlp_custom_ignore='\v[\/]\.(git|hg|svn)$'


" Easy commenting of code for many filetypes
" KEYS:
"   [count]<leader>cc       Comment out the current line or text selected
"   [count]<leader>c<space> Toggles the comment state of the selected line(s)
"   [count]<leader>cu       Uncomments the selected line(s)
"   [count]<leader>cA       Adds comment delimiters to the end of line and goes
"                           into insert mode between them. 
Bundle 'scrooloose/nerdcommenter'


" A tree explorer plugin for navigating the filesystem
Bundle 'scrooloose/nerdtree'
nnoremap <leader>nt :NERDTreeToggle<CR>


" Displays tags in a window, ordered by class etc (replace taglist.vim)
Bundle 'Tagbar'
nnoremap <leader>tb :TagbarToggle<CR>
let g:tagbar_width=30
au filetype python,java,c,cpp silent! nested :TagbarOpen


" Perform all your vim insert mode completions with Tab
Bundle 'ervandew/supertab'
let g:SuperTabDefaultCompletionType=""


" Ultimate auto-completion system
Bundle 'Shougo/neocomplcache.vim'
let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_disable_auto_complete=1


" Molokai color scheme
Bundle 'molokai'
silent! colorscheme desert
silent! colorscheme molokai


if v:version >= 703
    " A code-completion engine (repalce SuperTab & neocomplcache)
    "Bundle 'Valloric/YouCompleteMe'
    "set g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
    "set g:ycm_extra_conf_globlist=[]
    "set g:ycm_min_num_of_chars_for_completion=1
    "noremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

    " Zoom in/out of windows
    " KEYS:
    "   <C-W>o Toggle window size
    Bundle 'ZoomWin'
endif


if has("conceal")
    " Display the indention levels with thin vertical lines
    Bundle 'Yggdroot/indentLine'
    nnoremap <leader>il :IndentLinesToggle<CR>
    " NOTE: too slow when file lines > 2K
    let g:indentLine_fileType=['python', 'java', 'h', 'c', 'cpp']
    let g:indentLine_enabled=0
endif


" Other maybe useful plugins
"Bundle 'Mark'
"Bundle 'matchit.zip'
"Bundle 'python_match.vim'
"Bundle 'scrooloose/syntastic.git'
"Bundle 'surround.vim'
"Bundle 'TxtBrowser'
"Bundle 'YankRing.vim'


filetype plugin indent on     " required!
