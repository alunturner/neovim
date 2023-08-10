## Description
Minimalist and organised neovim config [based on this.](https://github.com/tokiory/neovim-boilerplate)

## Aims
- Simplicity
  - As simple as reasonably practicable for an IDE experience
  - Use as few plugins as possible
- Good documentation
  - Commented lua files
  - Up to date cheatsheet for reference
- Go with the grain
  - Try to follow the vim philosophy
  - Although optimised for [this moonlander layout](https://configure.zsa.io/moonlander/layouts/d7lan/latest/0)
, should be usable on any regular keyboard
  as simple as is reasonably practicable

## Requirements
- [Basic understanding of lua](https://learnxinyminutes.com/docs/lua/)
TODO Think this may need some sort of icon install, nerdfont?
TODO Ripgrep?

## Use it
```bash
[ -d $HOME/.config/nvim ] && mv $HOME/.config/{nvim,nvim.old}; \
    git clone https://github.com/alunturner/neovim $HOME/.config/nvim
```

## Plugins
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [neo-tree](https://github.com/nvim-tree/nvim-tree.lua)
- [telescope](https://github.com/nvim-telescope/telescope.nvim)
- [cmp](https://github.com/hrsh7th/nvim-cmp)
- [lspkind](https://github.com/onsails/lspkind.nvim)
- [Git Signs](https://github.com/lewis6991/gitsigns.nvim)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [Tree Sitter](https://github.com/tree-sitter/tree-sitter)
- [sonokai](https://github.com/sainnhe/sonokai)

## Cheatsheet
TODO Generated automatically by running `./cheat.sh`.
