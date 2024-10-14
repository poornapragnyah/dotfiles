  return {
    'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true --bufferline
      require("bufferline").setup{} --bufferline
    end
  }
