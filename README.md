## Description

Minimalist and organised neovim config taking inspiration from many areas.

Designed for use with a moonlander keyboard [current layout](https://configure.zsa.io/moonlander/layouts/d7lan/latest/0) but should be usable on any regular keyboard.

## Aims

-   Simplicity
    -   _Use as few things as reasonably practicable but provide an IDE-like experience_
-   Go with the grain
    -   _Use the built in vim commands as much as possible and only remap where necessary_

## System Requirements

-   [Nerdfont (for displaying symbols)](https://webinstall.dev/nerdfont/)
-   [Ripgrep (for the fuzzy finder)](https://github.com/BurntSushi/ripgrep)
-   For formatting and linting
    -   [StyLua](https://github.com/JohnnyMorganz/StyLua)
    -   [prettierd](https://github.com/fsouza/prettierd)
    -   [shfmt](https://formulae.brew.sh/formula/shfmt)
-   Language servers as required for lsp use

## Use it

-   Remove your current config: `rm -rf $HOME/.config/nvim`
-   Make a directory to house your config: `mkdir $HOME/.config/nvim`
-   Put this config in that folder: `git clone https://github.com/alunturner/neovim $HOME/.config/nvim`
