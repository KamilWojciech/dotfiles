" standard stuff
set backspace=indent,eol,start
set mouse=a
set tabstop=4
set expandtab
set autoindent
set number
syntax on
set wildmenu
set sessionoptions=buffers
set ignorecase
set smartcase
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class     
set incsearch

" auto line breaking and spellchecking for git commits
autocmd Filetype gitcommit setlocal spell textwidth=72

" leader mapped to ',' and few useful shortcuts with leader
let mapleader = ","
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>
nnoremap <Leader><Leader> <c-^>

" other stuff
let fortran_have_tabs=1

" colors and gui/platform specific settings
colorscheme hybrid 
set background=dark
set term=screen-256color

if has("gui_running")
	set guifont=DejaVu\ Sans\ Mono\ 10
	set guioptions-=L
	set guioptions-=T
endif

if has("gui_macvim")
	set guifont=Monaco:h12
endif

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" few plugins
set runtimepath^=~/dotfiles/.vim/bundle/nerdtree,~/dotfiles/.vim/bundle/ctrlp.vim,~/dotfiles/.vim/bundle/supertab

" ctrlp plugin config
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'
let g:ctrlp_regexp = 1
nnoremap <C-L> :CtrlPMRUFiles<CR>

" NERDTree plugin config
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>1 :NERDTreeFind<CR> 

" Add shortcut to run NERD Tree ( [CTRL]+[N] )
map <silent> <C-n> :NERDTreeTabsToggle<CR>
map <silent> <C-b> :NERDTreeFocusToggle<CR>
