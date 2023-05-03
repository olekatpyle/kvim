local function exists(filename)
  local ok, err, code = os.rename(filename, filename)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

local function version()
  if exists('./.venv/bin/activate') then
    vim.notify_once('Virtual Python Environment found!', vim.log.levels.INFO)
    return [[.venv]]
  else
    return ''
  end
end

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'codedark',
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
      'neo-tree',
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = {
      {
        'mode',
        show_filename_only = true,
        hide_filename_extension = false,
        show_modified_status = true,
        mode = 0,
        filetype_names = {
          TelescopePrompt = 'Telescope',
          packer = 'Packer',
          fzf = 'FZF',
        },
      },
    },
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        sections = { 'error', 'warn', 'info', 'hint' },

        diagnostics_color = {
          -- Same values as the general color option can be used here.
          error = 'DiagnosticError', -- Changes diagnostics' error color.
          warn = 'DiagnosticWarn', -- Changes diagnostics' warn color.
          info = 'DiagnosticInfo', -- Changes diagnostics' info color.
          hint = 'DiagnosticHint', -- Changes diagnostics' hint color.
        },
        -- symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
        colored = true, -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = false,
      },
    },
    lualine_c = {
      {
        'filename',
        symbols = {
          modified = '●', -- Text to show when the buffer is modified
          alternate_file = '#', -- Text to show to identify the alternate file
          directory = '', -- Text to show when the buffer is a directory
        },
      },
    },
    lualine_x = { 'filetype' },
    lualine_y = { version },
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
