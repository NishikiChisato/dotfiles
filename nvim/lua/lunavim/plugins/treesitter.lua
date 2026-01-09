return {
	-- Syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local install_languages = { "cpp", "go", "lua", "vim", "bash", "cmake", "markdown", "markdown_inline" }
			require("nvim-treesitter").install(install_languages, {
				summary = true,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = install_languages,
				callback = function()
					-- syntax highlighting, provided by Neovim
					vim.treesitter.start()
					-- folds, provided by Neovim
					-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					-- vim.wo.foldmethod = 'expr'
					-- indentation, provided by nvim-treesitter
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	-- Show sematic context
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		opts = {
			max_lines = 1,
			multiline_threshold = 1,
		},
	},
}
