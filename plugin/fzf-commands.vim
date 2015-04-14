
let s:default_tmux_height = '40%'

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

function! FZFBuffers()
    call fzf#run({
        \ 'source':  reverse(<sid>buflist()),
        \ 'sink':    'edit',
        \ 'options': '+m',
        \ 'down':    '40%',
        \ })
endfunction
command! FZFBuffers call FZFBuffers()


function! FZFMru()
    call fzf#run({
        \ 'source':   v:oldfiles,
        \ 'sink' :   'edit',
        \ 'options': '-m --no-sort',
        \ 'down':    '40%',
        \ })
endfunction
command! FZFMru call FZFMru()


function! FZFGit()
    " Remove trailing new line to make it work with tmux splits
    let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
    echo 'asdf'
    if !v:shell_error
        lcd `=directory`
        call fzf#run({
            \ 'sink': 'edit',
            \ 'dir': directory,
            \ 'source': 'git ls-files',
            \ 'down': '40%',
            \ })
    else
        FZF
    endif
endfunction
command! FZFGit call FZFGit()
