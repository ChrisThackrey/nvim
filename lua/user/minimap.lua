-- local status_ok, _ = pcall(require, "minimap")
-- if not status_ok then
--   print("MINIMAP NOT SEEN")
--   return
-- end

function _G.toggle_minimap()
  local minimap_exists = vim.api.nvim_exec( "echo exists(':Minimap')", true )
  if tonumber(minimap_exists) <= 0 then
    vim.cmd 'PackerLoad minimap.vim'
    vim.cmd 'source $HOME/.config/nvim/after/config/mini-map.vim'
  end

  vim.cmd[[
    MinimapToggle
    MinimapRefresh
  ]]
end

-- map('n', '<leader>mm', ':lua _G.toggle_minimap()<CR>', { noremap = true, silent = true },
--   'Toggle minimap')

