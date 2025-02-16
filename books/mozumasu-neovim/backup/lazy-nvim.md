---
title: "パッケージ管理マネージャーを使ってみよう 【lazy.nvim】"
---

## lazy.nvim とは

lazy.nvim は、NeoVim のパッケージ管理マネージャーです。NeoVim には標準でパッケージ管理機能がありますが、lazy.nvim はその機能を拡張したものです。
遅延リロードなどを設定することができます。

## lazy.nvim のインストール

lazy.nvimは1つのファイルで管理することもできますが、複数のファイルに分割することもできます。

```lua:~~/.config/nvim/init.lua
require("config.lazy")
```

```lua:~/.config/nvim/lua/config/lazy.lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
```

> 参照: [🛠️ Installation | lazy.nvim](https://lazy.folke.io/installation)

lazy.nvimのディレクトリ構成は以下のようになっています。

```text
~/.config/nvim
├── lua
│   ├── config
│   │   └── lazy.lua
│   └── plugins
│       ├── spec1.lua
│       ├── **
│       └── spec2.lua
└── init.lua
```

実際に Neovimを開いて、`lazy.nvim` を起動してみましょう。

```sjh
nvim
```

Neovim の画面で`:Lazy`を実行します。

---

## プラグインを追加指定みよう

プラグインを追加したい場合は、以下のように`plugins`ディレクトリを作成し、中にプラグインの設定を記載したファイル(拡張子lua)を作成します。

```diff text
~/.config/nvim
  ├── lua
  │   ├── config
  │   │   ├── autocmds.lua
  │   │   ├── keymaps.lua
  │   │   ├── lazy.lua
  │   │   └── options.lua
+ │   └── plugins
+ │       ├── spec1.lua
+ │       ├── **
+ │       └── spec2.lua
  └── init.lua
```

pluginsディレクトリに配置するファイルの名前はプラグイン名や、役割に応じて自由に命名してください。
今回は`editor.lua`という名前でプラグインの設定ファイルを追加します。

プラグインの設定ファイルでは必ずluaテーブルを返すようにしてください。

```lua:~/.config/nvim/lua/config/plugins/editor.lua
return {}
```

```diff lua:~/.config/nvim/lua/config/plugins/editor.lua
return {
+ {
+   "folke/which-key.nvim",
+   event = "VeryLazy",
+   opts_extend = { "spec" },
+   opts = {
+     preset = "helix",
+     defaults = {},
+     spec = {
+       {
+         mode = { "n", "v" },
+         { "<leader><tab>", group = "tabs" },
+         { "<leader>c", group = "code" },
+         { "<leader>d", group = "debug" },
+         { "<leader>dp", group = "profiler" },
+         { "<leader>f", group = "file/find" },
+         { "<leader>g", group = "git" },
+         { "<leader>gh", group = "hunks" },
+         { "<leader>q", group = "quit/session" },
+         { "<leader>s", group = "search" },
+         { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
+         { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
+         { "[", group = "prev" },
+         { "]", group = "next" },
+         { "g", group = "goto" },
+         { "gs", group = "surround" },
+         { "z", group = "fold" },
+         {
+           "<leader>b",
+           group = "buffer",
+           expand = function()
+             return require("which-key.extras").expand.buf()
+           end,
+         },
+         {
+           "<leader>w",
+           group = "windows",
+           proxy = "<c-w>",
+           expand = function()
+             return require("which-key.extras").expand.win()
+           end,
+         },
+         -- better descriptions
+         { "gx", desc = "Open with system app" },
+       },
+     },
+   },
+   keys = {
+     {
+       "<leader>?",
+       function()
+         require("which-key").show({ global = false })
+       end,
+       desc = "Buffer Keymaps (which-key)",
+     },
+     {
+       "<c-w><space>",
+       function()
+         require("which-key").show({ keys = "<c-w>", loop = true })
+       end,
+       desc = "Window Hydra Mode (which-key)",
+     },
+   },
+   config = function(_, opts)
+     local wk = require("which-key")
+     wk.setup(opts)
+     if not vim.tbl_isempty(opts.defaults) then
+       LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
+       wk.register(opts.defaults)
+     end
+   end,
+ },
}
```

> 参照: [Editor | LazyVim](https://www.lazyvim.org/plugins/editor#which-keynvim)  
> <https://github.com/LazyVim/LazyVim/blob/45d94b3197eaf3f35754b8ecb7adebfcebe5160d/lua/lazyvim/plugins/editor.lua#L48C1-L118C5>

`opts.defaults`が非推奨でリンターのエラーが表示されます。
とはいえ、念の為defaultsを使用した場合でも`swhich-key.nvim`にキー登録できるようにしておきたいので、`---@diagnostic disable-next-line: deprecated`を追加してエラーを無視するようにします。

```diff lua:~/.config/nvim/lua/config/plugins/editor.lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      if not vim.tbl_isempty(opts.defaults) then
        LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
+       ---@diagnostic disable-next-line: deprecated
        wk.register(opts.defaults)
      end
    end,
  },
}
```

このファイルで追加されるプラグインは`which-key.nvim`です。`which-key.nvim`はキーマップを表示するためのプラグインです。

@[card](https://github.com/folke/which-key.nvim)
