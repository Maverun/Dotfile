return {
    {'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end,
    config = function()
        vim.cmd[[
        function! s:IsFirenvimActive(event) abort
        if !exists('*nvim_get_chan_info')
            return 0
        endif
            let l:ui = nvim_get_chan_info(a:event.chan)
            return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') &&
            \ l:ui.client.name =~? 'Firenvim'
        endfunction

        function! SetLinesForFirefox()
        " let line = &lines 
        let line = &lines
        let column = &columns
        if line < 20
            set lines=25
        endif
        if column < 50
            set columns=50
        endif
        " set lines=28 columns=110 laststatus=0
        set laststatus=0
        endfunction

            function! OnUIEnter(event) abort
              if s:IsFirenvimActive(a:event)
                  au TextChanged * ++nested call Delay_My_Write()
                  au TextChangedI * ++nested call Delay_My_Write()
                  call SetLinesForFirefox()
                  set guifont=Monospace:h12
                  nnoremap <silent> <Leader>n :call SetLinesForFirefox()<CR>
              endif
            endfunction

            autocmd UIEnter * call OnUIEnter(deepcopy(v:event))


            let g:dont_write = v:false
            function! My_Write(timer) abort
                let g:dont_write = v:false
                write
            endfunction

            function! Delay_My_Write() abort
                if g:dont_write
                    return
                end
                let g:dont_write = v:true
                call timer_start(10000, 'My_Write')
            endfunction


            let g:firenvim_config = { 
                \ 'globalSettings': {
                    \ 'alt': 'all',
                \  },
                \ 'localSettings': {
                    \ '.*': {
                        \ 'cmdline': 'neovim',
                        \ 'content': 'text',
                        \ 'priority': 0,
                        \ 'selector': 'textarea',
                        \ 'takeover': 'always',
                    \ },
                \ }
            \ }
            let fc = g:firenvim_config['localSettings']
            " let fc['https://www.facebook.com/message/t/*'] = { 'takeover': 'never', 'priority': 1 }
            " let fc['https://www.duolingo.com/*'] = { 'takeover': 'never', 'priority': 1 }
            " by default, let make everything disable and only enable when need it
            let fc['*'] = { 'takeover': 'never', 'priority': 1 }
        ]]
    end,

}
}
