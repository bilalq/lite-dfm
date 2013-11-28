" Remember user's default values for laststatus and ruler
let s:laststatus_default = &laststatus
let s:ruler_default = &ruler
let s:number_default = &number

function! LoadDFMColors()
  let s:context = has('gui_running') ? 'gui' : 'cterm'

  let s:NormalBG = synIDattr(hlID("Normal"), "bg", s:context)
  let s:NormalBG = s:NormalBG < 0 ? 'none' : s:NormalBG

  let s:LineNrFG = synIDattr(hlID("LineNr"), "fg", s:context)
  let s:LineNrFG = s:LineNrFG < 0 ? 'none' : s:LineNrFG

  let s:LineNrBG = synIDattr(hlID("LineNr"), "bg", s:context)
  let s:LineNrBG = s:LineNrBG < 0 ? 'none' : s:LineNrBG

  let s:NonTextFG = synIDattr(hlID("NonText"), "fg", s:context)
  let s:NonTextFG = s:NonTextFG < 0 ? 'none' : s:NonTextFG

  let s:NonTextBG = synIDattr(hlID("NonText"), "bg", s:context)
  let s:NonTextBG = s:NonTextBG < 0 ? 'none' : s:NonTextBG
endfunction

function! LiteDFM()
  let s:lite_dfm_on = 1
  set number
  set noruler
  set laststatus=0
  let currwin=winnr()
  execute 'windo set numberwidth=10'
  execute currwin . 'wincmd w'
  execute 'highlight LineNr ' . s:context . 'fg=' . s:NormalBG . ' ' . s:context . 'bg=' . s:NormalBG
  execute 'highlight NonText ' . s:context . 'fg=' . s:NormalBG . ' ' . s:context . 'bg=' . s:NormalBG
endfunction

function! LiteDFMClose()
  let s:lite_dfm_on = 0
  if (s:ruler_default)
    set ruler
  endif
  if (!s:number_default)
    set nonumber
  endif
  execute 'set laststatus=' . s:laststatus_default
  let currwin=winnr()
  execute 'windo set numberwidth=4'
  execute currwin . 'wincmd w'
  execute 'highlight LineNr ' . s:context . 'fg=' . s:LineNrFG . ' ' . s:context . 'bg=' . s:LineNrBG
  execute 'highlight NonText ' . s:context . 'fg=' . s:NonTextFG . ' ' . s:context . 'bg=' . s:NonTextBG
endfunction

function! LiteDFMToggle()
  if !exists("s:lite_dfm_on")
    let s:lite_dfm_on = 0
  endif
  if s:lite_dfm_on
    call LiteDFMClose()
  else
    call LiteDFM()
  endif
endfunction

call LoadDFMColors()

augroup dfm_events
  autocmd!
  autocmd ColorScheme call LoadDFMColors()
augroup END

" Map function calls to commands
command! LiteDFM call LiteDFM()
command! LiteDFMClose call LiteDFMClose()
command! LiteDFMToggle call LiteDFMToggle()
