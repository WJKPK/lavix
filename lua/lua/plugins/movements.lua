return {
    { "nvim-telescope/telescope-fzf-native.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = { {'nvim-lua/plenary.nvim', "nvim-telescope/telescope-live-grep-args.nvim" }, },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local lga_actions = require("telescope-live-grep-args.actions")
            -- Configure telescope here
            telescope.setup({
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-space>"] = actions.to_fuzzy_refine,
                                ["<C-w>"] = lga_actions.quote_prompt(),
                                ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            },
                        },
                    },
                },
                defaults = {
                    mappings = {
                        i = {
                            ["<C-DOWN>"] = actions.cycle_history_next,
                            ["<C-UP>"] = actions.cycle_history_prev,
                        },
                        n = i,
                    },
                    file_ignore_patterns = {
                        "build",
                        ".git",
                        "result",
                    },
                },
            })
        telescope.load_extension('fzf')
        telescope.load_extension('live_grep_args')
        end,
    },
    {
        "ggandor/leap.nvim",
        lazy = false,
        config = function()
          require("leap").add_default_mappings()

          vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
          vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })

          local function center_buffer()
            vim.cmd('normal! zz')
          end

          vim.api.nvim_create_autocmd('User', {
            pattern = 'LeapLeave',
            callback = function()
              center_buffer()  -- Center the buffer when leaving the Leap search
            end,
          })
        end,
    },
    {
          "mikavilpas/yazi.nvim",
          event = "VeryLazy",
          dependencies = {
            "folke/snacks.nvim"
          },
     },
}
