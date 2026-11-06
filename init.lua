-- Enable the bytecode module loader
vim.loader.enable()

-- Core (no plugins involved)
require("custom.options")
require("custom.autocmds")
require("custom.keymaps")

-- Plugins (see lua/custom/pack.lua for how they are loaded)
require("custom.pack").setup({
    require("custom.plugins.ui"),
    require("custom.plugins.editor"),
    require("custom.plugins.coding"),
    require("custom.plugins.git"),
    require("custom.plugins.debug"),
    require("custom.plugins.extra"),
})

-- Features built on top of the above
require("custom.silicon").setup()
require("custom.tools").setup()
