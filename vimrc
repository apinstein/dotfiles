set nocp

" vundle setup
" from: http://www.charlietanksley.net/philtex/sane-vim-plugin-management/
"filetype off " supposed to be required, but seems to work without it; when I
"turn it on vim always exists with status 1 BOO
set rtp+=~/.vim/vundle/ 
call vundle#rc()
" vim bundles
Bundle 'surround.vim'
Bundle 'vim-scripts/Align'
" /vim bundles
" /vundle setup

filetype plugin on
filetype plugin indent on

" change the mapleader from \ to ,
let mapleader=","

" mouse support
if has("mouse")
    set mouse=a
    set ttymouse=xterm2
endif

" http://www.vim.org/scripts/script.php?script_id=1984
" (depends on) http://www.vim.org/scripts/script.php?script_id=3252
nmap <Leader>f :FufFileWithCurrentBufferDir<CR>
nmap <Leader>b :FufBuffer<CR>
nmap <Leader>f :FufTaggedFile<CR>

" for moving between windows with ease:
map <C-j> <C-w>j80<C-w>+ " up one window, maximized
map <C-k> <C-w>k80<C-w>+ " down one window, maximized
map <C-h> 80<C-w>+ " maximize current window
map <C-i> <C-w>= " all windows equal height

map <F6> :!osascript -e 'tell application "Safari"' -e 'set URL of document 0 to (get URL of document 0)' -e 'activate' -e 'end tell'<CR>
nnoremap <silent> <F7> :Tlist<CR>  " Tlist plugin toggle

"set backspace=2   " allow backspacing over everything in insert mode
set hlsearch
highlight Search cterm=reverse ctermfg=lightyellow ctermbg=black
highlight PmenuSel ctermbg=1                                                                                                                                                             
" clear search highlight temporariliy, but do not disable hlsearch
map <F12> :nohls<CR>
" mappings for easy navigation of :grep results and compile errors
map <F2> :cwindow<CR>
map <F3> :cnext<CR>
map <F4> :cprev<CR>
map <F5> :cclose<CR>
set wrap
set expandtab
set sw=4  " shift width 
set ts=4  " tab stop
set modelines=10
set noerrorbells
" set magic " extend regexp with magic(do help magic) -- I don't think I want this b/c it makes PHP preg and vim act differently and it's confusing
set bs=indent,eol,start
set pastetoggle=<F5>   " meta-p (works on mac, not sure elsewhere)
set smartindent   
set autoindent    " always set autoindenting on
set formatoptions=qroct
set textwidth=0   " Don't wrap words by default
set nobackup    " Don't keep a backup file
set nowritebackup
set viminfo='20,\"50  " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50    " keep 50 lines of command line history
set ruler   " show the cursor position all the time
set showmode " show current vi mode
set showcmd   " Show (partial) command in status line.
set showmatch   " Show matching brackets.
set autowrite    " Automatically save before commands like :next and :make
set fileformats=unix,mac,dos " accepted file formats
set ignorecase smartcase
set linebreak

" syntax coloring
syntax on
" add flash syntax support, from http://www.abdulqabiz.com/blog/archives/flash_and_actionscript/vim_actionscript_and.php
au BufNewFile,BufRead *.as set filetype=actionscript syntax=actionscript
au BufNewFile,BufRead *.php set filetype=php syntax=php

" php options - eventually put these in an autocmd group or whatever to make them local to PHP files
set keywordprg=~/.vim/php_lookup " map shift-k to lookup commands on PHP web site
set dictionary+=~/.vim/dictionaries/phpproto
let php_sql_query=1
let php_htmlInStrings=1
compiler php

" autocompletion config
" see http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
set completeopt=longest,menuone
" enter key autocomplete selected item
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" tab key autocomplete selected item
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" add dictionaries to autocomplete
set complete+=k
" command-mode autocompletion sanity
set wildmode=list:longest

" search for a tags file in dir containing file being worked on, and keep
" going up dirs until a tags file is found
" requires +path_extra to work properly
set tags+=./tags;

" Function to close HTML tags
nnoremap \hc :call InsertCloseTag()<CR>
imap <F12> <Space><BS><Esc>\hca
function! InsertCloseTag()
" inserts the appropriate closing HTML tag; used for the \hc operation defined
" above;
" requires ignorecase to be set, or to type HTML tags in exactly the same case
" that I do;
" doesn't treat <P> as something that needs closing;
" clobbers register z and mark z
" 
" by Smylers  http://www.stripey.com/vim/
" 2000 May 3

  if &filetype == 'html' || &filetype == 'smarty'
  
    " list of tags which shouldn't be closed:
    let UnaryTags = ' area base br hr img input link meta param '

    " remember current position:
    normal mz

    " loop backwards looking for tags:
    let Found = 0
    while Found == 0
      " find the previous <, then go forwards one character and grab the first
      " character plus the entire word:
      execute "normal ?\<LT>\<CR>l"
      normal "zyl
      let Tag = expand('<cword>')

      " if this is a closing tag, skip back to its matching opening tag:
      if @z == '/'
        execute "normal ?\<LT>" . Tag . "\<CR>"

      " if this is a unary tag, then position the cursor for the next
      " iteration:
      elseif match(UnaryTags, ' ' . Tag . ' ') > 0
        normal h

      " otherwise this is the tag that needs closing:
      else
        let Found = 1

      endif
    endwhile " not yet found match

    " create the closing tag and insert it:
    let @z = '</' . Tag . '>'
    normal `z"zp

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The InsertCloseTag() function is only intended to be used in HTML ' .
      \ 'files.'
    sleep
    echohl None
  
  endif " check on filetype

endfunction " InsertCloseTag()

" Map ; to run linter for file type
function! DoLint()
  if &filetype == 'javascript'
    " find the next non-closing tag (in the appropriate direction), note where
    " it is (in mark j) in case this function gets called again, then yank it
    " and paste a copy at the original cursor position, and store the final
    " cursor position (in mark i) for use next time round:
    execute ":!jsl -process % | head -20"

  elseif &filetype == 'xml'
    execute ":!xmllint -format % | head -20"
  elseif &filetype == 'ruby' || &filetype == 'rb'
    execute ":!ruby -c % | head -20"
  elseif &filetype == 'php'
    execute ":!/usr/bin/php -l % | head -20"
  else
    echohl ErrorMsg
    echo 'No linter set up for filetype' &filetype
    sleep
    echohl None
  endif

endfunction " RepeatTag()
noremap ; :call DoLint()<CR>
" alternative
map! =if if (<Right><CR>{<Up><Up>
" PHPDocumenter docbloc
map! =dbg /**<CR><CR><CR><CR><CR>/
map! =dbv /**<CR>@var <CR>/<Up><ESC>A
map! =dbf /**<CR><CR><CR>@param <CR>@return<CR>@throws<CR>/<Up><Up><Up><Up><Up><ESC>A
map! =dbt /**#@+<CR><CR>/<CR>/**#@-*/<CR><ESC><Up>
" phocoa validator autocomplete
map! =kvv public function validate(&$value, &$edited, &$errors)<CR>{<CR>return true;<CR>}<ESC>3<Up>3ea

" function to repeat HTML tags used previously in file (like ctl-n / ctl-p but for HTML tags)
nnoremap \hp :call RepeatTag(0)<CR>
imap <F6> <Space><BS><Esc>\hpa
nnoremap \hn :call RepeatTag(1)<CR>
imap <F7> <Space><BS><Esc>\hna
function! RepeatTag(Forward)
" repeats a (non-closing) HTML tag from elsewhere in the document; call
" repeatedly until the correct tag is inserted (like with insert mode <Ctrl>+P
" and <Ctrl>+N completion), with Forward determining whether to copy forwards
" or backwards through the file; used for the \hp and \hn operations defined
" above;
" requires preservation of marks i and j;
" clobbers register z
" 
" by Smylers  http://www.stripey.com/vim/
" 2000 Apr 30

  if &filetype == 'html' || &filetype == 'smarty'

    " if the cursor is where this function left it, then continue from there:
    if line('.') == line("'i") && col('.') == col("'i")
      " delete the tag inserted last time:
      if col('.') == strlen(getline('.'))
        normal dF<x
      else
        normal dF<x
        if col('.') != 1
          normal h
        endif
      endif
      " note the cursor position, then jump to where the deleted tag was found:
      normal mi`j

    " otherwise, just store the cursor position (in mark i):
    else
      normal mi
    endif

    if a:Forward
      let SearchCmd = '/'
    else
      let SearchCmd = '?'
    endif
      
    " find the next non-closing tag (in the appropriate direction), note where
    " it is (in mark j) in case this function gets called again, then yank it
    " and paste a copy at the original cursor position, and store the final
    " cursor position (in mark i) for use next time round:
    execute "normal " . SearchCmd . "<[^/>].\\{-}>\<CR>mj\"zyf>`i\"zpmi"

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The RepeatTag() function is only intended to be used in HTML files.'
    sleep
    echohl None
  
  endif

endfunction " RepeatTag()
