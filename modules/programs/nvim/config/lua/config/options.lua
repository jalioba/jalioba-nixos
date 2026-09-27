-- =============================================================================
-- ПАРАМЕТРЫ РЕДАКТОРА: lua/config/options.lua
-- =============================================================================

local opt = vim.opt

-- Номера строк
opt.number = true
opt.relativenumber = true

-- Табуляция и отступы (2 пробела)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Буфер обмена (бесшовная синхронизация с системным буфером Wayland)
opt.clipboard = "unnamedplus"

-- Поведение курсора и интерфейса
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Поиск
opt.ignorecase = true
opt.smartcase = true

-- Скорость обновления для диагностики и плагинов
opt.updatetime = 200
opt.timeoutlen = 300
