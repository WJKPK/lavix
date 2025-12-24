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
                            ["<C-r><C-w>"] = false,
                            ["<C-r><C-a>"] = false,
                            ["<C-r><C-f>"] = false,
                            ["<C-r><C-l>"] = false,
                            ["<C-DOWN>"] = actions.cycle_history_next,
                            ["<C-UP>"] = actions.cycle_history_prev,
                            ["<M-w>"] = actions.insert_original_cword,
                            ["<M-a>"] = actions.insert_original_cWORD,
                            ["<M-f>"] = actions.insert_original_cfile,
                            ["<M-l>"] = actions.insert_original_cline,
                            ["<M-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
                        },
                        n = {},
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
          vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
          vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
          vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
          vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })

          local function center_buffer()
            vim.cmd('normal! zz')
          end

          vim.api.nvim_create_autocmd('User', {
            pattern = 'LeapLeave',
            callback = function()
              center_buffer()
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
