"Sets numbers n the left side
set rnu
set nu

"Setting Tab Width
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Highlighting Search
set hlsearch


"------------------------
"
"Set up from https://www.youtube.com/watch?v=fP_ckZ30gbs
"
" Press * to search for the term under the cursor or a visual selection and 
" then press a key below to replace all instances of it in the current file
nnoremap <Leader>r :%s///g<Left><Left>
nnoremap <Leader>rc :%s///gc<Left><Left><Left>

xnoremap <Leader>r :s///g<Left><Left>
xnoremap <Leader>rc :s///gc<Left><Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> s* :left @/+'\<'.expand('<cword').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

" FUZZY FIND SETTINGS
" ----------------

" Launch fzf with CTRL+P
nnoremap <silent> <C-p> :FZF -m<CR>

" Map a few common things to do with FZF.
nnoremap <silent> <Leader><Enter> :Buffers<CR>
nnoremap <silent> <Leader>l :Lines<CR>

" Allow passing optional flags into the Rg command.
"     Example:   :Rg myterm -g '*.md'
command! -bang -nargs=* RG call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . <q-args>, 1, <bang>0)


" Vim Grepper 
" Multiple files find and replace
" --------------------------------
"
let g:grepper={}
let g:grepper.tools=["rg"]

xmap gr <plug>(GrepperOperator)

" Find and reaplce shortcut
"------------------------

nnoremap <Leader>f :!find . -name "*.html" -exec sed -i 's///g' {} \;<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

"this uses the highlighted serach result (that blank spot)
nnoremap <Leader>r :%s///g<Left><Left>

" After searching for text, press this mapping to do a project wide find and 
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <Leader>R
 \ :let @s='\<'.expand('<cword>').'<\>'<CR>
 \ :Grepper -cword -noprompt<CR>
 \ :cfdo %s/<C-r>s// \| update
 \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>


" END Nick Janetakis Instructional Video
"----------------------

" \ + g for git commit
" --------------------
"
nnoremap <Leader>ga :Git add .
nnoremap <Leader>gc :Git commit -m ''<Left>
nnoremap <Leader>gp :Git pull origin main
nnoremap <Leader>GP :Git push origin main

" this is the left file tree & layout
" -----------------------------------
" let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END


call plug#begin()

" search highlights
Plug 'haya14busa/is.vim'

" visual * search
Plug 'nelstrom/vim-visual-search'

"Integrate fzf with Vim.
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

"Vim Grep multiple file search and replace
Plug 'mhinz/vim-grepper'

" Automatically show Cim's complete menu while typing
" Plug 'vim-scripts/AutoComplPop'

call plug#end()
