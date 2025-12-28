" fzf - detecta automaticamente
if isdirectory('/home/linuxbrew/.linuxbrew/opt/fzf')
  set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
elseif isdirectory('/usr/share/doc/fzf/examples')
  set rtp+=/usr/share/doc/fzf/examples
elseif isdirectory('/opt/homebrew/opt/fzf')
  set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory(expand('~/.fzf'))
  set rtp+=~/.fzf
endif

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'       " gcc para comentar
Plug 'tpope/vim-surround'         " cs'\" para trocar aspas
Plug 'junegunn/fzf.vim'           " busca fuzzy
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
call plug#end()

" Visual
set number                        " números das linhas
set relativenumber                " números relativos
set cursorline                    " destaca linha atual
set termguicolors                 " cores 24-bit
set background=dark
silent! colorscheme catppuccin_mocha

" Indentação
set expandtab                     " espaços em vez de tabs
set tabstop=2
set shiftwidth=2
set smartindent

" Busca
set ignorecase                    " ignora case na busca
set smartcase                     " case-sensitive se tiver maiúscula
set hlsearch                      " destaca resultados

" Comportamento
set hidden                        " buffers em background
set mouse=a                       " mouse habilitado
set clipboard=unnamedplus         " clipboard do sistema
set splitright splitbelow         " splits mais intuitivos
set updatetime=300                " mais responsivo

" Atalhos úteis
let mapleader = " "               " leader = espaço
nnoremap <leader>w :w<CR>         " espaço+w salva
nnoremap <leader>q :q<CR>         " espaço+q fecha
nnoremap <leader>f :Files<CR>     " espaço+f busca arquivos
nnoremap <leader>b :Buffers<CR>   " espaço+b lista buffers
nnoremap <leader>/ :Rg<CR>        " espaço+/ busca no conteúdo

" Limpa highlight da busca com ESC
nnoremap <Esc> :noh<CR><Esc>
