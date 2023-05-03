-- Setup your key mappings inside this file

-- wrapper function
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Leader
map('n', '<Space>', '<NOP>', { silent = true })
vim.g.mapleader = ' '

-- save and quit
map('n', '<Leader>w', ':w<CR>', { silent = true })
map('n', '<Leader>q', ':bd<CR>', { silent = true })
map('n', '<Leader>s', '<cmd>so%<CR>', { silent = true })

-- basic window movement
map('n', '<C-h>', '<C-w>h', { silent = true })
map('n', '<C-j>', '<C-w>j', { silent = true })
map('n', '<C-k>', '<C-w>k', { silent = true })
map('n', '<C-l>', '<C-w>l', { silent = true })

-- indenting in visual mode
map('v', '<', '<gv', { silent = true })
map('v', '>', '>gv', { silent = true })

-- <ESC> alternative
map('i', 'jk', '<ESC>', { silent = true })
map('i', 'kj', '<ESC>', { silent = true })
map('i', 'KJ', '<ESC>', { silent = true })
map('i', 'JK', '<ESC>', { silent = true })

-- Tab switch buffer
map('n', '<TAB>', ':bnext<CR>', { silent = true })
map('n', '<S-TAB>', ':bprevious<CR>', { silent = true })

-- NeoTree explorer
map('n', '<Leader>e', ':Neotree toggle<CR>', { silent = true })

-- Neorg
map('n', '<Leader>no', ':Neorg index<CR>', { silent = true })
map('n', '<Leader>nq', ':Neorg return<CR>', { silent = true })

-- Telescope
map(
  'n',
  '<Leader>ps',
  ':lua require("telescope.builtin").grep_string({prompt_title = "Find string", grep_open_files = true })<CR>',
  { silent = true }
)

map(
  'n',
  '<Leader>pf',
  ':lua require("telescope.builtin").find_files()<CR>',
  { silent = true }
)

map(
  'n',
  '<Leader>pv',
  ':lua require("telescope.builtin").find_files({prompt_title = "< nvimrc >", cwd = vim.env.NVIM_DIR, hidden = false})<CR>',
  { silent = true }
)
map(
  'n',
  '<Leader>pc',
  ':lua require("telescope.builtin").find_files({prompt_title = "< config >", cwd = vim.env.CONF_DIR, hidden = true})<CR>',
  { silent = true }
)
map(
  'n',
  '<Leader>pd',
  ':lua require("telescope.builtin").find_files({prompt_title = "< devel >", cwd = vim.env.DEVEL_DIR, hidden = true})<CR>',
  { silent = true }
)
