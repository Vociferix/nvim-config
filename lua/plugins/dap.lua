-- ============================================================
-- plugins/dap.lua — Debug Adapter Protocol (DAP)
-- Supports: Rust (codelldb), C/C++ (codelldb), Python (debugpy)
-- ============================================================
return {
  -- ── Core DAP ─────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db",  function() require("dap").toggle_breakpoint() end,                                          desc = "DAP: Toggle breakpoint" },
      { "<leader>dB",  function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,       desc = "DAP: Conditional breakpoint" },
      { "<leader>dc",  function() require("dap").continue() end,                                                   desc = "DAP: Continue" },
      { "<leader>di",  function() require("dap").step_into() end,                                                  desc = "DAP: Step into" },
      { "<leader>do",  function() require("dap").step_over() end,                                                  desc = "DAP: Step over" },
      { "<leader>dO",  function() require("dap").step_out() end,                                                   desc = "DAP: Step out" },
      { "<leader>dr",  function() require("dap").repl.open() end,                                                  desc = "DAP: Open REPL" },
      { "<leader>dl",  function() require("dap").run_last() end,                                                   desc = "DAP: Run last" },
      { "<leader>dq",  function() require("dap").terminate() end,                                                  desc = "DAP: Terminate" },
    },
  },

  -- ── DAP UI ────────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end,       desc = "DAP: Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = {"n","v"}, desc = "DAP: Eval expression" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup({
        layouts = {
          { elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 40, position = "left" },
          { elements = { "repl", "console" }, size = 10, position = "bottom" },
        },
      })
      -- Auto-open/close UI with debug sessions
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
    end,
  },

  -- ── Virtual text for DAP ──────────────────────────────────
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    opts = { commented = true },
  },

  -- ── Mason DAP bridge ──────────────────────────────────────
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "codelldb", "debugpy" },
      automatic_installation = true,
      handlers = {
        -- codelldb handles both Rust (via rustaceanvim) and C/C++
        codelldb = function()
          local dap = require("dap")
          dap.adapters.codelldb = {
            type    = "server",
            port    = "${port}",
            executable = {
              command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
              args    = { "--port", "${port}" },
            },
          }
          -- C / C++ configs
          for _, lang in ipairs({ "c", "cpp" }) do
            dap.configurations[lang] = {
              {
                name    = "Launch file",
                type    = "codelldb",
                request = "launch",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd            = "${workspaceFolder}",
                stopOnEntry    = false,
                args           = {},
              },
              {
                name      = "Attach to process",
                type      = "codelldb",
                request   = "attach",
                pid       = require("dap.utils").pick_process,
                args      = {},
              },
            }
          end
        end,

        -- Python via debugpy
        debugpy = function()
          local dap = require("dap")
          dap.adapters.python = function(cb, config)
            if config.request == "attach" then
              local port = (config.connect or config).port
              local host = (config.connect or config).host or "127.0.0.1"
              cb({ type = "server", port = port, host = host, options = { source_filetype = "python" } })
            else
              cb({
                type    = "executable",
                command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
                args    = { "-m", "debugpy.adapter" },
                options = { source_filetype = "python" },
              })
            end
          end
          dap.configurations.python = {
            {
              type        = "python",
              request     = "launch",
              name        = "Launch file",
              program     = "${file}",
              pythonPath  = function()
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then return venv .. "/bin/python" end
                return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
              end,
            },
          }
        end,
      },
    },
  },

  -- ── Python-specific: neotest + pytest ────────────────────
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,              desc = "Test: Run nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run file" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug nearest" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,       desc = "Test: Summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end,  desc = "Test: Output" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
      })
    end,
  },
}
