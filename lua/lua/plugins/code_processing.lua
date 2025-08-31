return {
        {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        event = { "BufReadPre", "BufNewFile" }
    },
    {
        "nvim-treesitter/nvim-treesitter",
	    config = function()
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                },
            })
	    end
    },
}
