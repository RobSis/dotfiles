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
if has('gui_running')
  colorscheme wombat
  set guioptions -=T
endif

filetype on
au BufNewFile,BufRead *.ftl set filetype=ftl

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/


" mappings
noremap K :tabnext<CR>
nnoremap J :tabprevious<CR>

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

nnoremap <F12> :NERDTree<CR>



