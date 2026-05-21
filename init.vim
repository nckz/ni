" Nick Zwart's neovim settings (ported from vimrc)
" neovim help: :help
"
" Things to remember:
"   * to open the last closed file in a split window do:
"       :split#
"       :sp#
"       :vsp#

":highlight ExtraWhitespace ctermbg=red guibg=red
" The following alternative may be less obtrusive.
":highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" Try the following if your GUI uses a dark background.
:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/
" search for trailing whitespace when insert mode ends
:au InsertLeave * match ExtraWhitespace /\s\+$/

syntax enable
set background=dark
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_termtrans = 1
colorscheme solarized

" always set to current open file dir
set autochdir

" the leader
let mapleader = ","

" Telescope (replaces CtrlP; ,p binding preserved)
map <leader>p :Telescope find_files<CR>

" Lint toggle (replaces ALEToggle bound to ,at)
let g:lint_enabled = 1
function! ToggleLint()
  if g:lint_enabled
    let g:lint_enabled = 0
    lua vim.diagnostic.enable(false)
    echo "Lint OFF"
  else
    let g:lint_enabled = 1
    lua vim.diagnostic.enable(true)
    lua require('lint').try_lint()
    echo "Lint ON"
  endif
endfunction
map <leader>at :call ToggleLint()<CR>

" Plugin setup: nvim-lint (replaces ALE diagnostics) and conform.nvim
" (replaces ALE fixers). Both are loaded via the native pack mechanism
" from ~/.config/nvim/pack/git-plugins/start/.
lua << EOF
local ok_t, telescope = pcall(require, 'telescope')
if ok_t then telescope.setup{} end

local ok_l, lint = pcall(require, 'lint')
if ok_l then
  lint.linters_by_ft = {
    python = { 'flake8' },
    sh = { 'shellcheck' },
  }
  -- Match the original ALE flake8 ignore list (E203,E501,W503).
  -- Prepend to the built-in args so nvim-lint's parser (which depends on the
  -- default --format string) keeps working.
  table.insert(lint.linters.flake8.args, 1, '--ignore=E203,E501,W503')
  vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
    callback = function()
      if vim.g.lint_enabled == 1 then
        require('lint').try_lint()
      end
    end,
  })
end

local ok_c, conform = pcall(require, 'conform')
if ok_c then
  conform.setup({
    formatters_by_ft = {
      python = { 'black' },
      ['*']  = { 'trim_newlines' },   -- replicate ALE remove_trailing_lines
    },
    format_on_save = { timeout_ms = 2000, lsp_format = 'never' },
  })
end
EOF

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

" things to remember:
" gqq to format at single line for 80 char
" set encoding=utf-8 to remove all non utf8 chars

" turn off incrementing
map <C-a> <Nop>

"bind the spellcheck to F6=ON F7=OFF
"use a spellfile to add new dictionary words to
map <F6> <Esc>:setlocal spell spelllang=en_us<CR>
map <F7> <Esc>:setlocal nospell<CR>
set spellfile=~/.config/nvim/spellfile.add

"toggle the autoindent for pasting
" (pastetoggle removed in neovim 0.10; F2 still toggles via the mapping below)
nnoremap <F2> :set invpaste paste?<CR>
set showmode

set hls "highlight search

"if the terminal has colors then use syntax highlighting
if has('syntax') && (&t_Co > 2)
  syntax on
endif

set colorcolumn=80

set tabstop=4

filetype plugin indent on

"set smartindent		"recognizes C syntax for indenting
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"ignore indenting python comments
autocmd BufRead *.py inoremap # X#

set autoindent		"use indent of previous line

set smarttab
set expandtab           "use spaces rather than tabs
set autowrite		"write file when switching between files
set backspace=indent,eol,start	" allows backspace like a normal WYSIWYG

set clipboard=unnamed	"use generic register for yanking
set confirm		"confirm with extra dialog: writing, etc..
set display=lastline    "include as much of lastline as possible in display instead of using "@"
set shada='100,<5000	" neovim ShaDa equivalent of viminfo: 100 files, 5000 register lines
set history=50		" keep 50 lines of command line history

set laststatus=2        " always keeps a status line, even if the number of windows is large
set statusline=%1*%n:%*\ %<%f\ %y%m%2*%r%*%=[%b,0x%B]\ \ l:%l/%L\ c:%c%V(%o)\ \ %P
set incsearch		"search pattern as its typed
set nojoinspaces	"dont insert any spaces after '.''?'or'!'

set scrolloff=5		"min number of lines to keep above and below cursor during scroll
set sidescroll=5	"min number of cols to keep for side scrolling
set shiftwidth=4	"number of spaces to use with autoindent
set shiftround		"in insert mode, round the indent to a multiple of shiftwidth

set showmatch		"show bracket and brace matches
set showcmd		"show the command being typed

set ruler               "show the line number and %file if even if ctags are used

" set ctags plugin
let g:ctags_statusline=1
let g:ctags_title=1
let generate_tags=1

" set EPIC file syntax to c
au BufNewFile,BufRead *.e set filetype=c

:if $VIM_CRONTAB == "true"
:set nobackup
:set nowritebackup
:endif

" native markdown for other extensions
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" ensure Python files are always recognized as UTF-8
au BufNewFile,BufFilePre,BufRead *.py set fileencoding=utf-8
au BufNewFile,BufFilePre,BufRead *.py setlocal fileencoding=utf-8
