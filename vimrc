"Sets numbers n the left side

set rnu
set nu

"Setting Tab Width
set expandtab
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

" Map to invoke fzf tabs search with Ctrl + W
nnoremap <Leader>w :Windows<CR>

" Map to invoke fzf file search with Ctrl + P
nnoremap <silent> <C-p> :Files<CR>

" Map to call FzfFiles for searching and populating the quickfix list
nnoremap <silent> <Leader>f :call FzfFiles()<CR>

" Function to search files using fzf and populate the quickfix list
function! FzfFiles()
  " Use ripgrep to get the list of files and pipe to fzf with multi-selection
  let l:cmd = 'rg --files --hidden | fzf --multi ' .
    \ '--preview "bat --style=numbers --color=always --wrap=character {}" ' .
    \ '--preview-window=right,50%,wrap'
  let l:files = systemlist(l:cmd)

  " Check if fzf returned any files
  if len(l:files) > 0
    " Ensure paths are absolute
    let l:abs_files = map(l:files, 'fnamemodify(v:val, ":p")')

    " Debug: Echo the absolute file paths to check
    echo "Absolute file paths:"
    echo l:abs_files

    " Clear the current quickfix list
    call setqflist([], 'r')

    " Populate the quickfix list with absolute paths of selected files
    call setqflist(l:abs_files, 'r')

    " Manually open the quickfix list
    copen

    " Debug: Check if quickfix list is populated
    echo "Quickfix list populated:"
    echo getqflist()

    " Go to the first file in the quickfix list
    cfirst
  endif
endfunction


"PREVIOUS SETTINGS 
" Launch fzf with CTRL+P
"nnoremap <silent> <C-p> :FZF -m<CR>

" Map a few common things to do with FZF.
"nnoremap <silent> <Leader><Enter> :Buffers<CR>
"nnoremap <silent> <Leader>l :Lines<CR>

" Allow passing optional flags into the Rg command.
"     Example:   :Rg myterm -g '*.md'
"command! -bang -nargs=* RG call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . <q-args>, 1, <bang>0)


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

" adding git branch to status line 
" -------------------------------
"
" Function to get current git branch
function! GitBranch()
  return system("git branch --show-current 2>/dev/null | tr -d '\n'")
endfunction

" Set up the status line
set statusline=
set statusline+=%f " File name
set statusline+=%h%m%r " Indicate if file is [Help], modified, or read-only
set statusline+=%= " Left/Right split
set statusline+=%{GitBranch()}\ \  " Git branch
set statusline+=%-14.(%l,%c%V%) " Line and column number
set statusline+=%< " Truncate if necessary
set laststatus=2

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



" this is setting leader d (\d) to rm -rf the directory under the cursor in
" newtrw
"
function! NetrwDeleteDir()
    let l:dir = expand('%:p') . getline('.')
    if isdirectory(l:dir)
        call system('rm -rf ' . l:dir)
        echo "Deleted directory: " . l:dir
		execute "normal! :e\<CR>"
    else
        echo "Not a directory: " . l:dir
    endif
endfunction

augroup NetrwMappings
    autocmd!
    autocmd FileType netrw nnoremap <buffer> <Leader>d :call NetrwDeleteDir()<CR>
augroup END

" converting px to vw
function! ConvertPxToVw(pxValue)
    let viewportWidth = 1920.0  " Ensure this is a float
    let vwValue = (str2float(a:pxValue) / viewportWidth) * 100
    return printf("%.2fvw", vwValue)
endfunction

nnoremap <Leader>vw :.,$s/\(\d\+\)px/\=ConvertPxToVw(submatch(1))/gc<CR>

" this fixes copying and pasting files in netrw for linux
" but it also fixed project folder persistence for ripgrep and fzf
" let g:netrw_keepdir = 0

" Force .html files to be treated as liquid (optional if you want better highlighting)
autocmd BufRead,BufNewFile *.html set filetype=liquid.html

call plug#begin()

" search highlights
Plug 'haya14busa/is.vim'

" visual * search
" Plug 'nelstrom/vim-visual-search'

"Integrate fzf with Vim.
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

"Vim Grep multiple file search and replace
Plug 'mhinz/vim-grepper'

" Automatically show Cim's complete menu while typing
" Plug 'vim-scripts/AutoComplPop'

" Vim Diff Directories
Plug 'will133/vim-dirdiff'

" Vim Git
Plug 'tpope/vim-fugitive'

" VIM Markdown
Plug 'preservim/vim-markdown'

" YML plugin highlighting
Plug 'stephpy/vim-yaml'

" syntax for liquid
Plug 'tpope/vim-liquid'

call plug#end()


" Vim markdown highlighting
syntax on

" Recognize YAML front matter in Markdown files
autocmd BufRead,BufNewFile *.md syntax match yamlFrontMatter /^---$/ containedin=ALL
autocmd BufRead,BufNewFile *.md syntax region yamlFrontMatter start=/^---$/ end=/^---$/ keepend contains=ALL
" Link YAML syntax highlighting to the yamlFrontMatter region
syntax include @yaml syntax/yaml.vim
syntax region yamlFrontMatter start=/^---$/ end=/^---$/ contains=@yaml keepend

set foldlevelstart=99

" Define a function to open Cursor Agent in a vertical split
function! OpenCursorAgentVert()
  vert terminal cursor-agent
  vertical resize 40
endfunction

" Map it to <leader>ca (or any key combo you like)
nnoremap <leader>ca :call OpenCursorAgentVert()<CR>
