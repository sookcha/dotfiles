syntax enable " syntax highlighting
colorscheme monokai

set tabstop=4 " you can see 1 tab as 4 spaces
set softtabstop=4 " converts 1 tab into 4 spaces
set laststatus=2

set expandtab " tabs = spaces
set number " show line numbers
set showcmd " show command in bottom bar
set cursorline " highlight current line
set showmatch " highlight matching braces

set incsearch " search as characters are entered
set hlsearch " hightlight search matches

set foldenable " enable code folding

set noshowmode " does not shows '-- INSERT --' bottom of the screen

" Keymaps
map <C-o> :Files<CR>
map <C-f> :NERDTreeToggle<CR>


" VIM PLUG SETTINGS
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'

Plug 'Quramy/vim-js-pretty-template'
Plug 'Quramy/tsuquyomi', { 'do': 'npm -g install typescript' }
Plug 'leafgarland/typescript-vim'
Plug 'jason0x43/vim-js-indent'
call plug#end()
