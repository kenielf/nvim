-- UI modes
vim.g.tty = vim.env.TERM == "linux"
vim.g.is_neovide = vim.g.neovide ~= nil

-- Leader must be set before any mapping is created
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Format on save stays opt-in so opening someone else's project doesn't rewrite it. F3 always formats.
vim.g.format_on_save = false

-- Skip the builtin plugins this config replaces
for _, plugin in ipairs({
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
    "gzip", "tar", "tarPlugin", "zip", "zipPlugin",
    "2html_plugin", "tohtml", "tutor", "getscript", "getscriptPlugin",
    "vimball", "vimballPlugin", "rrhelper",
}) do
    vim.g["loaded_" .. plugin] = 1
end
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Mason's binaries go last so tools installed by the system package manager win
vim.env.MASON = vim.fn.stdpath("data") .. "/mason"
vim.env.PATH = vim.env.PATH .. ":" .. vim.env.MASON .. "/bin"

-- .NET tools only look for the runtime in a default location, which Gentoo's SDKs aren't in
local dotnet = vim.env.DOTNET_ROOT == nil and vim.uv.fs_realpath(vim.fn.exepath("dotnet"))
if dotnet then
    vim.env.DOTNET_ROOT = vim.fs.dirname(dotnet)
end

local o = vim.opt

-- Behavior
o.mouse = "a"
o.swapfile = false
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"
o.confirm = true
o.scrolloff = 4
o.jumpoptions = "view"
o.completeopt = { "menuone", "noselect", "popup" }

-- Reading the clipboard provider is slow, so it is set after startup
vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

-- Indentation
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.autoindent = true

-- Visuals
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.colorcolumn = "80"
o.cursorline = true
o.laststatus = 3
o.showtabline = 2
o.showmode = false
o.cmdheight = vim.g.tty and 1 or 0 -- noice draws the command line, except on a TTY
o.winborder = "rounded"
o.pumborder = "rounded"
o.pumheight = 12
o.smoothscroll = true
o.list = true
o.listchars = vim.g.tty and { tab = "> ", trail = ".", space = ".", eol = "$" }
    or { tab = "→ ", trail = "•", space = "⋅", eol = "↴" }

-- Folding: treesitter by default, upgraded to LSP folding ranges on attach
o.foldlevelstart = 99
o.foldtext = ""
o.fillchars:append({ fold = " ", eob = " " })

-- Filetypes Neovim doesn't detect on its own
vim.filetype.add({
    extension = {
        vert = "glsl", frag = "glsl", geom = "glsl", comp = "glsl",
        tesc = "glsl", tese = "glsl", rgen = "glsl", rchit = "glsl",
        rmiss = "glsl", rahit = "glsl", rint = "glsl", mesh = "glsl", task = "glsl",
        hlsl = "hlsl", hlsli = "hlsl", fx = "hlsl", fxh = "hlsl", usf = "hlsl", ush = "hlsl",
        wgsl = "wgsl", wesl = "wgsl",
        slang = "shaderslang",
        gdshader = "gdshader", gdshaderinc = "gdshader",
    },
})

-- Neovide
if vim.g.is_neovide then
    vim.o.guifont = "IosevkaTerm Nerd Font Mono:h14"
    vim.g.neovide_cursor_animation_length = 0.05
end
