-- =============================================================================
-- ИНИЦИАЛИЗАЦИЯ LAZY.NVIM: lua/config/lazy.lua
-- =============================================================================

-- Автоматическое клонирование lazy.nvim при первом запуске (если отсутствует)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Ошибка клонирования lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nНажмите любую клавишу для выхода..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader-клавиша (пробел)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Настройка LazyVim и спецификаций плагинов
require("lazy").setup({
  spec = {
    -- Подключение основного фреймворка LazyVim и стандартных плагинов
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Тема Catppuccin для идеальной гармонии с системой
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
        flavour = "mocha",
        transparent_background = true,
      },
    },

    -- Подключение пользовательских плагинов из папки lua/plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- Всегда использовать последние git-коммиты плагинов
  },
  install = {
    colorscheme = { "catppuccin", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true, -- Проверка обновлений плагинов
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
