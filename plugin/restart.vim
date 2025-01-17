" vim:foldmethod=marker:fen:
scriptencoding utf-8


" Load Once {{{
if exists('g:loaded_restart') && g:loaded_restart
    finish
endif
let g:loaded_restart = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Global Variables {{{
if !exists('g:restart_save_fn')
    let g:restart_save_fn = []
endif
if !exists('g:restart_vim_progname')
    let g:restart_vim_progname = 'gvim'
endif
if !exists('g:restart_sessionoptions')
    let g:restart_sessionoptions = ''
endif
if !exists('g:restart_cd')
    let g:restart_cd = ''
endif
if !exists('g:restart_check_window_maximized')
    let g:restart_check_window_maximized = 1
endif

if exists('g:restart_save_window_values')
    echohl WarningMsg
    echomsg 'restart.vim: g:restart_save_window_values is DEPRECATED.'
    echomsg 'Please use g:restart_sessionoptions for saving window size, positions.'
    echomsg '  let g:restart_sessionoptions = "winsize,winpos"'
    echohl None
else
    let g:restart_save_window_values = 0
endif
if g:restart_save_window_values
    call add(g:restart_save_fn, 's:save_window_values')
endif
" }}}

" Command to restart {{{
if !exists('g:restart_command')
    let g:restart_command = 'Restart'
endif

if g:restart_command != ''
    execute 'command! -bang -nargs=*' g:restart_command 'call restart#restart(<bang>0, <q-args>)'
endif
" }}}

" Menu {{{
if !get(g:, 'restart_no_default_menus', (&guioptions =~# 'M'))
    function! s:add_menu() abort
        if get(g:, 'restart_menu_lang', &langmenu !=# '' ? &langmenu : v:lang) =~# '^ja'
            runtime! lang/restart_menu_ja.vim
        endif
        execute 'anoremenu <silent> 10.601 File.&Restart<Tab>:Restart :' . g:restart_command . '<CR>'
        anoremenu 10.602 File.-RestartSep- <Nop>
    endfunction

    augroup restart-menu
        autocmd!
        autocmd GUIEnter * call s:add_menu()
    augroup END
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
