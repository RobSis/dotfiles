" mouse stuff
set mouse=a

" tab stuff
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" eye candy
syntax on
set number
set showmatch
set autoindent smartindent
colorscheme marklar

nnoremap K :tabnext<CR>
nnoremap J :tabprevious<CR>

"paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

nnoremap <F12> :NERDTree<CR>

if has('gui_running')
  colorscheme wombat
  set guioptions -=T
endif

filetype on
au BufNewFile,BufRead *.ftl set filetype=ftl
