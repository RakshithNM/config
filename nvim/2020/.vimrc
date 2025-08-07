set rtp+=/usr/local/opt/fzf
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'haishanh/night-owl.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Yggdroot/indentLine'                                                      " indent line
Plug 'luochen1990/rainbow'                                                      " different level highlight 
Plug 'RRethy/vim-illuminate'                                                    " automatically highlight other uses of the current word
Plug 'machakann/vim-highlightedyank'                                            " make the yanked region apparent
Plug 'gregsexton/MatchTag'                                                      " highlight matching tag
Plug 'pangloss/vim-javascript'                                                  " syntax highlighting
Plug 'junegunn/goyo.vim'
call plug#end()

" Ctrl-P to invoke fuzzy file search
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <C-f> :Rg<CR>
nnoremap <silent> <C-t> :TlistToggle<CR>

" Customize the netrw window
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_bugsettings = 'noma nomod nu nobl nowrap ro'

set number 
set relativenumber
set nocursorline
set showcmd
set ruler
set cmdheight=2
set showmode
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set nobackup
set nowb
set noswapfile
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set nofoldenable
set foldlevelstart=3
set foldmethod=indent
set foldnestmax=10
set wildmenu
set clipboard=unnamed
set autoindent
set updatetime=300
set hidden
set t_co=16
if (has("termguicolors"))
	set termguicolors
endif
colorscheme night-owl

autocmd BufWritePre * redraw!
" syntax synchronization - for somefiles that syntax highlighting doesnt work
autocmd BufEnter * :syntax sync fromstart

" treat ejs files as html
augroup filetype_html
  autocmd!
  autocmd bufread,bufnew *.ejs set filetype=html
augroup end

" F7 to run current js file in the node env
nnoremap <F7> :w !node<CR>

" \<space> to turn off search highlight
nnoremap <leader><space> :nohls<CR>
" <F4> to highlight all trailing whitespace
nnoremap <F4> /\s\+$//e<CR>
" <F5> to remove all trailing whitespace
nnoremap <F5> :%s/\s\+$//e<CR>

" Move vertically by visual line, doesnot skip line broken into two
nnoremap j gj
nnoremap k gk
inoremap jk <esc>
vnoremap jk <esc>

" Show the number of search pattern matches
set shortmess-=S

" Autocomplete CSS classes etc with dashes also changes the 'w' small word
" motion to not stop at dashes, search under cursor also works
set iskeyword+=-

" Use a macro to add double quotes around words
nmap sw bi"jkea"jk

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Setting for rainbow plugin
let g:rainbow_active=1

" Mapping for goyo - presentation plugin
nnoremap <silent> <F12> :Goyo<CR>