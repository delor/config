function! InsertIfDef() 
    let filename=substitute(toupper(expand("%:t")), "\\.", "_", "g") 
    normal mi 
    normal gg
    execute "normal! i#ifndef " . filename . "\n"
    execute "normal! i#define " . filename . "\n\n\n"
    execute "normal! GA\n\n#endif /*      #ifndef " . filename . "     */" 
    normal 'i
endfunction
map <leader>ifdef        :call InsertIfDef()<CR>


function! InsertMain()
    normal G
    execute "normal! iint\nmain(int argc, char** argv)\n{\n\nreturn 0;\n}"
    execute "normal! kk$i    "
endfunction
map <leader>init        :call InsertMain()<CR>
