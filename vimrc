" Nick Zwart's vim settings
"vim help files are in /usr/share/vim/vim70/doc/*.txt
"or :help
"
" Things to remember:
"   * to open the last closed file in a split window do:
"       :split#
"       :sp#
"       :vsp#

" vim/colors/solarized.vim
" avoid undercurl error by either setting to underline or:
set t_Cs=

" http://vim.1045645.n5.nabble.com/Corrupt-display-when-editing-remotely-via-ssh-td5730732.html
" Work-around for garbage/corrupt edit display back to
" macOS XQuartz (X11) server with newer vi/vim
" It requires that you set it to an invalid term 'dummy' and then to a valid
" one.
if (&term == 'xterm')
  set term=dummy
  set term=xterm
endif
if (&term == 'xterm-256color')
  set term=dummy
  set term=xterm-256color
endif

":highlight ExtraWhitespace ctermbg=red guibg=red
" The following alternative may be less obtrusive.
":highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" Try the following if your GUI uses a dark background.
:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/
" Show trailing whitespace and spaces before a tab:
":match ExtraWhitespace /\s\+$\| \+\ze\t/
" Show tabs that are not at the start of a line:
":match ExtraWhitespace /[^\t]\zs\t\+/
" Show spaces used for indenting (so you use only tabs for indenting).
":match ExtraWhitespace /^\t*\zs \+/
" Switch off :match highlighting.
":match

syntax enable
set background=dark
" solarize options
"let g:solarized_termcolors=256
"let g:solarized_termcolors=16
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
"g:solarized_termcolors= 16 | 256 g:solarized_termtrans = 0 | 1 g:solarized_degrade = 0 | 1 g:solarized_bold = 1 | 0 g:solarized_underline = 1 | 0 g:solarized_italic = 1 | 0 g:solarized_contrast = "normal"| "high" or "low" g:solarized_visibility= "normal" | "high" or "low"
"let g:solarized_degrade = 1
let g:solarized_termtrans = 1
colorscheme solarized

" gvim or macvim
"set guifont=Monaco:h14
"set guifont=Lucida_Console:h12

" always set to current open file dir
set autochdir

" YAPF
map <C-Y> :call yapf#YAPF()<cr>
imap <C-Y> <c-o>:call yapf#YAPF()<cr>

" Ctrlp
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = ',p'
let g:ctrlp_by_filename = 1
let g:ctrlp_switch_buffer = 'Et'


" http://amix.dk/vim/vimrc.html
" grep
""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" direct git-grep
map <silent> ^ :call GitGrepWord()<CR>
vnoremap <silent> ^ :call VisualSelection('gg')<CR>

" direct sys-grep
map <silent> & :call SysGrepWord()<CR>
vnoremap <silent> & :call VisualSelection('sg')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>



""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""
" all stuff should be utf-8 by default
set encoding=utf-8

func UTF8_SET(...)
    set encoding=utf-8
endfun
command -nargs=? UTF8 call UTF8_SET(<f-args>)
func ASCII_SET(...)
    set encoding=latin1
endfun
command -nargs=? ASCII call ASCII_SET(<f-args>)

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    elseif a:direction == 'gg'
        call GitGrep(l:pattern)
    elseif a:direction == 'sg'
        call SysGrep(l:pattern)
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction



"VimEnter                        After doing all the startup stuff, including
"                                loading .vimrc files, executing the "-c cmd"
"                                arguments, creating all windows and loading
"                                the buffers in them.
autocmd VimEnter * set wrap

" open new buffers from searches in a new tab
":set switchbuf+=newtab

" things to remember:
" gqq to format at single line for 80 char
" set encoding=utf-8 to remove all non utf8 chars

" turn off incrementing
map <C-a> <Nop> 

"bind the spellcheck to F6=ON F7=OFF
"use a spellfile to add new dicitonary words to
map <F6> <Esc>:setlocal spell spelllang=en_us<CR> 
map <F7> <Esc>:setlocal nospell<CR>
set spellfile=~/.vim/spellfile.add

"toggle the autoindent for pasting
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"dont yank deleted lines into a buffer
"vnoremap p "_dP
"vnoremap x "_d
"noremap x "_x
"noremap dd "_dd

set hls "highlight search

"if the teminal has colors then use syntax highlighting
if has('syntax') && (&t_Co > 2)
  syntax on
endif

set colorcolumn=80

set tabstop=4

filetype plugin indent on

"set smartindent		"recognizes C syntax for indenting 
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"ignore indenting python comments
"   ^H was entered using ctrl-v, ctrl-h
autocmd BufRead *.py inoremap # X#

set autoindent		"use indent of previous line

set smarttab
set expandtab           "use spaces rather than tabs
set autowrite		"write file when switching between files 
set backspace=indent,eol,start	" allows backspace like a normal WYSIWYG

set clipboard=unnamed	"use generic register for yanking 
set confirm		"confirm with extra dialog: writing, etc.. 
set display=lastline    "inlcude as much of lastline as possible in display instead of using "@" 
set viminfo='100,\"5000	" read/write a .viminfo file: 100 files, 5000 registers
set history=50		" keep 50 lines of command line history

set laststatus=2        " always keeps a status line, even if the number of windows is large
set statusline=%1*%n:%*\ %<%f\ %y%m%2*%r%*%=[%b,0x%B]\ \ l:%l/%L\ c:%c%V(%o)\ \ %P
set incsearch		"search pattern as its typed
set nojoinspaces	"dont insert any spaces after '.''?'or'!'

set scrolloff=5		"min number of lines to keep above and below cursor durin scroll 
set sidescroll=5	"min number of cols to keep for side scrolling 
set shiftwidth=4	"number of spaces to use with autoindent 
set shiftround		"in insert mode, round the indent to a multiple of shiftwidth 

set showmatch		"show bracket and brace matches 
set showcmd		"show the command being typed

set ruler               "show the line number and %file if even if ctags are used

"allow cygwin mlcscope
"set cscopeprg=mlcscope
set cscopeprg=cscope


" set EPIC file systax to c
au BufNewFile,BufRead *.e set filetype=c


" set ctags plugin
let g:ctags_statusline=1
let g:ctags_title=1
let generate_tags=1

:if $VIM_CRONTAB == "true"
:set nobackup
:set nowritebackup
:endif

" git flavored markdown
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END
