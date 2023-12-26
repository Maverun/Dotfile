return {
  {'lukas-reineke/indent-blankline.nvim',
  config = function ()
    require("ibl").update({
      indent = {char = '│'},
      exclude = {filetypes = {'markdown','md','help','','dashboard'}}
    })
    vim.cmd[[
    highlight IndentBlanklineContextChar guifg=#a9b1d6 gui=nocombine
    highlight IndentBlanklineContextStart guifg=#a9b1d6 gui=underLine
    ]]
  end
}
}
