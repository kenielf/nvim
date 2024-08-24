# Neovim Configuration
## Installation
### System Package Dependencies
The following packages should be installed for a better experience!
 - `neovim`: The actual Editor
 - `tree-sitter` and `tree-sitter-cli`: Syntax Highlighting!
 - `ueberzug`: For image previews outside of kitty
 - `nodejs`: For `npm` packages
 - `image-magick`: For rendering images inside the terminal

### Cloning
Clone the repository to your configuration directory
```bash
git clone https://github.com/kenielf/nvim ~/.config/nvim
```

Then, open `neovim` and let all plugins, syntaxes and tools install.

> [!NOTE]
> It is possible to have multiple configurations of neovim installed!
> 1. Clone neovim to another directory inside `~/.config`:
>     ```bash
>     git clone https://github.com/kenielf/nvim ~/.config/kenivim
>     ```
> 2. Launch neovim with the `NVIM_APPNAME` environment flag set:
>    ```bash
>    NVIM_APPNAME="kenivim" nvim
>    ```

## TO-DO
 - [ ] Configure formatters
 - [ ] Configure debuggers
 - [ ] Improve latex writing experience

