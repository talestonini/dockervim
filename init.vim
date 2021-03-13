set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=2               " number of columns occupied by a tab character
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=120                  " set an 80 column border for good coding style
set termguicolors
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting
let g:mapleader = ','

"=======================================================================================================================
" Config for vim-plug

" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')

" Make sure you use single quotes
Plug 'derekwyatt/vim-scala'

" coc.nvim plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" coc plugins seem more reliable intalling in vim with `:CocInstall coc-...`
"Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-java'
"Plug 'neoclide/coc-json'
"Plug 'fannheyward/coc-xml'

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'scrooloose/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jlanzarotta/bufexplorer'
Plug 'kien/ctrlp.vim'
Plug 'mattn/emmet-vim'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'jlanzarotta/bufexplorer'
Plug 'mileszs/ack.vim'
Plug 'numkil/ag.nvim'
Plug 'alfredodeza/jacinto.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'TheZoq2/neovim-auto-autoread'
"Plug 'Yggdroot/indentLine'
"Plug 'vim-airline/vim-airline'

" Themes
Plug 'altercation/vim-colors-solarized'
Plug 'cocopon/iceberg.vim'

" Initialize plugin system
call plug#end()



"=======================================================================================================================
" Config for coc.nvim

" If hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files
set nobackup
set nowritebackup

" You will have a bad experience with diagnostic messages with the default 4000.
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Help Vim recognize *.sbt and *.sc as Scala files
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" Better display for messages
"set cmdheight=2

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Used in the tab autocompletion for coc
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Used to expand decorations in worksheets
nmap <leader>ws <Plug>(coc-metals-expand-decoration)

" Use D for show documentation in preview window
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType scala setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of current line
xmap <leader>a  <Plug>(coc-codeaction-line)
nmap <leader>a  <Plug>(coc-codeaction-line)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Trigger for code actions
" Make sure `"codeLens.enable": true` is set in your coc config
nnoremap <leader>cla :<C-u>call CocActionAsync('codeLensAction')<CR>

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>l  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>h  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Notify coc.nvim that <enter> has been pressed.
" Currently used for the formatOnType feature.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Toggle panel with Tree Views
nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
" Toggle Tree View 'metalsPackages'
nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
" Toggle Tree View 'metalsCompile'
nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
" Toggle Tree View 'metalsBuild'
nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
" Reveal current current class (trait or object) in Tree View 'metalsPackages'
nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>



"=======================================================================================================================
" My config

" remove trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

nnoremap <silent> <space>I :SortScalaImports<CR>

" To get comments highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" To open every file in a new tab (conflicts with NERDTree)
":au BufAdd,BufNewFile * nested tab sball

"let loaded_netrwPlugin = 1

" Tab navigation
map <C-l> gt
map <C-h> gT
map <C-x> :bd<CR>

" Silver Searcher stuff
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ag_working_path_mode="r"
" bind K to grep word under cursor
nnoremap K :Ag <C-R><C-W><CR>:cw<CR>
" bind \ (backward slash) to grep shortcut
"command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap <C-f> :Ag<SPACE>

" Shortcut for putting stuff into the clipboard
map <C-c> "*y

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <leader>l :nohl<CR><C-l>

" Saves the current buffer
map <leader>s :w<CR>

" Colors
"
" https://github.com/altercation/vim-colors-solarized
"let g:solarized_termcolors=256
"syntax enable
"set background=dark
"colorscheme solarized
"call togglebg#map("<F5>")
"
" https://github.com/cocopon/iceberg.vim
colorscheme iceberg
"
" Improve Coc highlighting of the term under the cursor
"highlight CocHighlightText guibg=#ff0000 guifg=#ffffff ctermbg=White ctermfg=Red
highlight CocHighlightText guibg=#ff8a30 guifg=#000000

" Format JSON
nmap =j :%!python3 -m json.tool<CR>

set autoread

nnoremap <C-h> <C-w><
nnoremap <C-l> <C-w>>
nnoremap <C-j> <C-w>-
nnoremap <C-k> <C-w>+

" For metals info on the status line, without vim-airline plugin
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" If using airline
"let g:airline_powerline_fonts = 1



"=======================================================================================================================
" Config for Nerd Tree

let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '.DS_Store']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>



"=======================================================================================================================
" Config for CTRL-P

let g:ctrlp_working_path_mode = 0

"let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'



"=======================================================================================================================
" Config for ZenCoding

" Enable all functions in all modes
let g:user_zen_mode='a'



"=======================================================================================================================
" Config for Git gutter (Git diff)

let g:gitgutter_enabled=1
nnoremap <silent> <leader>d :GitGutterToggle<cr>



"=======================================================================================================================
" Config for bufExplorer

let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>



"=======================================================================================================================
" Config for Scalafmt

noremap <F5> :Autoformat<CR>
let g:formatdef_scalafmt = "'scalafmt --stdin'"
let g:formatters_scala = ['scalafmt']
