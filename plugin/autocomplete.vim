let g:vsa#min_char_to_popup = 4


function! s:GetListDirs()
    let find_res = system('find ' . getcwd(0) . ' -type d')
    return substitute(find_res, '\n', ',', 'g')[0:-2]
endfunc


function! s:GetLastToken()
    let current_line = getline('.')
    let cursor_pos = getcurpos()[2] - 2
    let current_line = current_line[0:cursor_pos]
    let splitted = split(current_line, '\W\+', 1)

    if len(splitted) < 1
        return ''
    endif

    return splitted[-1]
endfunc


function! s:CompletionPopupMenu()
    let last_token = s:GetLastToken()
    echom last_token

    if len(last_token) + 1 < g:vsa#min_char_to_popup
        return
    endif

    if !pumvisible() && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z'))
        " call feedkeys("\<C-x>\<C-o>", "n")
        call feedkeys("\<C-x>\<C-n>", "n")
    endif 
endfunc


function! s:AutoPopup()
    if exists('g:vsa#enable_auto_popup') && g:vsa#enable_auto_popup
        autocmd InsertCharPre * call s:CompletionPopupMenu()
    endif
endfunc


autocmd VimEnter * call s:AutoPopup()
