local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')
local packer = require'packer'
local util = require'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add/configure plugins
packer.startup(function()
    local use = use

    -- Dashboard startup
    use 'mhinz/vim-startify'

    -- color theme
    use 'Mofiqul/dracula.nvim'
    vim.cmd[[colorscheme dracula]]

    -- add missing colors to highlight groups that are missing
    use 'folke/lsp-colors.nvim'

    -- rainbow brackets
    use 'p00f/nvim-ts-rainbow'
    require'nvim-treesitter.configs'.setup {
      rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        colors = {}, -- table of hex strings
        termcolors = {}, -- table of colour name strings
      }
    }

    -- Dim inactive windows
    use 'sunjon/shade.nvim'
    require'shade'.setup({
      overlay_opacity = 50,
      opacity_step = 1,
      keys = {
        brightness_up    = '<C-Up>',
        brightness_down  = '<C-Down>',
        toggle           = '<Leader>s',
      }
    })

   -- Indent markers
   use "lukas-reineke/indent-blankline.nvim"
   vim.g.indent_blankline_char = "│"

    -- status line
    use {
      'hoob3rt/lualine.nvim',
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    require('lualine').setup {
      options = {
        theme = 'dracula-nvim'
      }
    }

    -- syntax highlighting
    use 'nvim-treesitter/nvim-treesitter'
    local configs = require'nvim-treesitter.configs'
    configs.setup {
      ensure_installed = "maintained",
      highlight = {
        enable = true,
      }
    }

    use {'sheerun/vim-polyglot'}

    -- Tagbar-like plugin
    use {'simrat39/symbols-outline.nvim'}
    vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = true,
        position = 'right',
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        keymaps = {
            close = "<Esc>",
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-space>",
            rename_symbol = "r",
            code_actions = "a",
        },
        lsp_blacklist = {},
    }


    -- code formatting
    use {'prettier/vim-prettier', run = 'yarn install' }

    -- icons
    use {'kyazdani42/nvim-web-devicons'}

    -- Buffer tabs
    use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
    vim.opt.termguicolors = true
    require("bufferline").setup{}

    -- smooth scrolling
    use 'karb94/neoscroll.nvim'
    require('neoscroll').setup()

    -- Hop, an EasyMotion-like plugin
    use {
      'phaazon/hop.nvim',
      as = 'hop',
      config = function()
        require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      end
    }
    require'hop'.setup()


    -- vim-tmux-navigator
    use { 'alexghergh/nvim-tmux-navigation', config = function()
        require'nvim-tmux-navigation'.setup {
            disable_when_zoomed = true,
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
            }
        }
    end
    }
    -- Fuzzy Finding
    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    local actions = require('telescope.actions')
    require('telescope').setup{
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = false, -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        },
      },
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case'
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close      -- Close search box with ESC
          },
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            mirror = false,
          },
          vertical = {
            mirror = false,
          },
        },
        file_sorter =  require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
        path_display = { "shorten" },
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
      }
    }

    -- fzf-native 
    require('telescope').load_extension('fzf')

    use 'jremmen/vim-ripgrep'

    -- Text Objects
    use 'wellle/targets.vim'

    -- Surround
    use {
      "blackCauldron7/surround.nvim",
      config = function()
        require "surround".setup {}
      end
    }


    -- File Explorer
    use 'kyazdani42/nvim-tree.lua'
    require 'nvim-tree'.setup {}

    -- Git
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = function()
        require('gitsigns').setup()
      end
    }

    use 'tpope/vim-fugitive'

    -- DAP Debugging
    use 'mfussenegger/nvim-dap'
    use "Pocco81/DAPInstall.nvim"
    require('dap-install').setup({
        installation_path = vim.fn.stdpath('data') .. '/dapinstall/',
    })
    require('plugins/dapinstall')
    use 'theHamsta/nvim-dap-virtual-text'
    require("nvim-dap-virtual-text").setup()
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    require("dapui").setup()

    -- Testing
    use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }

    -- Completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp' 
    use 'onsails/lspkind-nvim'
    require('plugins.cmp')

    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    -- Show function signatures
    use {
      "ray-x/lsp_signature.nvim",
    }
    require "lsp_signature".setup()

    -- Trouble / display lsp diagnostics
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {}
      end
    }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'
    use 'williamboman/nvim-lsp-installer'

    local lspconfig = require'lspconfig'
    local completion = require'completion'
    local function custom_on_attach(client)
      print('Attaching to ' .. client.name)
      completion.on_attach(client)
    end
    local default_config = {
      on_attach = custom_on_attach,
    }
    -- setup language servers here
    lspconfig.tsserver.setup(default_config)

    -- Customize LSP error display
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = false,
        signs = true,
        update_in_insert = true,
      }
    )
  end
)
