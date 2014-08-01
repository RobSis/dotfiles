
" mouse stuff
set mouse=a


" tab stuff
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab


" eye candy
syntax on
set background=dark
set number
set relativenumber
set showmatch
set autoindent smartindent
set showmode
set listchars=tab:▸\ ,trail:·
set list

" statusline
set laststatus=2
"set statusline=%<%f
"set statusline+=\ [%{getcwd()}]
"set statusline+=%=%-14.(%l,%c%V%)\ %p%%
" powerline
set noshowmode
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup


colorscheme desert
if has('gui_running')
  colorscheme wombat
  set guioptions=
endif

" pathogen
execute pathogen#infect()

command! Hi80 highlight OverLength ctermbg=red ctermfg=white guibg=#592929 | match OverLength /\%81v.\+/

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

if has('autocmd')
  "autocmd FileType c,cpp,java,python,lua,xml,ftl,quakec,vim autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

  filetype plugin indent on
  au BufNewFile,BufRead *.ftl set filetype=ftl
  au BufNewFile,BufRead *.xml set filetype=xml
  au BufNewFile,BufRead *.py Hi80
  au BufNewFile,BufRead *.qc set filetype=quakec

  autocmd BufWritePost *
	\ if filereadable('tags') |
	\	call system('ctags -a '.expand('%')) |
	\ endif
endif

" mappings
noremap K :tabnext<CR>
nnoremap J :tabprevious<CR>
nnoremap <F2> :set invpaste paste?<CR>

map <Esc>s :w<CR>
imap <Esc>s  <C-O>:w<CR>

set pastetoggle=<F2>
set clipboard=unnamed

nmap ZA :qall!<CR>
nnoremap <F12> :NERDTree<CR>

