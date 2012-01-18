" select buffer quickly. support group
" Maintainer:	Hongbo Dong <dong4138@126.com>
" Last Change:  2012-01-18
" Version: 0.1

if exists('g:SelectBufferQuicklyLoaded') || &cp
  finish
end
let g:SelectBufferQuicklyLoaded = 1

"select buffer quickly
let g:sbqFiles = []
let g:sbqCurrentGroup = 0
let g:sbqCurrentFile = []

" switch group
function! SBQ_SelectGroup ( group )
    let g:sbqCurrentGroup = a:group
endfunction


" switch group use tab page number
function! SBQ_SelectGroupWithTab()
    let tabpagenr = tabpagenr()

    if tabpagenr > len( g:sbqFiles )
        let g:sbqFiles = add( g:sbqFiles, [] )
        let g:sbqCurrentFile = add( g:sbqCurrentFile , 0 )
    endif
    call SBQ_SelectGroup( tabpagenr - 1 )
endfunction

" push buffer to list
function! SBQ_PushBuffer()
    let nr = bufnr( "%" )
    if index( g:sbqFiles[g:sbqCurrentGroup] , nr ) == -1
        let g:sbqFiles[g:sbqCurrentGroup] = add( g:sbqFiles[g:sbqCurrentGroup] , nr )
    endif
endfunction


" pop buffer from list
function! SBQ_PopBuffer()
   let nr = bufnr("%")
   let idx = index( g:sbqFiles[g:sbqCurrentGroup] , nr )
   if idx >= 0
       unlet g:sbqFiles[g:sbqCurrentGroup][idx]
   endif
endfunction


" show buffer list
function! SBQ_ShowBufferList()
    for nr in g:sbqFiles[g:sbqCurrentGroup]
        let name = bufname( nr )
        echo nr . ':   ' name
    endfor
endfunction

" select buffer to open 
function! SBQ_SelectBuffer( type )
   let length = len( g:sbqFiles[g:sbqCurrentGroup] )
   if length <= 0
       return
   endif

   "let nr = bufnr( "%" )

   "if nr != g:sbqCurrentFile[g:sbqCurrentGroup]
   "    execute "b " . g:sbqCurrentFile[g:sbqCurrentGroup]
   "    return
   "endif

   if a:type == 1
       let g:sbqCurrentFile[g:sbqCurrentGroup] = g:sbqCurrentFile[g:sbqCurrentGroup] + 1
       if g:sbqCurrentFile[g:sbqCurrentGroup] >= length
           let g:sbqCurrentFile[g:sbqCurrentGroup] = 0
       endif
   else
       let g:sbqCurrentFile[g:sbqCurrentGroup] = g:sbqCurrentFile[g:sbqCurrentGroup] - 1
       if  g:sbqCurrentFile[g:sbqCurrentGroup] < 0
           let g:sbqCurrentFile[g:sbqCurrentGroup] = length - 1
       endif
   endif

   execute "b " . g:sbqFiles[g:sbqCurrentGroup][g:sbqCurrentFile[g:sbqCurrentGroup]]
endfunction

autocmd BufRead,BufEnter * call SBQ_SelectGroupWithTab()
