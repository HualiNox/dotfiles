-- 注释 / 取消注释：numToStr/Comment.nvim

return {
	{
		"numToStr/Comment.nvim",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		opts = {},
	},
}
