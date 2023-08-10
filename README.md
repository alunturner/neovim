## Description
[Based on this.](https://github.com/tokiory/neovim-boilerplate)

Designed with the following aims. It should:
- Be as simple as is reasonably practicable
- Use as few plugins as possible
- Document everything that is used
- Keep rebinding to a minimum
- Work with a [moonlander mk1 keyboard, with this layout](https://configure.zsa.io/moonlander/layouts/d7lan/latest/0)

(This is the entry point for understanding what is going on.)[https://github.com/alunturner/neovim/blob/main/init.lua].

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
Generated automatically by running `./cheat.sh`.
