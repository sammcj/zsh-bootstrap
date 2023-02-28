" vi: ft=vimrc

"" Vundle begin
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" Install Vundle if it's not already
let vundleInstalled=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle.."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let vundleInstalled=0
endif
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
if vundleInstalled == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :PluginInstall
endif

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Plugins begin
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'jonhiggs/tabline.vim'
Plugin 'scrooloose/syntastic'
Plugin 'dracula/vim', { 'name': 'dracula' }
Plugin 'github/copilot.vim'
Plugin 'preservim/nerdtree'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'ryanoasis/vim-devicons'
Plugin 'robertbasic/vim-hugo-helper'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
call vundle#end()
" Plugins END
filetype plugin on              " required
"" Vundle END


"" SETTINGS BEGIN

set autochdir                   " change to directory of current file.
set backspace=indent,eol,start  " allow backspace to delete before insert point.
set listchars=tab:▸\ ,eol:$     " configure the invisible characters.
set modeline                    " make sure the modeline is used if it exists.
set mouse=a
set nocursorline                " disabled because it makes keyboard repeat too slow.
set ruler
set visualbell
set scrolloff=8                 " start scrolling before reaching the bottom.
set rtp+=/opt/homebrew/bin/fzf
set encoding=UTF-8
set laststatus=2             " always show status line.
set magic                       " For regular expressions turn magic on
set showmatch                   " Show matching brackets when text indicator is over them
set ignorecase                  " Ignore case when searching
set hlsearch                    " Highlight search results
set incsearch                   " Makes search act like search in modern browsers
set autoread                    " Set to auto read when a file is changed from the outside
set wildmenu                    " Turn on wildmenu
au FocusGained,BufEnter * checktime

"set nofoldenable
"set nowrap

"" Spellchecking
set spelllang=en_uk


"" Filetypes
au BufRead,BufNewFile *.md set filetype=markdown
set ffs=unix " Use Unix as the standard file type

""  Theme begin
set background=dark
if (has("termguicolors"))
set termguicolors
endif
set t_Co=256                    " enable 256 colours.
syntax on
syntax enable
colorscheme dracula
""  Theme end

"" nerdtree begin
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', 'node_modules']
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
  \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
"" nerdtree END

" airline settings
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

"" Tabs / Spacing
" Default to soft tabs, 2 spaces
set shiftwidth=2
set showtabline=2
set tabstop=2
set expandtab
set sw=2
set sts=2
" Except for Makefiles
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
" Except for Python
autocmd FileType python set noexpandtab shiftwidth=4 softtabstop=0
" Dont add comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o


"" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_exit_checks = 0

"" GitGutter
let g:gitgutter_eager = 1
let g:gitgutter_realtime = 1
let g:gitgutter_sign_column_always = 0
let g:gitgutter_sign_added = '█'
let g:gitgutter_sign_modified = '█'
let g:gitgutter_sign_modified_removed = '▁'
let g:gitgutter_sign_removed = '▁'
let g:gitgutter_sign_removed_first_line = '▔'
autocmd BufEnter     * GitGutterAll
autocmd ShellCmdPost * GitGutterAll

"" KEY MAPPINGS

" Map leader key
let mapleader = ","

" Move between panes with ctrl+arrow
map <C-up> <C-w><up>
map <C-down> <C-w><down>
map <C-left> <C-w><left>
map <C-right> <C-w><right>

" Fix Delete (backspace) on Mac OS X
set backspace=2

" Do not attempt to fix style on paste
nnoremap <silent> p "+p

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
map <F3> :setlocal spell! spell?<CR>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"  Fast reload of vimrc
map <leader>e :e! ~/.vimrc<cr>
autocmd! bufwritepost ~/.vimrc source ~/.vimrc

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Tab Shortcuts
map <C-n> :tabnext<CR>
map <C-p> :tabprevious<CR>

" Setup the F Key maps.
set pastetoggle=<F1>
map <F2> :set hlsearch!<CR>

" Redraw Screen
map <F5> :GitGutterAll<CR>:redraw!<CR>

" Fix current word with first spelling suggestion.
map Z 1z=

" Enable incremental search
set is hls


"" FUNCTIONS
" RemoveFancyCharacters COMMAND
function! RemoveFancyCharacters()
    let typo = {}
    let typo["“"] = '"'
    let typo["”"] = '"'
    let typo["‘"] = "'"
    let typo["’"] = "'"
    let typo["–"] = '--'
    let typo["—"] = '---'
    let typo["…"] = '...'
    :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()
