syntax enable

" term guicolors for dracula
set termguicolors

" Case sensitivity
set ignorecase
set smartcase

" change : for spacebar
" nnoremap <SPACE> <Nop>
let mapleader = ","

" quickly clear highlights
map <leader>h :noh<CR>

" reload files when they change on disk (e.g., git checkout)
set autoread
" reload files when changing buffers within vim
au FocusGained,BufEnter * :checktime

" shortcut to close current buffer but leave split open
nmap <leader>d :bd<cr>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" ================================================
" SECTION: TABS, SPACES, and FOLDING
" ================================================
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Python
au BufNewFile,BufRead *.py
    \| set tabstop=4
    \| set softtabstop=4
    \| set shiftwidth=4
    \| set textwidth=79
    \| set autoindent
    \| set fileformat=unix

" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
" set confirm

" Don't require saving a file before switching buffers
set hidden

" Flag unnecessary whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Make python code look pretty
" let python_highlight_all=1

" Ignore .pyc files in NERDtree
let NERDTreeIgnore=['\.pyc$', '\~$']

" Set encoding
set encoding=utf-8

" Code Folding
" set foldmethod=indent

" UNDO persistance
set undofile
set undodir=~/.vim/undo

" ================================================
" SECTION: Remapping keys
" ================================================
" Enable folding with spacebar
" nnoremap <expr> <space> foldclosed('.') != -1 ? 'zO' : 'zc'

" Do not use arrows in Normal mode
noremap <silent> <Up>    <Nop>
noremap <silent> <Down>  <Nop>
noremap <silent> <Left>  <Nop>
noremap <silent> <Right> <Nop>

" fzf files shortcut
" nnoremap <silent> <C-p> :Files<CR> // this is default and doesn't respect
" .gitignore
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

" Switch to NERDTree hierarchy in normal or insert mode
map <silent> <C-n> :NERDTreeToggle<CR>

" Use TAB and Shift-TAB to cycle through open buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

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

" Open new splits to the right or below
set splitright
set splitbelow
" no more pesky escape (for insert and visual mode)
imap jk  <Esc>
imap jK <Esc>
imap Jk <Esc>
imap JK <Esc>

" in terminal mode as well
tnoremap jk <C-\><C-n>

" Use TAB and Shift-TAB to navigate completion list
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" show line numbers, relative when has focus, absolute otherwise
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

" case-sensitive search if any caps
set smartcase

" Rg from the project root of the current buffer
command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

" Project-wide search with rip-grep CTRL-/
nnoremap <C-_> :PRg<CR>

" rip-grep word under cursor
function FzfTagsCurrentWord()
    let l:cmd_format = "rg %s --column --line-number --no-heading --color=always --smart-case"
    let l:interpolated_cmd = printf(l:cmd_format, expand('<cword>'))
    call fzf#vim#grep(l:interpolated_cmd, 1, fzf#vim#with_preview())
endfunction
nnoremap <c-[> :call FzfTagsCurrentWord()<CR>

function FzfTagsCurrentClass()
    let l:cmd_format = "rg 'class %s' --column --line-number --no-heading --color=always --smart-case"
    let l:interpolated_cmd = printf(l:cmd_format, expand('<cword>'))
    call fzf#vim#grep(l:interpolated_cmd, 1, fzf#vim#with_preview())
endfunction
nnoremap <leader>c :call FzfTagsCurrentClass()<CR>

" ================================================
" SECTION: PLUGINS
" ================================================
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Vim unimpaired
Plug 'tpope/vim-unimpaired'

" Markdown related plugins
Plug 'gabrielelana/vim-markdown'

" vimspector - debugger
Plug 'puremourning/vimspector'
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-node-debug2', 'debugger-for-chrome' ]

" Restore focus events when using in tmux (so autoread still works)
Plug 'tmux-plugins/vim-tmux-focus-events'

" Indent Guides
Plug 'nathanaelkane/vim-indent-guides'

" Base16 for Colors
Plug 'chriskempson/base16-vim'

" Open vim to specific line number (i.e. from stacktrace)
Plug 'wsdjeg/vim-fetch'

" Snippets for vim
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mlaursen/vim-react-snippets'

" Make <tab> trigger completion, completion confirm, and jump like VSCode
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Fade Inactive buffers
Plug 'TaDaa/vimade'
let g:vimade = {'enablefocusfading': 1, "fadelevel": 0.9}
au! FocusLost * VimadeFadeActive
au! FocusGained * VimadeUnfadeActive

"Rainbow brackets
Plug 'junegunn/rainbow_parentheses.vim'
augroup rainbow_lisp
    autocmd!
    autocmd Filetype python,javascript,lisp,clojure,scheme RainbowParentheses
augroup END

" BadWhitespace
Plug 'bitc/vim-bad-whitespace'

" easy-motion
Plug 'easymotion/vim-easymotion'
nmap f <Plug>(easymotion-f)
nmap F <Plug>(easymotion-F)

" Smooth scrolling of window
Plug 'psliwka/vim-smoothie'

" Visualize undo tree
Plug 'simnalamburt/vim-mundo'

" multiple cursors
" Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" vim-repeat
Plug 'tpope/vim-repeat'

" Emmet
Plug 'mattn/emmet-vim'
" Use tab for trigger completion with characters ahead and navigate.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" PEP8 Checking
Plug 'nvie/vim-flake8'

" Fuzzy Finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-bash' }
Plug 'junegunn/fzf.vim'

" Open in existing buffer if possible
let g:fzf_buffers_jump = 1
" Always preview fzf to the right
let g:fzf_preview_window = 'right:60%'


" Fancy start screen for vim
Plug 'mhinz/vim-startify'

" PEP8 Checking
Plug 'nvie/vim-flake8'

" Vimux - interact with tmux from vim
Plug 'benmills/vimux'

" Navigate tmux/vim windows easily
Plug 'christoomey/vim-tmux-navigator'

" Syntax highlighting when editing .tmux files
Plug 'tmux-plugins/vim-tmux'

" vim chords
Plug 'kana/vim-arpeggio'

" Auto close tags
Plug 'alvan/vim-closetag'
" Update closetag to also work on js and html files, don't want ts since <> is used for type args
let g:closetag_filenames='*.html,*.js,*.jsx,*.tsx'
let g:closetag_regions = {
    \ 'typescript': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Italics for dank mono
Plug 'codehearts/mascara-vim'

" settings for italics with dank mono
set t_ZH=[3m
set t_ZR=[23m
highlight Comment gui=italic
highlight Italic gui=italic

"vim js and jsx plugins
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
hi xmlAttrib cterm=italic ctermfg=214
let g:polyglot_disabled = ['jsx']

" vim-polyglot plugin
Plug 'sheerun/vim-polyglot'

" dracula color theme
" Plug 'dracula/vim', { 'as': 'dracula' }

" Fuzzy most recently used files
Plug 'pbogut/fzf-mru.vim'

" Help ALE and coc.vim work together
let g:ale_disable_lsp = 1

" code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
\'coc-css',
\'coc-fzf-preview',
\'coc-highlight',
\'coc-html',
\'coc-python',
\'coc-tsserver',
\]

Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}

" Gutentags for cTag generation
Plug 'ludovicchabant/vim-gutentags'
" change directory where tags are stored
let g:gutentags_cache_dir="~/.tags"
" don't tag files in .gitignore
let g:gutentags_file_list_command = 'rg --files'

" https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

let g:gutentags_ctags_exclude = [ '*.git', '*.svg', '*.hg', '*/tests/*', 'build', 'dist', '*sites/*/files/*', 'bin', 'node_modules', 'bower_components', 'cache', 'compiled', 'docs', 'example', 'bundle', 'vendor', '*.md', '*-lock.json', '*.lock', '*bundle*.js', '*build*.js', '.*rc*', '*.json', '*.min.*', '*.map', '*.bak', '*.zip', '*.pyc', '*.class', '*.sln', '*.Master', '*.csproj', '*.tmp', '*.csproj.user', '*.cache', '*.pdb', 'tags*', 'cscope.*', '*.css', '*.less', '*.scss', '*.exe', '*.dll', '*.mp3', '*.ogg', '*.flac', '*.swp', '*.swo', '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2', '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', ]

" View tags of the currently viewed file
Plug 'majutsushi/tagbar'
" Open tagbar
nmap <leader>t :TagbarToggle<CR>
let g:tagbar_foldlevel = 0
" commentary
Plug 'tpope/vim-commentary'

" vim-surround
Plug 'tpope/vim-surround'

" vim-fugitive
Plug 'tpope/vim-fugitive'

" vim-fugitive extension for working with branches
Plug 'idanarye/vim-merginal'

" View git commit history easily
Plug 'junegunn/gv.vim'

" Add :Gca command to include coauthor in fugitive commit messages.
command! -nargs=+ Gca :r!git log -n100 --pretty=format:"\%an <\%ae>" | grep -i '<args>' | head -1 | xargs echo "Co-authored-by:"

" Show which line changed since last commit
Plug 'airblade/vim-gitgutter'

" Better folding
" Plug 'tmhedberg/SimpylFold'

" Fast Fold
Plug 'konfekt/FastFold'

" NERDtree file tree explorer
Plug 'scrooloose/nerdtree'

" Kill buffer without closing split
Plug 'qpkorr/vim-bufkill'

" Airline status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Vim airline uses the dracula theme for it's airline_theme colors
Plug 'dracula/vim', { 'as': 'dracula' }
let g:airline_theme='dracula'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1
" Show buffers in tabs at top
let g:airline#extensions#tabline#enabled = 1
" Show buffer numbers in tabs at top
let g:airline#extensions#tabline#buffer_nr_show = 1

" Prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
" Prettier format on save
" let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
autocmd BufWritePre *.py EraseBadWhitespace

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

" Asynchronous Linting
Plug 'dense-analysis/ale'
" Auto-lint on save
let g:ale_fixers = {
\    '*': ['remove_trailing_lines', 'trim_whitespace'],
\    'javascript': ['eslint', 'prettier'],
\}
let g:ale_fix_on_save = 1
let g:ale_linters = {
\    'python': ['flake8'],
\    'javascript': ['eslint', 'prettier'],
\}
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" auto-pairs
Plug 'jiangmiao/auto-pairs'

" vim-test
Plug 'janko/vim-test'
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> <leader>n :TestNearest<CR>
nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>s :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
" make test commands execute using vimux
let test#strategy = "vimux"
" Run python tests using our test runner
let g:test#python#pytest#executable = 'python3 proj/manage.py test -- --reuse-db'

function! TacoTest(cmd) abort
    let s:cmd_array = split(a:cmd, "")
    return 'python3 proj/manage.py test -- --reuse-db ' . s:cmd_array[-1]
endfunction

let g:test#custom_transformations = {'taco_test': function('TacoTest')}
let g:test#transformation = 'taco_test'

" vim-indent-object (useful for python)
Plug 'michaeljsmith/vim-indent-object'

" Provides text objects and motions for python
Plug 'jeetsukumaran/vim-pythonsense'

" Dev Icons
Plug 'ryanoasis/vim-devicons'

" Extended text objects to operate on
Plug 'wellle/targets.vim'

" Visual undo tree
Plug 'sjl/gundo.vim'

" setup gundo plugin to display the undo tree with <leader>u
let g:gundo_prefer_python3 = 1
nnoremap <leader>u :GundoToggle<CR>

" Initialize plugin system
call plug#end()

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" set color scheme
colorscheme base16-dracula
" colorscheme dracula

" Close the completion window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ================================================
" SECTION: VIMUX commands
" ================================================
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>

" Open vimux pane
map <Leader>vo :VimuxOpenPane<CR>

" Interrupt any command running in the runner pane
map <Leader>vx :VimuxInterruptRunner<CR>
"
" Function to make tmux zoom its runner pane.
function! VimuxZoomRunner()
  call VimuxInspectRunner()
  call system("tmux resize-pane -Z")
endfunction

" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :call VimuxZoomRunner()<CR>

" Force vimux to open a new pane
let g:VimuxUseNearest= 0

" Expand emmet or coc.vim autocomplete with <tab>
let g:user_emmet_leader_key = '<C-e>'
let g:user_emmet_expandabbr_key = '<C-x><C-e>'
imap <silent><expr> <Tab> <SID>expand()

function! s:expand()
  if pumvisible()
    return "\<C-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1]  =~# '\s'
    return "\<Tab>"
  endif
  return "\<C-x>\<C-e>"
endfunction

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
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Make NERDTree look pretty
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Automatically delete buffer of file deleted in NERDTree
let NERDTreeAutoDeleteBuffer = 1

" Find files with preview window
" https://github.com/junegunn/fzf.vim/issues/732
let $BAT_THEME = 'Dracula'
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg --column --no-heading --line-number --color=always '.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \ fzf#vim#with_preview('right'),
  \ <bang>0)

" ================================================
" SECTION: CHORDS
" ================================================
call arpeggio#map('n', '', 0, 'vl', ':VimuxRunLastCommand<CR>')
call arpeggio#map('n', '', 0, 'vp', ':VimuxPromptCommand<CR>')
call arpeggio#map('n', '', 0, 'v;', ':VimuxCloseRunner<CR>')
call arpeggio#map('n', '', 0, 'pr', 'VimuxRunCommand("clear; pr<CR>')

" ================================================
" SECTION: REMAPS (after plugins)
" ================================================
" shortcut to save
nnoremap ,, :w<cr>
" remove easymotion's <leader><leader> mapping
map <Leader>)) <Plug>(easymotion-prefix)
