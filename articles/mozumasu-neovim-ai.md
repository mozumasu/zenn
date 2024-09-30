---
title: "NeoVimでAIに質問したい(avante.nvim)"
emoji: "😎"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [neovim, plugin]
published: false
---

## この記事でやること

- [x] Cursorみたいに、AIに質問できるにする
- [x] Copilotの導入

:::details 導入するプラグイン
Cursorみたいにする
@[card](https://github.com/yetone/avante.nvim)

Copilotの導入
@[card](https://github.com/zbirenbaum/copilot.lua)
@[card](https://github.com/hrsh7th/nvim-cmp)
@[card](https://github.com/zbirenbaum/copilot-cmp)
:::

## 忙しい人向け：完成系の設定ファイル

読むのが面倒な人向けに完成系の設定ファイルを置いておく。
:::details 設定ファイル

:::

## CursorみたいにAIに質問できるようにする(avante.nvim)

avante.nvimとは、Cursor AI IDE をエミュレートするように設計されたNeoVimプラグインです。
lazy.nvimでインストールする場合は下記のコードを追加します。

```lua:~/.config/nvim/lua/plugins/avante.lua
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
```

プロバイダーの設定が済んでいない場合は`ANTHROPIC_API_KEY`の入力を求められます。
まずはプロバイダーの設定を行いましょう。
![avante start](/images/neovim-ai/avante_start.png)

### プロバイダーを設定

プロバイダはClaudeやOpenAI、Copilotが簡単に設定できるようになっています。
Copilotを普段使用しているため、ここではCopilotをプロバイダーに設定します

```diff lua:~/.config/nvim/lua/plugins/avante.lua
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
+    provider = "copilot",
  },
  -- 長いので省略
}
```

他のプロバイダーを設定する場合は[avanteのwiki](https://github.com/yetone/avante.nvim/wiki)が参考になります。

## キーバインド

デフォルトのキーバインドは以下の通りです。

| Key Binding        | Description                              |
| ------------------ | ---------------------------------------- |
| `<leader>` `a` `a` | サイドバーを表示                         |
| `<leader>` `a` `r` | 再度バーを更新                           |
| `<leader>` `a` `e` | 選択範囲を編集                           |
| `c` `o`            | 選択(chose ours)                         |
| `c` `t`            | 選択(chose theirs)                       |
| `c` `a`            | 選択(chose all theirs)                   |
| `c` `0`            | 選択(chose none)                         |
| `c` `b`            | 選択(chose both)                         |
| `c` `c`            | 選択(chose cursor)                       |
| `]` `x`            | 前の競合に移動                           |
| `[` `x`            | 次の競合に移動                           |
| `[` `[`            | 前のコードブロックに移動(結果ウィンドウ) |
| `]` `]`            | 次のコードブロックに移動(結果ウィンドウ) |

## Copilot

NeovimでCopilotを使用したい場合はCopilot.luaがオススメです。

Copilotをいい感じに使用する場合は下記のプラグインを使用します。

LazyVimで使用したい場合は、以下のように一行加えるだけで設定できます。

```diff lua:~/.config/nvim/lua/config/lazy.lua
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
+   { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "plugins" },
  },
})
```

> [Copilot | LazyVim](https://www.lazyvim.org/extras/coding/copilot)

### デフォルトの設定を変更する

Extrasのデフォルトの設定だとEnterで補完するようになっているため、意図せずに補完が適用されることがあります。
Tabで補完できるように変更します。

とはいえ自力で一から設定するのは難しそうなので公式の設定を参考にしつつ、カスタマイズしてみましょう。
設定するプラグインは下記の3つです。

- [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)

これらの設定を自分の環境にも反映していきましょう。
ファイル名は自由に設定して大丈夫です。
まずはファイルを用意。

```sh
touch ~/.config/nvim/lua/plugins/copilot.lua
```

設定はreturn {}で囲む必要があります。

```diff lua:~/.config/nvim/lua/plugins/copilot.lua
+ return {}
```

このreturnの中に公式の設定を貼り付けます。
:::details 公式の設定

> [Copilot | LazyVim](https://www.lazyvim.org/extras/coding/copilot)

copilot.lua

```lua
{
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
```

nvim-cmp

```lua
{
  "nvim-cmp",
  dependencies = {
    {
      "zbirenbaum/copilot-cmp",
      dependencies = "copilot.lua",
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)
        -- attach cmp source whenever copilot attaches
        -- fixes lazy-loading issues with the copilot cmp source
        LazyVim.lsp.on_attach(function(client)
          copilot_cmp._on_insert_enter({})
        end, "copilot")
      end,
    },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, 1, {
      name = "copilot",
      group_index = 1,
      priority = 100,
    })
  end,
}
```

copilot-cmp

```lua
{
  "zbirenbaum/copilot-cmp",
  dependencies = "copilot.lua",
  opts = {},
  config = function(_, opts)
    local copilot_cmp = require("copilot_cmp")
    copilot_cmp.setup(opts)
    -- attach cmp source whenever copilot attaches
    -- fixes lazy-loading issues with the copilot cmp source
    LazyVim.lsp.on_attach(function(client)
      copilot_cmp._on_insert_enter({})
    end, "copilot")
  end,
}
```

lualine.nvim(optional)

```lua
{
  "nvim-lualine/lualine.nvim",
  optional = true,
  event = "VeryLazy",
  opts = function(_, opts)
    local colors = {
      [""] = LazyVim.ui.fg("Special"),
      ["Normal"] = LazyVim.ui.fg("Special"),
      ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
      ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
    }
    table.insert(opts.sections.lualine_x, 2, {
      function()
        local icon = LazyVim.config.icons.kinds.Copilot
        local status = require("copilot.api").status.data
        return icon .. (status.message or "")
      end,
      cond = function()
        if not package.loaded["copilot"] then
          return
        end
        local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
        if not ok then
          return false
        end
        return ok and #clients > 0
      end,
      color = function()
        if not package.loaded["copilot"] then
          return
        end
        local status = require("copilot.api").status.data
        return colors[status.status] or colors[""]
      end,
    })
  end,
}
```

:::

```diff lua:~/.config/nvim/lua/plugins/copilot.lua
return {
+   {
+     "zbirenbaum/copilot.lua",
+     cmd = "Copilot",
+     build = ":Copilot auth",
+     opts = {
+       suggestion = { enabled = false },
+       panel = { enabled = false },
+       filetypes = {
+         markdown = true,
+         help = true,
+       },
+     },
+   },
+   {
+     "nvim-cmp",
+     dependencies = {
+       {
+         "zbirenbaum/copilot-cmp",
+         dependencies = "copilot.lua",
+         opts = {},
+         config = function(_, opts)
+           local copilot_cmp = require("copilot_cmp")
+           copilot_cmp.setup(opts)
+           -- attach cmp source whenever copilot attaches
+           -- fixes lazy-loading issues with the copilot cmp source
+           LazyVim.lsp.on_attach(function(client)
+             copilot_cmp._on_insert_enter({})
+           end, "copilot")
+         end,
+       },
+     },
+     ---@param opts cmp.ConfigSchema
+     opts = function(_, opts)
+       table.insert(opts.sources, 1, {
+         name = "copilot",
+         group_index = 1,
+         priority = 100,
+       })
+     end,
+   },
+   {
+     "zbirenbaum/copilot-cmp",
+     dependencies = "copilot.lua",
+     opts = {},
+     config = function(_, opts)
+       local copilot_cmp = require("copilot_cmp")
+       copilot_cmp.setup(opts)
+       -- attach cmp source whenever copilot attaches
+       -- fixes lazy-loading issues with the copilot cmp source
+       LazyVim.lsp.on_attach(function(client)
+         copilot_cmp._on_insert_enter({})
+       end, "copilot")
+     end,
+   },
+   {
+     "nvim-lualine/lualine.nvim",
+     optional = true,
+     event = "VeryLazy",
+     opts = function(_, opts)
+       local colors = {
+         [""] = LazyVim.ui.fg("Special"),
+         ["Normal"] = LazyVim.ui.fg("Special"),
+         ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
+         ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
+       }
+       table.insert(opts.sections.lualine_x, 2, {
+         function()
+           local icon = LazyVim.config.icons.kinds.Copilot
+           local status = require("copilot.api").status.data
+           return icon .. (status.message or "")
+         end,
+         cond = function()
+           if not package.loaded["copilot"] then
+             return
+           end
+           local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
+           if not ok then
+             return false
+           end
+           return ok and #clients > 0
+         end,
+         color = function()
+           if not package.loaded["copilot"] then
+             return
+           end
+           local status = require("copilot.api").status.data
+           return colors[status.status] or colors[""]
+         end,
+       })
+     end,
+   },
}
```

下記のように変更します。

```diff lua:~/.config/nvim/lua/plugins/copilot.lua
return {
  省略
  {
    "nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "copilot.lua",
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          LazyVim.lsp.on_attach(function(client)
            copilot_cmp._on_insert_enter({})
          end, "copilot")
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })
+      -- Change the key mapping for completion from Enter to Tab
+      opts.mapping = {
+        ['<Tab>'] = require('cmp').mapping.confirm({ select = true }),
+      }
    end,
  },
  省略
}
```
