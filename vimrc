" VIMRC should be saved in ~/vimfiles/vimrc
" You need these directories to exist
"   ~/.vim
"   ~/vimfiles
"   ~/.vim/undofiles
"   ~/.vim/swapfiles
"  ~ on windows maps to c:\Users\Ron Anderson\

" Many settings are used from this vimrc example: https://github.com/scrooloose/vimfiles/blob/master/vimrc
" ---------------------------------------
" ------- Handle Plug-ins ---------------
" ---------------------------------------
" You have to install plugin manager named 'vim-plug' first.  https://github.com/junegunn/vim-plug.  Put it in ~/.vim/autoload directory
" Next 2 lines are needed for plugin manager to work
set nocompatible                        " Don't be compatible with vi
filetype off
set rtp+=~/.vim                         " This is so ~/.vim/ will be searched for scripts (autoload, etc..).  Otehrwise it can't find vim-plug or plugins that vim-plug adds to ~/.vim
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }       " :NERDTree to run
Plug 'ctrlpvim/ctrlp.vim'      " for MRU and filename search, quickly identify files u want to load
Plug 'tpope/vim-fugitive'      " for GIT integration into vim, use :Git
"Says not needed in newer vim ?  Plug 'google/vim-searchindex'  " type g/ to get index of last / or ? search.  Also shows N/M in status line as you type n or p again and again
call plug#end()
" Kite Plugin: Just manually install.  See https://github.com/kiteco/vim-plugin/blob/master/README.md
" Need to run :PlugInstall once to get it to install all your plugins on the system
" ---------------------------------------
" ------- END Handle Plug-ins -----------
" ---------------------------------------

filetype indent on
filetype plugin on
let mapleader=","
syntax enable
set et
set sw=4
set smarttab
set lsp=0
set nowrap!
"set gfn=Courier\ New:h8:cANSI
set gfn=Cascadia\ Code:h10:cANSI
" display tabs as minuses, and trialing spaces too
set list
set foldmethod=indent
set foldcolumn=2
set foldnestmax=3
set nofoldenable " dont fold by default
set fillchars=vert:\|

" turn off MRU script making a GUI menu, slows things down
" "
let MRU_Add_Menu=0

" current directory always matches active window!
set autochdir

" improves multiple buffer handling
set hidden

" make space open and close folds
nnoremap <space> za
nnoremap <S-space> zA
" status line
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

" special directory shortcuts
let $VIMRC=$MYVIMRC
let $HELPRON=$VIMRUNTIME."\\doc\\ron.txt"
" $VIMRUNTIME is vi install directory
" $VIMRC is _vimrc file
"
" improve file matching with <TAB>
set wildmenu
set wildmode=list:longest:full
set wildignore=*.o,*.obj,*~

"set shortmess+=A   " Turn this on if you hate that ATTENTION swap file message


set history=1000


source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin



"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk

"""" Searching and Patterns
set ignorecase                            " search is case insensitive
set smartcase                            " search case sensitive if caps on 
set incsearch                            " show best match so far
set hlsearch                            " Highlight matches to the search 

"""" Display
set background=light                        " I use dark background
set lazyredraw                            " Don't repaint when scripts are running
set scrolloff=3                            " Keep 3 lines below and above the cursor
set ruler                                " line numbers and column the cursor is on
set number                                " Show line numbering
set numberwidth=1                        " Use 1 col + 1 space for numbers
colorscheme tolerable                        " Use tango colors, Rdark is good, tolerable is light one

set mouse=a
if !has("nvim")
    set ttymouse=xterm2
endif

" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

set listchars=tab:>-,trail:·,eol:$,nbsp:·
nmap <silent> <leader><space> :set nolist!<CR>

if v:version >= 703
    "undo settings
    set undodir=~/.vim/undofiles
    set undofile
endif
set directory=~/.vim/swapfiles//

set diffexpr=MyDiff()
function MyDiff()
    let opt = ''
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    "silent execute '"!C:/Program Files/vim/diff" -a ' . opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
    "silent execute '\"!C:\Program Files\vim\diff\" -a ' . opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
    silen execute "!diff -a " . opt . v:fname_in . " " . v:fname_new . " > " . v:fname_out
endfunction

map <silent> <C-F1> :if &guioptions =~# 'T' <Bar>
                                          \set guioptions-=T  <Bar>
                                           \set guioptions-=m  <Bar>
                                      \else <Bar>
                                          \set guioptions+=T  <Bar>
                                           \set guioptions+=m  <Bar>
                                       \endif<CR>


" TABs (GUI element) at top of screen
function ShortTabLabel()
     let bufnrlist = tabpagebuflist(v:lnum)

     " show only the first 6 letters of the name + ..
     let label = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
     let filename = fnamemodify(label,':h')
     " only add .. if string is more than 8 letters
     if strlen(filename) >=8
          let ret=filename[0:5].'..'
     else
          let ret = filename 
     endif
     return ret
endfunction

function! InfoGuiTooltip()
    "get window count
    let wincount = tabpagewinnr(tabpagenr(),'$')
    let bufferlist='' "get name of active buffers in windows
    for i in tabpagebuflist()
        let bufferlist .= '['.fnamemodify(bufname(i),':t').'] '
    endfor
    return bufname($).' windows: '.wincount.' ' .bufferlist ' ' 
endfunction


set guitablabel=%{ShortTabLabel()}
"" How to remove tabs interactively :
"" set showtabline=0
"" set to 1 to dispaly again
set guioptions+=e


function! RonGetTailOfFile()
   let mypath = expand('%:t')
   " following line puts mypath contents onto clipboard 'register'
   "  yo unormally use this register with "*, but you set it with @*
   let @* = mypath
endfunction
function! RonGetFullPathOfFile()
   let mypath = expand('%:p')
   " following line puts mypath contents onto clipboard 'register'
   "  yo unormally use this register with "*, but you set it with @*
   let @* = mypath
endfunction
function! RonGetFullHeadOfFile()
   let mypath = expand('%:p:h')
   " following line puts mypath contents onto clipboard 'register'
   "  yo unormally use this register with "*, but you set it with @*
   let @* = mypath
endfunction

function! RonArrange3Windows()
   ":split
   ":wincmd r
   ":wincmd k
   ":vnew
   ":wincmd r
   ":vnew
   ":wincmd j
   ":cd c:\shared\scripts\parsers\vimParsers
   ":edit c:\shared\scripts\parsers\vimParsers
   :set lines=42 columns=120
   :new
   :wincmd k
   :vnew
   :wincmd k
   :wincmd h
endfunction

function! RonWideWindow()
    :set lines=42 columns=170
endfunction

function! RonSource3rdWindow()
   :wincmd j
   :source %
   :call RunParse()
endfunction
" These buttons are for running 3 vim window parsers inside of vim, using
" python, input, and output windows (vim windows)
"
amenu icon=Arrange3Windows ToolBar.Arrange3Windows :call RonArrange3Windows()<cr>

amenu icon=Arrange3Windows ToolBar.WideWindow :call RonWideWindow()<cr>

" 'source' the parser window , at the bottom..
amenu icon=SourceWin3 ToolBar.Source3rdWindow :call RonSource3rdWindow()<cr>


" now add a toolbar button to grab the path of the file for you
" amenu icon=c:\Program\ Files\Vim\vim71\bitmaps\hand_box.bmp ToolBar.GetPath :call RonGetPathOfFile()<CR>
amenu icon=hand_box ToolBar.GetFullHead :call RonGetFullHeadOfFile()<CR>
tmenu ToolBar.GetFullHead Copy head (path wo filename) of edited file to Clipboard
amenu icon=hand_box ToolBar.GetFullPath :call RonGetFullPathOfFile()<CR>
tmenu ToolBar.GeFulltPath Copy full path of edited file to Clipboard
amenu icon=hand_box ToolBar.GetTail :call RonGetTailOfFile()<CR>
tmenu ToolBar.GetTail Copy tail (name wo path) of edited file to Clipboard

"old--> amenu icon=PyToCmd ToolBar.PyRunInCmdWindow :w\|!start python %<cr>
" make sure python is in path
amenu icon=PyToCmd ToolBar.PyRunInCmdWindow :silent w\|silent !start python %<cr>
tmenu ToolBar.PyRunInCmdWindow Launch this file in python interpetrer in separate window <F10>
" I add another toolbar item as well, but it must be in another file -- "run
" python inside of vim"

" Lets get rid of unused toolbar buttons
aunmenu ToolBar.Open
aunmenu ToolBar.SaveAll
aunmenu ToolBar.Print
aunmenu ToolBar.Cut
"aunmenu ToolBar.Copy
aunmenu ToolBar.Paste
aunmenu ToolBar.-sep3-
aunmenu ToolBar.Replace
aunmenu ToolBar.FindNext
aunmenu ToolBar.FindPrev
aunmenu ToolBar.-sep5-
aunmenu ToolBar.Make
aunmenu ToolBar.RunCtags
aunmenu ToolBar.TagJump
"unmenu ToolBar.-sep7-
aunmenu ToolBar.Help
aunmenu ToolBar.FindHelp

"python << EOF
"def RunDebugger():
"   vim.command( 'wall')
"   #strFile = vim.eval( "g:mainfile")
"   strFile = vim.bufname('%')
"   vim.command( "!start python -m pdb %s" % strFile)
"vim.command( 'map <s-f12> :py RunDebugger()<cr>')
"EOF
"


" pdb automcomplete -- this is what you need to do
" figure out where 'HOME' is by :
"  import os
"  print os.environ['HOME']
" then look in $VIMRUNTIME/pythonStuff/PutInHome and copy those into HOME


" this remaps gp so that put will move the cursor to original position after
" pasting  ... this is great when pasting the same thing at same location 
" across multiple lines (e.g. pasting comments at not quite end of multiple lines)
noremap gp p`[h
noremap gP P`[




set termwinscroll=100000   " default is only 10000
" Switch to powershell for the shell
" "  Use :terminal to kick of a power shell session within VIM !
" "  Use :bot vert term  ... open term window on the right side vertically
if has('win32') || has('win64')
    set shell=powershell.exe
    set shellcmdflag=-NoProfile\ -NoLogo\ -NonInteractive\ -Command
    set shellpipe=|
    set shellredir=>
    " change the colors of terminal, otherwise you get yellow on white backgrnd
    let g:terminal_ansi_colors = [
      \ '#016e64', '#9d0a09',
      \ '#0d610d', '#0a7373',
      \ '#090d9a', '#6d696e',
      \ '#0d0a6f', '#616e0d',
      \ '#0a6479', '#6d0d0a',
      \ '#017373', '#0d0a69',
      \ '#0d690d', '#0a6e6f',
      \ '#010d0a', '#6e6479',
      \]
endif


" try to add python support thru dll
if has('win32') || has('win64')
    " seems like you cant just say python38.dll, it has to be the whole name
    set pythonthreedll=D:\Python\Python38-32\python38.dll
    " seems like you can't just put dll in vim directory, you have to point at
    " the whole python directory with this
    set pythonthreehome=D:\Python\Python38-32
    " to test it use something like :py3 print('hi')
    " i'm getting an error about import imp, but from then on it works
endif


" this stops it from doing the annoyin error message
silent! py3 << EOF
import os
import sys
import vim
EOF

" This mapping lets you put stuff between comments in python like this
"# %%
"for i in range(10):
"  print (i)
"  print ('yoyo')
"
"# %%
" And when you navigate cursor between the # %% , you can just type ,Y 
"   to yank everything in between comments to the clipboard.  So you cna paste
"   in python window or whatever
nnoremap <silent><leader>Y m`?^# %%<CR>jV/^# %%<CR>k"*y``
" Here is quicky to PASTE CLIPBOARD into TERMINAL vim window.  Just hit C-W +
" Enter, instead of the usual C-W + " + *
tnoremap <C-W><CR> <C-W>"*
" This will paste clipboard into the window on the right.  So if termainl
" window is definitely on the right this will paste clipboard there.
nnoremap <silent><leader>P <C-W>l<C-W>"*<C-W>p
" This will do it all in one go.  So just type <leader>p (,p) and you will
" paste the snippet right into python window, assuming it's on the right.
" BE VERY CAREEFUL that you are pasting INTO A TERMINAL to the RIGHT!!
nmap <silent><leader>T <leader>Y<leader>P

"nerdtree settings
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\~$', '__pycache__']
"explorer mappings
nnoremap <leader>nt :NERDTreeToggle<cr>
nnoremap <leader>nf :NERDTreeFind<cr>
nnoremap <leader>nn :e .<cr>
nnoremap <leader>nd :e %:h<cr>
"nnoremap <leader>] :TagbarToggle<cr>
nnoremap <leader>pp :CtrlP<cr>
nnoremap <leader>pb :CtrlPBuffer<cr>
nnoremap <leader>pm :CtrlPMRU<cr>
nnoremap <leader>pc :CtrlPCmdPalette<cr>
"nnoremap <c-f> :CtrlP<cr>
"nnoremap <c-b> :CtrlPBuffer<cr>

"command abbrevs we can use `:E<space>` (and similar) to edit a file in the
"same dir as current file
cabbrev E <c-r>="e "  . expand("%:h") . "/"<cr><c-r>=<SID>Eatchar(' ')<cr>
cabbrev Sp <c-r>="sp " . expand("%:h") . "/"<cr><c-r>=<SID>Eatchar(' ')<cr>
cabbrev SP <c-r>="sp " . expand("%:h") . "/"<cr><c-r>=<SID>Eatchar(' ')<cr>
cabbrev Vs <c-r>="vs " . expand("%:h") . "/"<cr><c-r>=<SID>Eatchar(' ')<cr>
cabbrev VS <c-r>="vs " . expand("%:h") . "/"<cr><c-r>=<SID>Eatchar(' ')<cr>
cabbrev R <c-r>="r " . expand("%:h") . "/"<cr><c-r>=<SID>Eatchar(' ')<cr>
function! s:Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" Things to learn
" v does character visual mode, V does line visual mode, CTRL-Q does block
" visual mode
" In visual mode, use a) to select all within ( ) parantehese.  Same for a]
" for [] braces.  Use i) and i] to select all within, but not the final
" enclosing parantheses themselves.  Also works on a< , a", a', a`
" When in visual mode, and selecgted some lines, use '>' to shift things right
" or left.  
" use ^ to jump to first NON-WHITE space character on line (as opposed to 0)
" use w to jump N words forward.  Kind of like e, but it puts you on FIRST
" character of NEXT word.
" ge goes backward , and lands on last character
" FORWARD+LAST_CHAR => e
" FORWARD+1ST__CHAR => w   Learn this one, it could make you a bit quicker
" BACKWAR+1ST__CHAR => b
" BACKWAR+1ST__CHAR => ge  not sure ill use this one
" Marks
" `` takes you back to previous place you jumped from
" `. or '. takes you back to previous change you made
" You can probably use these instead of setting marks in many cases
"
" Use CtrlP plugin, instead of MRU
"   <leader>pp   or <C-p>  bring up CtrlP window
"   <leader>pm   for MRU list !
"   <leader>pb   for BUFFER list
"   use <C-j> and <C-k> to selectr from list
"   or just start typing 'fuzzy' letters to narrow down the file
" Need to start using NerdTree too but don't know how
"   <leader>nt   to start nerdtree window
"   Type '?' for help


