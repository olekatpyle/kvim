local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

-- Installation

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Installing packer close and reopen Nvim ..')
  vim.cmd([[packadd packer.nvim]])
end

-- Sync

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]])

--------
-- Setup

return require('packer').startup(function()
  use('wbthomason/packer.nvim')

  -- UI
  use('huyvohcmc/atlas.vim')
  use({ 'olekatpyle/tmuxline.vim', branch = 'custom-seperator' })
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  })
  use('kdheepak/tabline.nvim')
  use({
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  })
  use({
    'lukas-reineke/indent-blankline.nvim',
    opts = { char = '┊', show_trailing_blankline_indent = false },
  })

  use({
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup({
        background_colour = '#0e0e0e',
      })
    end,
  })
  use('jose-elias-alvarez/null-ls.nvim')
  use('jiangmiao/auto-pairs')
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  })
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    requires = { { 'nvim-lua/plenary.nvim' } },
  })
  use({
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  })

  -- LSP
  use({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  })
  use('hrsh7th/nvim-cmp') -- Autocompletion plugin
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/cmp-nvim-lsp') -- LSP source for nvim-cmp

  if packer_bootstrap then
    require('packer').sync()
  end
end)
