local opt = vim.opt
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.number = true

opt.spell = true
opt.spelllang = { "en_us" }

opt.title = true

opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.hlsearch = false -- do not highlight all matches on previous search pattern
opt.incsearch = true -- incrementally highlight searches as you type
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 2
opt.expandtab = true
opt.scrolloff = 10
opt.backupskip = { "/tmp/*", "/private/tmp/*" }
opt.inccommand = "split"

opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search

opt.wrap = false -- No Wrap lines
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" }) -- Finding files - Search down into subfolders
opt.wildignore:append({ "*/node_modules/*" })
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "cursor"
opt.mouse = ""

opt.termguicolors = true

opt.swapfile = false -- do not use a swap file for the buffer
opt.backup = false -- do not keep a backup file
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- set directory where undo files are stored
opt.undofile = true -- save undo history to a file

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

vim.g.lazyvim_prettier_needs_config = false
