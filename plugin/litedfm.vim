" Remember user's default values.
let s:laststatus_default = &laststatus
let s:ruler_default = &ruler
let s:number_default = &number
let s:foldcolumn_default = &foldcolumn
let s:numberwidth_default = &numberwidth
let s:gitgutter_default = get(g:, 'gitgutter_enabled', 0)
if has('gui_running')
  let s:fullscreen_default = has('fullscreen') && &fullscreen
  let s:guioptions_default = &guioptions
endif


" Allow user to specify left offset as an integer between 1 and 22 inclusive
function! s:LoadOffsets()
  if !exists('g:lite_dfm_left_offset') || g:lite_dfm_left_offset < 1 || g:lite_dfm_left_offset > 22
    let g:lite_dfm_left_offset = 22
  endif
  if g:lite_dfm_left_offset <= 10
    let s:numberwidth_offset = g:lite_dfm_left_offset
    let s:foldcolumn_offset = 0
  else
    let s:numberwidth_offset = 10
    let s:foldcolumn_offset = g:lite_dfm_left_offset - 10
  endif
endfunction


" See if running CLI or GUI Vim
let s:context = has('gui_running') ? 'gui' : 'cterm'


" List of filetypes where window offsets should not be done
let s:ignoredWindows = ['gundo', 'nerdtree', 'tagbar']


" Retrieves the color for a provided scope and swatch in the current context
function! s:LoadColor(scope, swatch)
  let l:scopeColor = synIDattr(hlID(a:scope), a:swatch, s:context)
  return l:scopeColor < 0 ? 'none' : l:scopeColor
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


" Execute the given command within each window that is not ignored
function! s:ForEachWindow(cmd)
  let l:initialWindow = winnr()
  let l:isNotIgnoredWindow = '(index(s:ignoredWindows, &filetype) < 0)'
  let l:isNotGundoDiff = '(bufname(winbufnr(0)) !=# "__Gundo_Preview__")'
  let l:cmd = 'if (' . l:isNotIgnoredWindow . ' && ' . l:isNotGundoDiff . ') | ' . a:cmd . ' | endif'
  execute 'windo ' . l:cmd
  execute l:initialWindow . 'wincmd w'
endfunction


" Load all necessary colors and assign them to script-wide variables
function! s:LoadDFMColors()
  let s:LineNrFG = s:LoadColor('LineNr', 'fg')
  let s:LineNrBG = s:LoadColor('LineNr', 'bg')
  let s:CursorLineNRFG = s:LoadColor('CursorLineNR', 'fg')
  let s:CursorLineNRBG = s:LoadColor('CursorLineNR', 'bg')
  let s:NonTextFG = s:LoadColor('NonText', 'fg')
  let s:NonTextBG = s:LoadColor('NonText', 'bg')
  let s:FoldColumnFG = s:LoadColor('FoldColumn', 'fg')
  let s:FoldColumnBG = s:LoadColor('FoldColumn', 'bg')

  " Allow users to manually specify the color used to hide UI elements
  let s:NormalBG = get(g:, 'lite_dfm_normal_bg_' . s:context, s:LoadColor('Normal', 'bg'))
endfunction


" Function to enter DFM
function! LiteDFM()
  if !get(s:, 'lite_dfm_on', 0)
    call s:LoadDFMColors()
  endif
  call s:LoadOffsets()
  let s:lite_dfm_on = 1

  if get(g:, 'gitgutter_enabled', 0)
    GitGutterDisable
  endif

  let &ruler = get(g:, 'lite_dfm_keep_ruler', 0)
  set number
  set laststatus=0
  call s:ForEachWindow('set numberwidth=' . s:numberwidth_offset . ' foldcolumn=' . s:foldcolumn_offset)

  execute s:Hide('LineNr')
  execute s:Hide('CursorLineNR')
  execute s:Hide('NonText')
  execute s:Hide('FoldColumn')

  if has('gui_running')
    set guioptions-=T " Hide icons
    set guioptions-=r " Hide scrollbar
    set guioptions-=L " Hide NERDTree scrollbar
    if has('fullscreen')
      set fullscreen
    endif
  endif
endfunction


" Function to close DFM
function! LiteDFMClose()
  let s:lite_dfm_on = 0

  if s:gitgutter_default
    GitGutterEnable
  endif

  let &ruler = s:ruler_default
  let &number = s:number_default
  let &laststatus = s:laststatus_default
  call s:ForEachWindow('set numberwidth=' . s:numberwidth_default . ' foldcolumn=' . s:foldcolumn_default)

  try
    execute s:Restore('LineNr')
    execute s:Restore('CursorLineNR')
    execute s:Restore('NonText')
    execute s:Restore('FoldColumn')
  catch /.*/
    " Attempting to Restore values fails when they were never changed to begin
    " with. This is VimScript, so we don't care and just swallow the
    " exception.
  endtry

  if has('gui_running')
    if has('fullscreen')
      let &fullscreen = s:fullscreen_default
    endif
    let &guioptions = s:guioptions_default
  endif
endfunction


" Function to toggle DFM
function! LiteDFMToggle()
  if get(s:, 'lite_dfm_on', 0)
    call LiteDFMClose()
  else
    call LiteDFM()
  endif
endfunction


" Map function calls to commands
command! LiteDFM call LiteDFM()
command! LiteDFMClose call LiteDFMClose()
command! LiteDFMToggle call LiteDFMToggle()
