local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end

local util = require('lspconfig.util')
local cmp_lsp = require('cmp_nvim_lsp')

local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  vim.list_extend(
    capabilities.textDocument.completion.completionItem.resolveSupport.properties,
    {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  )
  return cmp_lsp.update_capabilities(capabilities)
end

util.on_setup = util.add_hook_after(util.on_setup, function(config)
  if config.on_attach then
    config.on_attach =
      util.add_hook_after(config.on_attach, require('barebones.lsp.on_attach'))
  else
    config.on_attach = require('barebones.lsp.on_attach')
  end
  config.capabilities = vim.tbl_deep_extend(
    'force',
    create_capabilities(),
    config.capabilities or {}
  )
end)

require('mason-lspconfig').setup({
  -- configure, which server should be ensured to be installed
  ensure_installed = {
    'lua_ls',
    'tsserver',
    'tailwindcss',
    'astro',
  },
})

require('mason-lspconfig').setup_handlers({
  -- configure your lsp servers here
  ['lua_ls'] = function()
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          format = {
            enable = false,
          },
          hint = {
            enable = true,
            arrayIndex = 'Auto', -- "Enable", "Auto", "Disable"
            await = true,
            paramName = 'Literal', -- "All", "Literal", "Disable"
            paramType = true,
            semicolon = 'Disable', -- "All", "SameLine", "Disable"
            setType = true,
          },
          diagnostics = {
            globals = { 'P', 'vim', 'use' },
          },
          workspace = {
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.stdpath('config') .. '/lua'] = true,
            },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
  ['tsserver'] = function()
    lspconfig.tsserver.setup({})
  end,
  ['tailwindcss'] = function()
    lspconfig.tailwindcss.setup({})
  end,
  ['astro'] = function()
    lspconfig.astro.setup({})
  end,
  ['angularls'] = function()
    lspconfig.astro.setup({})
  end,
  ['pylsp'] = function()
    lspconfig.pylsp.setup({})
  end,
  ['jdtls'] = function()
    local function progress_handler()
      ---@type table<string, boolean>
      local tokens = {}
      ---@type table<string, boolean>
      local ready_projects = {}
      ---@param result {type:"Starting"|"Started"|"ServiceReady", message:string}
      return function(_, result, ctx)
        local cwd = vim.loop.cwd()
        if ready_projects[cwd] then
          return
        end
        local token = tokens[cwd] or vim.tbl_count(tokens)
        if result.type == 'Starting' and not tokens[cwd] then
          tokens[cwd] = token
          vim.lsp.handlers['$/progress'](nil, {
            token = token,
            value = {
              kind = 'begin',
              title = 'jdtls',
              message = result.message,
              percentage = 0,
            },
          }, ctx)
        elseif result.type == 'Starting' then
          local _, percentage_index = string.find(result.message, '^%d%d?%d?')
          local percentage = 0
          local message = result.message
          if percentage_index then
            percentage =
              tonumber(string.sub(result.message, 1, percentage_index))
            message = string.sub(result.message, percentage_index + 3)
          end

          vim.lsp.handlers['$/progress'](nil, {
            token = token,
            value = {
              kind = 'report',
              message = message,
              percentage = percentage,
            },
          }, ctx)
        elseif result.type == 'Started' then
          vim.lsp.handlers['$/progress'](nil, {
            token = token,
            value = {
              kind = 'report',
              message = result.message,
              percentage = 100,
            },
          }, ctx)
        elseif result.type == 'ServiceReady' then
          ready_projects[cwd] = true
          vim.lsp.handlers['$/progress'](nil, {
            token = token,
            value = {
              kind = 'end',
              message = result.message,
            },
          }, ctx)
        end
      end
    end
    lspconfig.jdtls.setup({
      cmd = {
        'jdtls',
        '--jvm-arg=' .. string.format(
          '-javaagent:%s',
          vim.fn.expand('$HOME/.local/share/jdtls/lombok.jar')
        ),
      },
      handlers = {
        ['language/status'] = progress_handler,
      },
    })
  end,
  ['gradle_ls'] = function()
    lspconfig.gradle_ls.setup({})
  end,
  ['texlab'] = function()
    lspconfig.texlab.setup({})
  end,
})
