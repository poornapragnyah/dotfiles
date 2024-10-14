return {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'pyright',  -- python
          'ts_ls', -- js, ts
          'lua_ls',  -- lua
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            -- local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup({})
            vim.keymap.set('n','K',vim.lsp.buf.hover,{})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition,{})
            vim.keymap.set({'n','v'}, '<leader>ca', vim.lsp.buf.code_action,{})
          end,
        }
      })

      -- Python environment
      local util = require("lspconfig/util")
      local path = util.path
      require('lspconfig').pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = function(fname)
          return util.root_pattern('.git')(fname) or util.path.dirname(fname)
        end,
        before_init = function(_, config)
          default_venv_path = path.join(vim.env.HOME,"venvs", "kafka","bin", "python")
          config.settings.python.pythonPath = default_venv_path
           -- Add extra paths for module resolution
          config.settings.python.analysis.extraPaths = {
          path.join(vim.env.HOME, "venvs", "lib", "python3.12.3", "site-packages")
          }
        end,
      }
    end
  }
