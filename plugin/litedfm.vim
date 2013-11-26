let g:lite_dfm_laststatus_default = &laststatus

function! LiteDFM()
  let b:lite_dfm_on = 1
  set laststatus=0
  let currwin=winnr()
  execute 'windo set numberwidth=10'
  execute currwin . 'wincmd w'
  hi LineNr ctermfg=237 ctermbg=237 guifg=#4A4A4A guibg=#4A4A4A
endfunction


function! LiteDFMClose()
  let b:lite_dfm_on = 0
  execute 'set laststatus=' . g:lite_dfm_laststatus_default
  let currwin=winnr()
  execute 'windo set numberwidth=4'
  execute currwin . 'wincmd w'
  hi LineNr ctermfg=101 ctermbg=238 guifg=#989A6D guibg=#565656
endfunction


function! LiteDFMToggle()
  if !exists("b:lite_dfm_on")
    let b:lite_dfm_on = 0
  endif
  if b:lite_dfm_on
    call LiteDFMClose()
  else
    call LiteDFM()
  endif
endfunction

command! LiteDFM call LiteDFM()
command! LiteDFMClose call LiteDFMClose()
command! LiteDFMToggle call LiteDFMToggle()

nnoremap <Leader>g :LiteDFMToggle<CR>
