local o = vim.opt
HOME = os.getenv('HOME')

-- Appearance
o.cmdheight = 1
o.cursorline = true
-- o.foldmethod = 'marker'
o.number = true
o.relativenumber = true
o.ruler = false -- My statusline take care of that
o.showmode = false
o.signcolumn = 'yes'
o.termguicolors = true
o.wrap = false

-- Backups
o.backup = false
o.writebackup = false
o.swapfile = false

-- Undo
o.undofile = true
o.undodir = HOME .. '/.vim/undo'

-- Completion
o.completeopt = 'menuone,noselect'
o.pumblend = 0 -- Popup menu transparency
o.pumheight = 10 -- Popup menu height

-- General
o.clipboard = 'unnamedplus'
o.hidden = true
o.joinspaces = false
o.mouse = 'a'
o.scrolloff = 8
o.splitbelow = true
o.splitright = true
o.timeoutlen = 1000
o.updatetime = 100
o.virtualedit = 'block'
o.iskeyword = o.iskeyword + '-'

-- Performance
o.lazyredraw = true

-- Search
o.inccommand = 'nosplit' -- show substitutions incrementally
o.ignorecase = true
o.smartcase = true
o.wildignore = '.git,**/node_modules/**';
o.wildignorecase = true

-- Tabs
o.expandtab = true
o.shiftwidth = 4
o.softtabstop = 4
o.tabstop = 4

-- Format options
o.formatoptions = o.formatoptions + 'j' -- Auto-remove comments when combining lines ( <C-J> )
+ 'n' -- Indent past the formatlistpat, not underneath it.
+ 'q' -- Allow formatting comments w/ gq
- 'c' -- In general, I like it when comments respect textwidth
- 'r' -- But do continue when pressing enter.
- 'o' -- O and o, don't continue comments
- 't' -- Don't auto format my code. I got linters for that.
