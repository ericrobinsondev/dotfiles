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

    -- color theme
    use 'Mofiqul/dracula.nvim'
    vim.cmd[[colorscheme dracula]]

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

    use 'sheerun/vim-polyglot'

    -- code formatting
    use {'prettier/vim-prettier', run = 'yarn install' }

    -- Buffer tabs
    use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
    vim.opt.termguicolors = true
    require("bufferline").setup{}

    -- Fuzzy Finding
    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    require('telescope').setup{
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case'
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
        shorten_path = true,
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

    -- Close search box with ESC
    local actions = require('telescope.actions')
    require('telescope').setup{
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close
          },
        },
      }
    }

    use 'jremmen/vim-ripgrep'

    -- Text Objects
    use 'wellle/targets.vim'

    -- File Explorer
    use 'kyazdani42/nvim-tree.lua'

    -- tmux
    use 'christoomey/vim-tmux-navigator'

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

    -- Completion
    use 'hrsh7th/nvim-compe' 
    require('plugins.compe')

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
    use 'anott03/nvim-lspinstall'

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
