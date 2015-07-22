" flash.vim - Draw attention

" if exists("g:loaded_flash") || &cp || v:version < 700
"   finish
" endif
" let g:loaded_flash = 1


"""""""""""""
" functions
"

" fn: highlight cursor value
function! HighlightCursor()
    highlight FleetingFlashyFiretrucks ctermfg=red
    execute 'match FleetingFlashyFiretrucks /\%#/'
endfunction

" fn: remove all highlighting
function! RemoveHighlighting()
    match none
endfunction

function! SearchAndFlash()
    " go to start of word
    normal b

    call Flash()
endfunction

" fn: flash at current location
function! Flash()
    " highlight cursor
    call HighlightCursor()

    " determine delay
    if !exists("g:flash_interval")
        let g:flash_interval="200m"
    endif

    " show cross-hairs
    set cursorline cursorcolumn
    redraw

    " sleep
    execute "sleep ".g:flash_interval

    " after the delay
    call RemoveHighlighting()
    set nocursorline nocursorcolumn
endfunction


"""""""""""""
" mappings
"

" flash at cursor
nnoremap <leader>f :call Flash()<CR>

" center and flash on forward search with leader
nnoremap <leader>n nzz :call SearchAndFlash()<CR>

