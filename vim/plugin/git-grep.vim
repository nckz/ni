let g:gitgrepprg="git\\ grep\\ -n"
let g:wholegitrep="\ --\ `git\ rev-parse\ --show-toplevel`"

function! GitGrep(args)
    :belowright split
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:gitgrepprg
    execute "silent! grep " . a:args
    botright copen
    let &grepprg=grepprg_bak
    let b:GitGrepWindow = 1 
    exec "redraw!"
endfunction

function! GitGrepAll(args)
    :belowright split
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:gitgrepprg
    execute "silent! grep " . a:args . g:wholegitrep
    botright copen
    let &grepprg=grepprg_bak
    let b:GitGrepWindow = 1 
    exec "redraw!"
endfunction


function! GitGrepAdd(args)
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:gitgrepprg
    execute "silent! grepadd " . a:args
    botright copen
    let &grepprg=grepprg_bak
    let b:GitGrepWindow = 1
    exec "redraw!"
endfunction

function! LGitGrep(args)
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:gitgrepprg
    execute "silent! lgrep " . a:args
    botright lopen
    let &grepprg=grepprg_bak
    let b:GitGrepWindow = 1
    exec "redraw!"
endfunction

function! LGitGrepAdd(args)
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:gitgrepprg
    execute "silent! lgrepadd " . a:args
    botright lopen
    let &grepprg=grepprg_bak
    let b:GitGrepWindow = 1
    exec "redraw!"
endfunction

command! -nargs=* -complete=file GitGrep call GitGrep(<q-args>)
command! -nargs=* -complete=file GitGrepAdd call GitGrepAdd(<q-args>)
command! -nargs=* -complete=file LGitGrep call LGitGrep(<q-args>)
command! -nargs=* -complete=file LGitGrepAdd call LGitGrepAdd(<q-args>)

autocmd bufenter * if (winnr("$") == 1 && exists("b:GitGrepWindow")) | q | endif

" shortcuts
command -nargs=? G call GitGrep(<q-args>)
command -nargs=? GA call GitGrepAll(<q-args>)

" grab the current word
func GitGrepWord()
  normal! "zyiw
  call GitGrepAll(getreg('z'))
endf
"nmap \g :call GitGrepWord()<CR>

func GitGrepSearchBuffer()
  normal! "zyiw
  call GitGrepAll(getreg('@/'))
endf
nmap \g :call GitGrepSearchBuffer()<CR>

" backup in case git-grep is not available
function! SysGrep(args)
    execute "silent! grep " . a:args . " *"
    botright copen
    let b:GitGrepWindow = 1 
    exec "redraw!"
endfunction

command! -nargs=* -complete=file SysGrep call SysGrep(<q-args>)

func SysGrepSearchBuffer()
  normal! "zyiw
  call SysGrep(getreg('@/'))
endf
nmap \s :call SysGrepSearchBuffer()<CR>

func SysGrepWord()
  normal! "zyiw
  call SysGrep(getreg('z'))
endf

command -nargs=? S call SysGrep(<q-args>)
