local status_ok, _ = pcall(require, "minimap")
if not status_ok then
  print("MINIMAP NOT SEEN")
  return
end

vim.g.minimap_width = 18
vim.g.minimap_auto_start = 1
vim.g.minimap_block_buftypes = {
    "Trouble",
    "help",
    "nofile",
    "packer",
    "quickfix",
    "terminal",
}
vim.g.minimap_block_filetypes = {
    "TelescopePrompt",
    "TelescopeResults",
    "checkhealth",
    "gitcommit",
    "gitrebase",
    "glowpreview",
    "help",
    "minimap",
    "packer",
    "vim",
}
vim.g.minimap_git_colors = 1
vim.g.minimap_enable_highlight_colorgroup = 0
vim.g.minimap_highlight_range = 1
vim.g.minimap_highlight_search = 1
