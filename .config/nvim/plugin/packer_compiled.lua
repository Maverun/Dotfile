-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/maverun/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/maverun/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/maverun/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/maverun/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/maverun/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FTerm.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/FTerm.nvim"
  },
  ["HighStr.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/HighStr.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["cheatsheet.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/cheatsheet.nvim"
  },
  ["clipboard-image.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/clipboard-image.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/cmp_luasnip"
  },
  ["dashboard-nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["iswap.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/iswap.nvim"
  },
  ["lightspeed.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/lightspeed.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim"
  },
  ["notational-fzf-vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/notational-fzf-vim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/quick-scope"
  },
  ["sql.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/sql.nvim"
  },
  ["startuptime.vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/startuptime.vim"
  },
  tabular = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/tabular"
  },
  tagbar = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/tagbar"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["venn.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/venn.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-markdown"
  },
  ["vim-signature"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-signature"
  },
  ["vim-stay"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-stay"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-wakatime"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  },
  ["wiki.vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/wiki.vim"
  }
}

time([[Defining packer_plugins]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
