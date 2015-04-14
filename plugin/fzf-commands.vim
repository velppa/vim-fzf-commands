
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

function! s:cmd_callback(lines) abort
  if empty(a:lines)
    return
  endif
  let key = remove(a:lines, 0)
  if     key == 'ctrl-t' | let cmd = 'tabedit'
  elseif key == 'ctrl-x' | let cmd = 'split'
  elseif key == 'ctrl-v' | let cmd = 'vsplit'
  else                   | let cmd = 'e'
  endif
  for item in a:lines
    execute cmd s:escape(item)
  endfor
endfunction


function! FZFBuffers()
    call fzf#run({
        \ 'source':  reverse(<sid>buflist()),
        \ 'sink':    function('<sid>bufopen'),
        \ 'options': '+m',
        \ 'down':    len(<sid>buflist()) + 2
        \ })
endfunction
command! FZFBuffers call FZFBuffers()


function! FZFMru()
    call fzf#run({
        \ 'source': v:oldfiles,
        \ 'sink' : 'edit',
        \ 'options' : '-m --no-sort',
        \ })
endfunction
command! FZFMru call FZFMru()


function! FZFGit()
    " Remove trailing new line to make it work with tmux splits
    let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
    if !v:shell_error
        lcd `=directory`
        call fzf#run({
            \ 'sink': 'e ',
            \ 'dir': directory,
            \ 'source': 'git ls-files'
            \ })
    else
        FZF
    endif
endfunction
command! FZFGit call FZFGit()

