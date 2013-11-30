" Remember user's default values.
let s:laststatus_default = &laststatus
let s:ruler_default = &ruler
let s:number_default = &number
let s:foldcolumn_default = &foldcolumn
let s:numberwidth_default = &numberwidth


" Allow user to specify left offset as an integer between 1 and 22 inclusive
if (!exists('g:lite_dfm_left_offset') || g:lite_dfm_left_offset < 1 || g:lite_dfm_left_offset > 22)
  let g:lite_dfm_left_offset = 22
endif
if (g:lite_dfm_left_offset <= 10)
  let s:numberwidth_offset = g:lite_dfm_left_offset
  let s:foldcolumn_offset = 0
else
  let s:numberwidth_offset = 10
  let s:foldcolumn_offset = g:lite_dfm_left_offset - 10
endif


" See if running CLI or GUI Vim
let s:context = has('gui_running') ? 'gui' : 'cterm'


" Retrieves the color for a provided scope and swatch in the current context
function! s:LoadColor(scope, swatch)
  let scopeColor = synIDattr(hlID(a:scope), a:swatch, s:context)
  return scopeColor < 0 ? 'none' : scopeColor
endfunction


" Generates a highlight command for the provided scope, foreground, and
" background
function! s:Highlight(scope, fg, bg)
  return 'highlight ' . a:scope . ' ' . s:context . 'fg=' . a:fg . ' ' . s:context . 'bg=' . a:bg
endfunction


" Generate a highlight string that hides the given scope by setting its
" foreground and background to match the normal background
function! s:Hide(scope)
  return s:Highlight(a:scope, s:NormalBG, s:NormalBG)
endfunction


" Generate a highlight string that restores the given scope to its original
" foreground and background values
function! s:Restore(scope)
  return s:Highlight(a:scope, s:[a:scope . 'FG'], s:[a:scope . 'BG'])
endfunction


" Execute the given command within each window
function! s:ForEachWindow(cmd)
  let currwin=winnr()
  execute 'windo ' . a:cmd
  execute currwin . 'wincmd w'
endfunction


" Load all necessary colors and assign them to script-wide variables
function! LoadDFMColors()
  let s:NormalBG = s:LoadColor('Normal', 'bg')
  let s:LineNrFG = s:LoadColor('LineNr', 'fg')
  let s:LineNrBG = s:LoadColor('LineNr', 'bg')
  let s:NonTextFG = s:LoadColor('NonText', 'fg')
  let s:NonTextBG = s:LoadColor('NonText', 'bg')
  let s:FoldColumnFG = s:LoadColor('FoldColumn', 'fg')
  let s:FoldColumnBG = s:LoadColor('FoldColumn', 'bg')
  if (exists('g:lite_dfm_normal_bg_' . s:context))
    " Allow users to manually specify the color used to hide UI elements
    let s:NormalBG = g:['lite_dfm_normal_bg_' . s:context]
  endif
endfunction


" Function to enter DFM
function! LiteDFM()
  let s:lite_dfm_on = 1
  set noruler
  set number
  set laststatus=0
  call s:ForEachWindow('set numberwidth=' . s:numberwidth_offset . ' foldcolumn=' . s:foldcolumn_offset)
  execute s:Hide('LineNr')
  execute s:Hide('NonText')
  execute s:Hide('FoldColumn')
endfunction


" Function to close DFM
function! LiteDFMClose()
  let s:lite_dfm_on = 0
  let &ruler = s:ruler_default
  let &number = s:number_default
  let &laststatus = s:laststatus_default
  call s:ForEachWindow('set numberwidth=' . s:numberwidth_default . ' foldcolumn=' . s:foldcolumn_default)
  execute s:Restore('LineNr')
  execute s:Restore('NonText')
  execute s:Restore('FoldColumn')
endfunction


" Function to toggle DFM
function! LiteDFMToggle()
  if !exists('s:lite_dfm_on')
    let s:lite_dfm_on = 0
  endif
  if s:lite_dfm_on
    call LiteDFMClose()
  else
    call LiteDFM()
  endif
endfunction


" Load colors and do so again whenever the colorscheme changes
call LoadDFMColors()
augroup dfm_events
  autocmd!
  autocmd ColorScheme call LoadDFMColors()
augroup END


" Map function calls to commands
command! LiteDFM call LiteDFM()
command! LiteDFMClose call LiteDFMClose()
command! LiteDFMToggle call LiteDFMToggle()
