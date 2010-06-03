set nocompatible                " Ditch strict vi compatibility
" Clear existing autocommands
autocmd!
set backspace=indent,eol,start    " More powerful backspacing

set autoindent              " always set autoindenting on
set autowrite               " Autosave before commands like :next and :make
set textwidth=0             " Don't wrap words by default
set showcmd                 " Show (partial) command in status line.
set encoding=utf-8          " This being the 21st century, I use Unicode
set fileencoding=utf-8

set showmatch               " Show matching brackets.
set ignorecase              " Case insensitive matching
set smartcase               " Case sensitive matching if caps in search string
set hlsearch                " Highlight search matches
"set incsearch              " Incremental search

set wildmenu                " Use BASH style completion
set wildmode=list:longest

set complete=.,w,b,u,t,],s{*.pm}
set nobackup                " Don't keep a backup file
set history=5000            " Keep 5000 lines of command line history
set viminfo='20,\"50        " Read/write a .viminfo file, don't store more than
                            " 50 lines of registers

" Visual stuff
set showcmd                 " Show information about ranges in the ruler
set laststatus=2
set ruler                   " Show the cursor position all the time
set title                   " Show title in title bar
"set cursorline             " Highlight the current line
" Show tabs as ▷⋅ and trailing spaces as⋅
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
"set list
"set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" Make tabs be spaces instead
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

" Turn off the button bar in gvim
set guioptions-=T
set guioptions-=m
" No scrollbars
set guioptions-=r
set guioptions-=l
set guioptions-=R
set guioptions-=L
set guifont=monospace\ 8
set mousehide

" Statusline
set statusline=%f           "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]     "file format
set statusline+=%h          "help file flag
set statusline+=%m          "modified flag
set statusline+=%r          "read only flag
set statusline+=%y          "filetype
" Warn if there are mixed tabs & spaces or if expandtab is wrong
"set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" Recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning
" return '[&et]' if &et is set wrong
" return '[mixed-indenting]' if spaces and tabs are used to indent
" return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

" Recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning
" return '[\s]' if trailing white space is detected
" return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

syntax on
set background=dark
colors peachpuff-drew
"colors koehler-drew
"colors drew
"colors contrasty
"colors koehler
"colors ir_black
"colors murphy
"colors torte
"colors elflord
"colors ron

filetype plugin indent on
" Extra filetypes
au BufNewFile,BufRead *.jst set filetype=javascript
au BufNewFile,BufRead *.t set filetype=perl
" For Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent
" Keep comments indented
inoremap # #
" For C-like programming, cindent is the way to go
autocmd FileType c,cpp,slang set cindent
" make requires real tabs
autocmd FileType make set noexpandtab shiftwidth=8
" Check for file changes (svn ci, etc.) periodically and on window & buffer
" switches
autocmd CursorHold * checktime
autocmd WinEnter * checktime
autocmd BufWinEnter * checktime

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
"http://structurallysoundtreehouse.com/my-almost-perfect-vim-files
"http://github.com/fredlee/mydotfiles/tree/master
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c' && &filetype !~ 'svn\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal g`\""
    endif
  end
endfunction

" Omni Completion
autocmd FileType html :set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" Highlight lines over 80 characters long
hi LineTooLong cterm=bold ctermbg=darkgreen gui=bold guibg=darkgreen
let hl80char = 0
function Toggle80CharacterHighlight()
    if g:hl80char == 0
        match LineTooLong /\%>80v.\+/
        let g:hl80char = 1
    else
        match
        let g:hl80char = 0
    endif
    return
endfunction

" Highlight the selected line when jumping
function s:Cursor_Moved()
  let cur_pos = winline()
  if g:last_pos == 0
    set cul
    let g:last_pos = cur_pos
    return
  endif
  let diff = g:last_pos - cur_pos
  if diff > 1 || diff < -1
    set cul
  else
    set nocul
  endif
  let g:last_pos = cur_pos
endfunction
autocmd CursorMoved,CursorMovedI * call s:Cursor_Moved()
let g:last_pos = 0

""" Correct misspellings
"abbreviate foo foobar

source $HOME/.vim/statusline.vim
source $HOME/.vim/mappings.vim
set mouse =a
set number
