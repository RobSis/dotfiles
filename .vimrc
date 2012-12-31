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

"paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

filetype on
au BufNewFile,BufRead *.ftl set filetype=ftl
