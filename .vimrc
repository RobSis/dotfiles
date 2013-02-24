
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
set nocompatible

colorscheme marklar
if has('gui_running')
  colorscheme wombat
  set guioptions -=T
endif

" vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'othree/xml.vim'

filetype plugin indent on
au BufNewFile,BufRead *.ftl set filetype=ftl
au BufNewFile,BufRead *.xml set filetype=xml
au BufNewFile,BufRead *.py highlight OverLength ctermbg=red ctermfg=white guibg=#592929 | match OverLength /\%81v.\+/


" mappings
noremap K :tabnext<CR>
nnoremap J :tabprevious<CR>

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

nnoremap <F12> :NERDTree<CR>
