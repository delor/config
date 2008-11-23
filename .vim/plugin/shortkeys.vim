" {{{ [ indent all and remember position ]
fun! IndentALL()
    let cursor_pos = getpos(".")
    normal H
    let cursor_top = getpos(".")
    normal gg=G
    call setpos('.', cursor_top)
    normal zt
    call setpos('.', cursor_pos)
endfun
map <leader>= :call IndentALL()<cr>
" http://taeril.jogger.pl/2007/09/18/vim-poprawianie-wciec/
" }}}
