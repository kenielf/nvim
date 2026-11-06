# Neovim Configuration
A full IDE setup on Neovim 0.12's native features: `vim.pack` for plugins and `vim.lsp.config` / `vim.lsp.enable` for language servers.

## Installation
Requires Neovim 0.12 or newer.

```bash
git clone https://github.com/kenielf/nvim ~/.config/nvim
```

Open `nvim`. Plugins install on first launch, then language tools (through Mason) and treesitter parsers install in the background.

Run `:checkhealth custom` to see what is working for each language and what is missing.

### System dependencies
Needed for installing tools: `git`, `curl`, `tar`, `unzip`, `gzip` and a C compiler.

Recommended: `ripgrep`, `fd` and `imagemagick` (image previews).

Each language's tools are only installed once its toolchain exists. Installing the toolchain later is enough, the tools follow on the next start.

| Language | Needs | Optional |
|---|---|---|
| C, C++, shaders, Lua, Bash, zsh, ksh | Nothing | |
| C# | .NET SDK (`dotnet`) | |
| Java | JDK 21+ (`java`), `python3` | |
| Python | `python3` | |
| Perl | `perl`, `npm` | `perltidy` (formatting), `perlcritic` (linting), `PadWalker` module (debugging) |
| Rust | `cargo` | `clippy`, `rustfmt` |
| JavaScript / web | `node`, `npm` | |
| Screenshots | `silicon`, `xclip` or `wl-copy` | |

Tools already on `PATH` are used in preference to Mason's copies.

## Language support
Everything is declared in [`lua/custom/languages.lua`](lua/custom/languages.lua). Adding a language means adding one entry there, plus a file in `after/lsp/` if its server needs custom settings.

| Language | Server | Formatter | Debugger |
|---|---|---|---|
| C, C++ | clangd | clang-format | codelldb |
| C# | roslyn | csharpier | netcoredbg |
| Java | jdtls (nvim-jdtls) | jdtls | java-debug |
| Python | basedpyright, ruff | ruff | debugpy |
| Bash, sh, zsh, ksh | bash-language-server, shellcheck | shfmt | bash-debug-adapter |
| Perl | perlnavigator | perltidy | perl-debug-adapter |
| Rust | rust-analyzer | rustfmt | codelldb |
| JS, TS, web | vtsls, eslint, html, css, json, tailwind, emmet | prettierd | js-debug-adapter |
| GLSL, WGSL, HLSL, Slang | glsl_analyzer, wgsl-analyzer, slangd | clang-format (GLSL, HLSL) | |
| Lua | lua-language-server | stylua | |
| Markdown, YAML, TOML, CMake | marksman, yamlls, taplo, neocmake | prettierd, taplo | |

Debug projects can also use `.vscode/launch.json`, nvim-dap reads it automatically.

## Keymaps
The leader is `<space>`. Press it and wait to browse everything with which-key.

| Keys | Action |
|---|---|
| `<leader>ff` `fg` `fb` `fh` `fp` `fr` | Find files, grep, buffers, help, projects, recent |
| `<leader>fd` `fk` `fn` `fw` | Find diagnostics, keymaps, notifications, word |
| `<leader>cn` `<leader>ch` | Dismiss notifications, clear search highlight |
| `<a-1>` `<a-2>` `<a-3>` | File tree, buffer list, git changes |
| `<c-left>` `<c-right>` `<c-up>` | Previous buffer, next buffer, close buffer |
| `<c-t>` | Floating terminal |
| `gd` `gD` `gi` `go` `gr` `gs` | Definition, declaration, implementation, type, references, signature |
| `K` | Hover |
| `<F2>` `<F3>` `<F4>` | Rename, format, code action |
| `<leader>l` | LSP menu: symbols, code lens, restart, status |
| `<leader>t` | Diagnostics panel |
| `<F5>` `<F9>` `<F10>` `<F11>` `<F12>` | Debug: continue, breakpoint, over, into, out |
| `<leader>D` | Debugger menu, `<leader>DD` toggles its UI |
| `<leader>G` | Git menu: status, log, commit, push, pull, merge, branches, blame |
| `<leader>sf` `<leader>st` | Flash jump, Flash treesitter |
| `<leader>sc` (visual) | Screenshot the selection to the clipboard |
| `<leader>sF` | Search system fonts for screenshots |
| `<leader>se` `<leader>sa` | Edit snippet, add snippet |
| `<leader>mm` | Split or join the code under the cursor |
| `<leader>u` | Toggles: format on save, inlay hints, code lens, diagnostics, wrap, markdown |
| `<leader>pl` `pu` `pm` `ph` | Plugin status, update plugins, Mason, toolchain health |

Completion: `<c-n>` / `<c-p>` to select, `<c-y>` to accept, `<c-space>` to open, `<c-f>` / `<c-b>` for snippet fields.

## Commands
- `:SiliconFont [name]`: search fonts, or set one directly. The choice persists across sessions.
- `:ToolsInstall`: install any missing language tools and parsers.
- `:PackClean`: delete plugins no longer in the config.
- `:lsp`: Neovim's built-in LSP management (`:lsp restart`, `:lsp stop`).

Format on save is off by default. Toggle it with `<leader>uf`, or set `vim.g.format_on_save` in `lua/custom/options.lua`.

Set `NVIM_NO_DISCORD=1` to keep a session off Discord Rich Presence.

## Layout
```
init.lua
after/lsp/          Overrides on top of nvim-lspconfig's server configs
ftplugin/java.lua   Starts jdtls
lua/custom/
  pack.lua          Lazy-loading on top of vim.pack
  languages.lua     Servers, tools, parsers and formatters per language
  tools.lua         Installs tools and parsers, skipping what can't be installed yet
  lsp.lua           Diagnostics, LspAttach keymaps and native LSP features
  debug.lua         Debug adapters
  silicon.lua       Screenshots and the font search
  health.lua        :checkhealth custom
  plugins/          Plugin specs by area
snippets/           Personal snippets, in VS Code format
```

`nvim-pack-lock.json` pins plugin versions, keep it committed.
