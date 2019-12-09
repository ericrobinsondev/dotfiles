" enable syntax processing
syntax enable	

" term guicolors for dracula
set termguicolors

" ================================================
" SECTION: TABS, SPACES, and FOLDING 
" ================================================
" number of visual spaces per TAB
set tabstop=4
" Python
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Flag unnecessary whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Make python code look pretty
let python_highlight_all=1
syntax on

" Ignore .pyc files in NERDtree
let NERDTreeIgnore=['\.pyc$', '\~$']

"Frontend TABS
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" Set encoding
set encoding=utf-8

" Code Folding
set foldmethod=indent
set foldlevel=99

" ================================================
" SECTION: Remapping keys
" ================================================
" Enable folding with spacebar 
nnoremap <space> za

" Switch to NERDTree hierarchy in normal or insert mode
map <silent> <C-n> :NERDTreeFocus<CR>

" Move text with Alt+j/k
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==

inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚<Esc>:m .-2<CR>==gi

vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Split window navigation shortcuts
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" jk is escape
inoremap jk <esc>

" show line numbers, relative when has focus, absolute otherwise
" Use TAB and Shift-TAB to navigate completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" highlight current line
set cursorline

" Use system clipboard
set clipboard=unnamed

" visual autocomplete for commands
set wildmenu

" redraw screen only when needed to
set lazyredraw

" highlight matching [{()}]
set showmatch

" search as characters are entered
set incsearch

" highlight search matches
set hlsearch


" ================================================
" SECTION: PLUGINS 
" ================================================
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" PEP8 Checking
Plug 'nvie/vim-flake8'

" Fuzzy Finder
Plug 'junegunn/fzf'

" vim-polyglot plugin
Plug 'sheerun/vim-polyglot'

" dracula color theme
Plug 'dracula/vim', { 'as': 'dracula' }

" ale for linting
Plug 'dense-analysis/ale'

" code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" commentary
Plug 'tpope/vim-commentary'

" vim-surround
Plug 'tpope/vim-surround'

" vim-fugitive
Plug 'tpope/vim-fugitive'

" Better folding
Plug 'tmhedberg/SimpylFold'

" NERDtree file tree explorer
Plug 'scrooloose/nerdtree'

" Airline status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1

" Prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
" Prettier format on save
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Auto-lint on save
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['eslint']
let g:ale_fix_on_save = 1

" auto-pairs
Plug 'jiangmiao/auto-pairs'

" vim-test
Plug 'janko/vim-test'
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

" vim-indent-object (useful for python)
Plug 'michaeljsmith/vim-indent-object'

" Initialize plugin system
call plug#end()

" set color scheme
colorscheme dracula

" Close the completion window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ================================================
" SECTION: NERDtree 
" ================================================

" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('jsx', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" Open NERDtree when vim opens without a file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Make NERDTree look pretty
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Automatically delete buffer of file deleted in NERDTree
let NERDTreeAutoDeleteBuffer = 1
