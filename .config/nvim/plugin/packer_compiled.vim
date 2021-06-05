" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
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

time("Luarocks path setup", true)
local package_path_str = "/home/maverun/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/maverun/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/maverun/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/maverun/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/maverun/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  NERDTree = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/NERDTree"
  },
  ["Nvim-R"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/Nvim-R"
  },
  ["calendar-vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/calendar-vim"
  },
  ["csv.vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/csv.vim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/emmet-vim"
  },
  fzf = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  nerdcommenter = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nerdcommenter"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
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
  ["snippets.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/snippets.nvim"
  },
  ["startuptime.vim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/startuptime.vim"
  },
  ["surround.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/surround.nvim"
  },
  tagbar = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/tagbar"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["tokyodark.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/tokyodark.nvim"
  },
  ["train.nvim"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/train.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["vim-css-color"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-css-color"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-markdown"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-signature"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-signature"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-stay"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-stay"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vim-wakatime"
  },
  vimwiki = {
    loaded = true,
    path = "/home/maverun/.local/share/nvim/site/pack/packer/start/vimwiki"
  }
}

time("Defining packer_plugins", false)
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
