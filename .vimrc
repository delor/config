" {{{ [ console vim ]
if !has("gui_running")
  "colorscheme 256-jungle
  colorscheme vibrantink
endif
" }}}

" {{{ [ basics ]
syntax on

set nocompatible " don't be backwards compatible with silly vi options
set nobackup " nie tworz plikow bezpieczenstwa (file~)
set ruler " zawsze pokazuj pozycje kursora
set showcmd
set number " pokaz numeracje linii

set hlsearch " podswietl wszystkie znalezione slowa
set incsearch "For fast terminals can highlight search string as you type
set ignorecase " ignoruj wielkosc liter podczas wyszukiwania
set smartcase " wylacz ignorowanie jezeli w szykanej frazie wystepuje wielka litera

set tabstop=4 " ustawia wielkosc <Tab> w spacjach
set shiftwidth=4 " ilosc spacji uzyta jako wciecie
set softtabstop=4
set expandtab " zamienia <Tab> na spacje
set shiftround " wciecia sa wielokrotnoscia shiftwidth
set nojoinspaces " wylacza podwojne spacje po '.' '?' i '!'

set encoding=utf-8
set printencoding=iso-8859-2
set printfont=Bitstream\ Vera\ Sans\ Mono\ 8
set fileencodings=utf-8,latin2
set mouse=a " zapewnia obsluge myszki
set visualbell " zamiast nieprzyjemnych dzwiekow miga ekran
set nowrap " nie lubie zawijania wierszy
set cinwords=if,else,while,do,for,switch,case " dziala tylko przy cindent
"set cursorline " podswietla linie, w ktorej znajduje sie kursor
set t_Co=256 " ustawia ilosc kolorow
set backspace=2 " pozwala kasowac wszystko za pomoca <BS> w Insert mode
set viminfo='20,\"50 " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50 " keep 50 lines of command line history

set wildmenu " pokazuje uzupelnienia w menu
"set wildmode=list:longest
"Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

set autoindent
set smartindent
set foldmethod=marker
set pastetoggle=<F11> " po wcisnieciu F11 wlaczanony jest tryb wklejeania bez autoformatowania
" }}}

" {{{ [ proper title if working in screen ]
if $TERM=='screen'
  exe "set title titlestring=vim:%f"
  exe "set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif
" }}}

"Make the completion menus readable
highlight Pmenu ctermfg=0 ctermbg=3
highlight PmenuSel ctermfg=0 ctermbg=7

"flag problematic whitespace (trailing and spaces before tabs)
"note you get the same by doing let c_space_errors=1 but
"this rule really applys to everything.
"use :set list! to toggle visible whitespace on/off
highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted
set listchars=tab:>-,trail:.,extends:>

filetype on
filetype plugin on
filetype indent on
autocmd FileType * set formatoptions=tcql nocindent comments&

" {{{ [ c, c++ ]
autocmd FileType c,cpp,h,hpp set cindent formatoptions=croql textwidth=80 comments=sr:/*,mb:*,ex:*/,://
autocmd FileType c,cpp,h,hpp source ~/.vim/ftplugin/a.vim
autocmd FileType c,cpp,h,hpp source ~/.vim/ftplugin/c.vim
" }}}

" {{{ [ gpg ]
autocmd FileType gpg source ~/.vim/ftplugin/gpg.vim
" }}}

" {{{ [ keys ]
" allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X

" unbind arrow keys
" map <Right> <nop>
" map <Left> <nop>
" map <Up> <nop>
" map <Down> <nop>
" imap <Right> <nop>
" imap <Left> <nop>
" imap <Up> <nop>
" imap <Down> <nop>

" skrot dla omnicppcomplete, ctag generation
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ .<CR>

" }}}

" {{{ [ Abbreviations ]
"Define some nice abbreviations:
ab #d #define
ab #i #include
ab #b /************************************************
ab #e ************************************************/
ab #l /*----------------------------------------------*/
" }}}
