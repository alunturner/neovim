├── init.lua - entry point
└── lua
    ├── core
    │   ├── loader.lua - setup a loader and load plugins, uses [lazy](https://github.com/folke/lazy.nvim.git)
    │   ├── remaps.lua - vim remappings
    │   └── settings.lua - vim options
    ├── plugins
    │   ├── autocomplete.lua - available completion options, uses [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    │   ├── explore.lua - file tree, uses [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
    │   ├── find.lua - fuzzy finder, uses [telescope](https://github.com/nvim-telescope/telescope.nvim)
    │   ├── formatter.lua - per file type formatting rules, uses [formatter](https://github.com/mhartington/formatter.nvim)
    │   ├── git.lua - git symbols, uses [gitsigns](https://github.com/lewis6991/gitsigns.nvim)
    │   ├── lsp.lua - language server protocols, uses [nvim-lsp-config](https://github.com/neovim/nvim-lspconfig)
    │   ├── theme.lua - colour theme, uses [sonokai](https://github.com/sainnhe/sonokai)
    │   └── treesitter.lua - better highlighting and navigation, uses [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
    └── utils
        └── keys.lua - for setting keys