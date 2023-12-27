vim.g.mapleader = ' '

-- Opciones visuales
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 7
vim.opt.termguicolors = true

-- Opciones sobre el texto
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = false

-- Opciones para las búsquedas.
vim.opt.ignorecase = false


--[[ -------------------------
--   SECCIÓN DE PLUGINS
--]] -------------------------

-- Carga de lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        {
                "olimorris/onedarkpro.nvim",
                priority = 1000
        },
        {
                'nvim-telescope/telescope.nvim',
                tag = '0.1.5',
                dependencies = {
                        'nvim-lua/plenary.nvim'
                }
        },
        {
                "nvim-treesitter/nvim-treesitter",
                build = ":TSUpdate",
                config = function()
                        local configs = require("nvim-treesitter.configs")

                        configs.setup({
                                ensure_installed = { "c", "cpp", "html", "java", "javascript", "lua", "vim", "vimdoc" },
                                sync_install = false,
                                highlight = { enable = true },
                                indent = { enable = true }
                        })
                end
        },
        {
                "nvim-neo-tree/neo-tree.nvim",
                branch = "v3.x",
                dependencies = {
                        "nvim-tree/nvim-web-devicons",
                        "MunifTanjim/nui.nvim",
                        "3rd/image.nvim"
                }
        },
        {
                'VonHeikemen/lsp-zero.nvim',
                branch = 'v3.x'
        },
        {
                'williamboman/mason.nvim'
        },
        {
                'williamboman/mason-lspconfig.nvim'
        },
        {
                'neovim/nvim-lspconfig'
        },
        {
                'hrsh7th/nvim-cmp'
        },
        {
                'hrsh7th/cmp-nvim-lsp'
        },
        {
                'L3MON4D3/LuaSnip'
        }
}
)

-- Configuracion de lsp-zero para LSP.
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- mason.nvim
require('mason').setup({})
require('mason-lspconfig').setup({
        handlers = {
                lsp_zero.default_setup,
        },
})

vim.cmd("colorscheme onedark")
--[[ -------------------------
--   FIN DE SECCIÓN DE PLUGINS
--]] -------------------------


--[[ -------------------------
--   SECCIÓN DE ATAJOS
--]] -------------------------

-- Atajos propios
vim.keymap.set({ 'n' }, '<Leader>w', ':w<Enter>', { desc = 'Save changes in the actual buffer.' })

-- Atajos de Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, {})

-- Atajos de Neotree
vim.keymap.set('n', '<Leader>e', ':Neotree toggle<Enter>', { desc = 'Open/Close the Neotree explorer.' })
--[[ -------------------------
--   SECCIÓN DE ATAJOS
--]] -------------------------


--[[ -------------------------
--   SECCIÓN DE AUTOCOMANDOS
--]] -------------------------
local text_settings = {
    cpp = 4,
    java = 4,
    web = 2
}

local text_settings_group = vim.api.nvim_create_augroup("text_settings_group", { clear = true })
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.java"},
    group = text_settings_group,
    callback = function()
        vim.opt.shiftwidth = text_settings.java
        vim.opt.tabstop = text_settings.java
    end
})
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.c", "*.h", "*.cpp"},
    group = text_settings_group,
    callback = function()
        vim.opt.shiftwidth = text_settings.cpp
        vim.opt.tabstop = text_settings.cpp
    end
})
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.html", "*.css", "*.js", "*.jsp"},
    group = text_settings_group,
    callback = function()
        vim.opt.shiftwidth = text_settings.web
        vim.opt.tabstop = text_settings.web
    end
})
--[[ -------------------------
--   FIN DE SECCIÓN DE AUTOCOMANDOS
--]] -------------------------
print("Charge finished.")
