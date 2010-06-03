" Global leader key for shortcuts
let mapleader='\'

" Tab and shift-tab loop through the completion possibilities
"inoremap <S-tab> <c-r>=InsertTabWrapper ("backward")<cr>
"inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
let g:SuperTabMappingForward = '<c-n>'
let g:SuperTabMappingBackward = '<s-c-n>'
" Project plugin options
let g:proj_flags = 'gcsi'
let g:proj_window_width=30

" Suppress the no-ruby warning from Lusty Explorer
let g:LustyJugglerSuppressRubyWarning = 1

" -------------
" Function keys
" -------------

" Toggle search highlighting
map <silent> <F1> :set invhlsearch<CR>
" ToggleCommentify in both normal & insert mod
map <F2> ,cij
nmap <F2> ,cij

" CTags
map <F3> :tag<CR>
map <F4> :pop<CR>

" Toggle line numbers
nmap <silent> <F5> :set invnumber<CR>
map <silent> <F5> :set invnumber<CR>

" NERDTree
map <F8> :NERDTreeToggle<CR>
" Toggle highlighting lines over 80 characters
map <F9> :call Toggle80CharacterHighlight()<CR>
" Quick quit all
map <F10> :qa
" Syntax check PHP
map <F11> :w !php -l<CR>

" ----------
" Other keys
" ----------

" Use jj to exit insert mode
imap jj <Esc>

" Switch amongst splits with comma (,)
map , <C-w><C-w>

" backtick goes to the exact mark location, single-quote just the line; swap 'em
nnoremap ' `
nnoremap ` '

" Use CamelCaseWords motion instead of vim's defaults
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" Use Mark.vim via ctrl+m (enter)
nmap  \m

" Move around windows with ctrl key!
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" Switch tabs easily
nmap <Tab> gt

" CTags
nmap <leader>t 
nmap <leader>p :pop<CR>

" FuzzyFinder
nmap <leader>f :FufFile<CR>
nmap <leader>d :FufDir<CR>
nmap <leader>T :FufTag<CR>
