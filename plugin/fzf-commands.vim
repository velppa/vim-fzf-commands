
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

command! FZFBuffers call fzf#run({
        \ 'source':  reverse(<sid>buflist()),
        \ 'sink':    function('<sid>bufopen'),
        \ 'options': '+m',
        \ 'down':    len(<sid>buflist()) + 2
        \ })

function! FZFMru()
    call fzf#run({
        \ 'source':   v:oldfiles,
        \ 'sink' :   'edit',
        \ 'options': '-m --no-sort',
        \ 'down':    '40%'
        \ })
endfunction
command! FZFMru call FZFMru()


function! FZFGit()
    " Remove trailing new line to make it work with tmux splits
    let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
    if !v:shell_error
        lcd `=directory`
        call fzf#run({
            \ 'sink': 'edit',
            \ 'dir': directory,
            \ 'source': 'git ls-files',
            \ 'down': '40%'
            \ })
    else
        FZF
    endif
endfunction
command! FZFGit call FZFGit()
