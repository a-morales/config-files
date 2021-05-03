vim.g.fzf_action = {
	['ctrl-s'] = 'split',
	['ctrl-v'] = 'vsplit'
}

vim.g.fzf_layout =  {
	up = "~90%",
	window = {
		width = 0.8,
		height = 0.4,
		yoffset = 0.0,
		x0ffset = 0.5,
		highlight = "Todo",
		border = "sharp"
	}
}

vim.g.fzf_colors = {
  ['fg']      = {'fg', 'Normal'},
  ['bg']      = {'bg', 'Normal'},
  ['hl']      = {'fg', 'Comment'},
  ['fg+']     = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
  ['bg+']     = {'bg', 'CursorLine', 'CursorColumn'},
  ['hl+']     = {'fg', 'Statement'},
  ['info']    = {'fg', 'PreProc'},
  ['border']  = {'fg', 'Ignore'},
  ['prompt']  = {'fg', 'Conditional'},
  ['pointer'] = {'fg', 'Exception'},
  ['marker']  = {'fg', 'Keyword'},
  ['spinner'] = {'fg', 'Label'},
  ['header']  = {'fg', 'Comment'} 
}
