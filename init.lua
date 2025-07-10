-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.breakindent = true
vim.o.undofile = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.showmode = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {

		-- Gruvbox colorscheme
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },

		-- Nerd font icons
		{ "nvim-tree/nvim-web-devicons" },

		-- Keybindings hint
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},

		-- Status line
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				theme = "gruvbox",
			},
		},

		-- File tree
		{
			"nvim-tree/nvim-tree.lua",
			lazy = false,
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("nvim-tree").setup({})
			end,
		},

		-- Formatter
		{ "stevearc/conform.nvim" },

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
		},

		-- Automatically install LSP and other
		{ "mason-org/mason.nvim" },

		-- Autocomplete and LSP
		{
			"neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
			lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
			dependencies = {
				{ "ms-jpq/coq_nvim", branch = "coq" },
				{ "ms-jpq/coq.artifacts", branch = "artifacts" },
				{ "ms-jpq/coq.thirdparty", branch = "3p" },
			},
			init = function()
				vim.g.coq_settings = {
					auto_start = "shut-up",
				}
			end,
		},
	},

	-- Colorscheme that will be used when installing plugins.
	install = { colorscheme = { "gruvbox" } },

	-- Automatically check for plugin updates
	checker = { enabled = true },
})

-- Treesitter setup for c and lua.
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

-- Mason setup
require("mason").setup()

-- LSP server enable section.
-- installed through :MasonInstall
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")

-- Formatter for c and lua
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- Text for LSP diagnostic
vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
		prefix = "■",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
})

-- Set neovim colorscheme.
vim.cmd("colorscheme gruvbox")
