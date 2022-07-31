-- vim.api.nvim_create_autocmd({ "User" }, {
--   pattern = { "AlphaReady" },
--   callback = function()
--     vim.cmd [[
--       set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
--     ]]
--   end,
-- })

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = { "AlphaReady" },
  callback = function()
    vim.cmd [[
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "Jaq",
    "qf",
    "help",
    "man",
    "lspinfo",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "Markdown",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR> 
      nnoremap <silent> <buffer> <esc> :close<CR> 
      set nobuflisted 
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "Jaq" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> <m-r> :close<CR>
      " nnoremap <silent> <buffer> <m-r> <NOP> 
      set nobuflisted 
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "" },
  callback = function()
    local buf_ft = vim.bo.filetype
    if buf_ft == "" or buf_ft == nil then
      vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR> 
      nnoremap <silent> <buffer> <c-j> j<CR> 
      nnoremap <silent> <buffer> <c-k> k<CR> 
      set nobuflisted 
    ]]
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "" },
  callback = function()
    local get_project_dir = function()
      local cwd = vim.fn.getcwd()
      local project_dir = vim.split(cwd, "/")
      local project_name = project_dir[#project_dir]
      return project_name
    end

    vim.opt.titlestring = get_project_dir()
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "term://*" },
  callback = function()
    vim.cmd "startinsert!"
    -- TODO: if java = 2
    vim.cmd "set cmdheight=1"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lir" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   callback = function()
--     vim.cmd [[
--       if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
--     ]]
--   end,
-- })

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd "quit"
  end,
})

-- require("user.winbar").get_winbar()

if vim.fn.has "nvim-0.8" == 1 then
  vim.api.nvim_create_autocmd(
    { "CursorMoved", "CursorHold", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost", "TabClosed" },
    {
      callback = function()
        local status_ok, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
        if not status_ok then
          require("user.winbar").get_winbar()
        end
      end,
    }
  )
end
-- require "user.winbar"

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd "hi link illuminatedWord LspReferenceText"
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd "checktime"
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    local luasnip = require "luasnip"
    if luasnip.expand_or_jumpable() then
      -- ask maintainer for option to make this silent
      -- luasnip.unlink_current()
      vim.cmd [[silent! lua require("luasnip").unlink_current()]]
    end
  end,
})

-- vim.api.nvim_create_autocmd({ "ModeChanged" }, {
--   callback = function()
--     local luasnip = require "luasnip"
--     if luasnip.expand_or_jumpable() then
--       -- ask maintainer for option to make this silent
--       -- luasnip.unlink_current()
--       vim.cmd [[silent! lua require("luasnip").unlink_current()]]
--     end
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.ts" },
  callback = function()
    vim.lsp.buf.format { async = true }
  end,
})

	vim.api.nvim_create_augroup("custom_filetypes", {})
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = "custom_filetypes",
		pattern = "*.astro",
		command = "setfiletype astro",
	})

	-- restore cursor position
	vim.api.nvim_create_autocmd("BufReadPost", {
		callback = function()
			local previous_pos = vim.api.nvim_buf_get_mark(0, '"')[1]
			local last_line = vim.api.nvim_buf_line_count(0)
			if previous_pos >= 1 and previous_pos <= last_line and vim.bo.filetype ~= "commit" then
				vim.cmd('normal! g`"')
			end
		end,
	})

	-- Fixes Autocomment
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		callback = function()
			vim.cmd("set formatoptions-=cro")
		end,
	})

	-- never want to be in the minimap window or buffer.
	-- https://github.com/wfxr/minimap.vim/issues/106
 	vim.api.nvim_create_autocmd("BufWinEnter", {
 	 	pattern = "*",
	 	callback = function()
			local mmwinnr = vim.fn.bufwinnr("-MINIMAP-")

			if mmwinnr == -1 then
				return
			end

			if vim.fn.winnr() == mmwinnr then
				-- Go to the other window.
				vim.api.nvim_command("wincmd t")
			end
	 	end
 	})

	vim.api.nvim_create_autocmd({ "QuitPre" }, {
	 	pattern = "*",
	 	callback = function()
		 	vim.api.nvim_command("MinimapClose")
	 	end
	})

	-- Minimap Highlights
	vim.api.nvim_create_augroup("_setMapHl", { clear = true })
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = "_setMapHl",
		pattern = "*",
		command = [[
		     highlight minimapCursor ctermbg=59 ctermfg=228 guibg=#CBE3E7 guifg=#1E1E2E |
		     highlight minimapRange ctermbg=242 ctermfg=228 guibg=#585273 guifg=C9CBFF |
		     highlight Search ctermbg=242 ctermfg=228 guibg=#3E3859 guifg=#F2B482 |
		     highlight minimapDiffAdded ctermbg=242 ctermfg=228 guibg=#F5E0DC guifg=#1E1C31 |
		     highlight minimapDiffRemoved ctermbg=242 ctermfg=228 guibg=#F48FB1 guifg=#3E3859 |
		     highlight minimapDiffLine ctermbg=242 ctermfg=228 guibg=#1E1E2E guifg=#F5E0DC |
		     highlight minimapCursorDiffAdded ctermbg=59 ctermfg=228 guibg=#CBE3E7 guifg=#1E1E2E |
		     highlight minimapCursorDiffRemoved ctermbg=59 ctermfg=228 guibg=#CBE3E7 guifg=#1E1C31 |
		     highlight minimapCursorDiffLine ctermbg=59 ctermfg=228 guibg=#CBE3E7 guifg=#1E1E2E |
		     highlight minimapRangeDiffAdded ctermbg=242 ctermfg=228 guibg=#585273 guifg=#A6E3A1 |
		     highlight minimapRangeDiffRemoved ctermbg=242 ctermfg=228 guibg=#585273 guifg=#F48FB1 |
		     highlight minimapRangeDiffLine ctermbg=242 ctermfg=228 guibg=#585273 guifg=#F5E0DC
		]],
	})
