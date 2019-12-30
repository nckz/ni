" from: http://vim.wikia.com/wiki/Git_grep

" -use this function by typing :G <search pattern>
" -or use :G <pattern> -- '*.c' to limit the search to a file format
" -use quickfix browser to access all results :copen
func GitGrep2(...)
  silent !clear
  let save = &grepprg
  set grepprg=git\ grep\ -n\ $*
  let s = 'grep'
  for i in a:000
    let s = s . ' ' . i
  endfor
  exe s
  let &grepprg = save
  :copen
endfun
"command -nargs=? G call GitGrep(<f-args>)

function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

func NRZ()
  echo s:get_visual_selection()
endfun
vmap \n :call NRZ()<CR>


func GitGrepWord_Sel()
  normal! "zyiw
  call GitGrep('-w -e ', s:get_visual_selection())
endf


" Ctrl+X G will search the word under the cursor
func GitGrepWord2()
  normal! "zyiw
  call GitGrep('-w -e ', getreg('z'))
endf
"vmap <C-x>G :call GitGrepWord()<CR>

"nmap \g :call GitGrepWord()<CR>
"nmap \G :call GitGrepWord()<CR>
