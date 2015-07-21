" flash.vim - Draw attention

" if exists("g:loaded_flash") || &cp || v:version < 700
"   finish
" endif
" let g:loaded_flash = 1


"""""""""""""
" global vars
"
let g:flash_flashMode=0
let g:flash_modifyBit=0
let g:v1=0
let g:v2=0
let g:l1=0
let g:l2=0


"""""""""""""
" functions
"

" fn: highlight selection of text
function! HighlightSelection(v1,v2,l1,l2)
    highlight FleetingFlashyFiretrucks ctermfg=red
    execute 'match FleetingFlashyFiretrucks /\%<'.a:v1.'v.\%>'.a:v2.'v.\%<'.a:l1.'l.\%>'.a:l2.'l/'

    let g:v1=a:v1
    let g:v2=a:v2
    let g:l1=a:l1
    let g:l2=a:l2
endfunction

" fn: remove all highlighting
function! RemoveHighlighting()
    match none
endfunction

" fn: flash at current location
function! Flash()
    if !exists("g:flash_interval")
        let g:flash_interval="200m"
    endif

    set cursorline cursorcolumn
    call HighlightSelection(8,7,6,4)
    redraw
    execute "sleep ".g:flash_interval
    call RemoveHighlighting()
    set nocursorline nocursorcolumn
endfunction

" fn: output settings to console
function! PrintSettings()
    let g:labelv1='v1'
    let g:labelv2='v2'
    let g:labell1='l1'
    let g:labell2='l2'
    if (g:flash_modifyBit == 1)
        let g:labelv2='*v2'
    elseif (g:flash_modifyBit == 2)
        let g:labell1='*l1'
    elseif (g:flash_modifyBit == 3)
        let g:labell2='*l2'
    else
        let g:labelv1='*v1'
    endif
    echo g:labelv1.' '.g:v1.', '.g:labelv2.' '.g:v2.', '.g:labell1.' '.g:l1.', '.g:labell2.' '.g:l2
endfunction

" fn: select a region of the screen
function! SelectionAction(incrementNumber)
    if (g:flash_modifyBit == 1)
        let g:v2 = g:v2 + a:incrementNumber
    elseif (g:flash_modifyBit == 2)
        let g:l1 = g:l1 + a:incrementNumber
    elseif (g:flash_modifyBit == 3)
        let g:l2 = g:l2 + a:incrementNumber
    else
        let g:v1 = g:v1 + a:incrementNumber
    endif

    if g:v1 < 0
        let g:v1=0
    elseif g:v2 < 0
        let g:v2=0
    elseif g:l1 < 0
        let g:l1=0
    elseif g:l2 < 0
        let g:l2=0
    endif

    call HighlightSelection(g:v1,g:v2,g:l1,g:l2)
    call PrintSettings()
endfunction

function! ResetValues()
    let g:v1=0
    let g:v2=0
    let g:l1=0
    let g:l2=0
    call PrintSettings()
endfunction

" fn: tab key handler
function! DoTab()
    if (g:flash_modifyBit == 3)
        let g:flash_modifyBit=-1
    endif
    let g:flash_modifyBit=g:flash_modifyBit+1
    call PrintSettings()
endfunction

" fn: F (upper-case) key handler. controller of sorts...
" toggle on/off a mode where you can create an ad-hoc selection of text
function! DoF()
    if (g:flash_flashMode == 1)
        let g:flash_flashMode = 0
        echo "flash mode off"
    elseif (g:flash_flashMode == 0)
        let g:flash_flashMode = 1
        echo "flash mode on"
    endif

    if (g:flash_flashMode == 1)
        " sub commands when in F mode
        map <Tab> :call DoTab()<CR>
        map <Up> :call SelectionAction(1)<CR>
        map <Down> :call SelectionAction(-1)<CR>
        map r :call ResetValues()<CR>
    else
        unmap <Tab>
        unmap <Up>
        unmap <Down>
        unmap r
    endif
endfunction


"""""""""""""
" mappings
"

" toggle of ad-hoc mode
map <leader>F :call DoF()<CR>

" flash at cursor
nnoremap <leader>f :call Flash()<CR>

" center and flash on forward search with leader
nnoremap <leader>n nzz :call Flash()<CR>

