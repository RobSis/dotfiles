"
" Better vimdiff theme
"

highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "vimdiff"

" Better gitcommit messages
highlight DiffAdd cterm=none ctermfg=none ctermbg=22
highlight DiffDelete cterm=none ctermfg=darkred ctermbg=52
highlight DiffChange cterm=bold ctermfg=none ctermbg=24
highlight DiffText cterm=none ctermfg=none ctermbg=24
