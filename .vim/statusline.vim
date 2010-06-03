" Statusline
set statusline=%f           "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]     "file format
set statusline+=%h          "help file flag
set statusline+=%m          "modified flag
set statusline+=%r          "read only flag
set statusline+=%y          "filetype
" Warn if there are mixed tabs & spaces or if expandtab is wrong
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*
" Warn if there is trailing whitespace
set statusline+=%{StatuslineTrailingSpaceWarning()}
" Warn if there are long lines (greater than 80 or textwidth)
set statusline+=%{StatuslineLongLineWarning()}
set statusline+=%#warningmsg#
" Check for syntax errors
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" Recalculate the tab warning flag when idle and after writing
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
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
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
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

" Recalculate the long line warning when idle and after saving
" http://got-ravings.blogspot.com/2009/07/vim-pr0n-combating-long-lines.html
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning
"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction
"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction
"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction
