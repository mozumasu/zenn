---
title: "NeoVimでAIに質問したい(avante.nvim)"
emoji: "😎"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [neovim, plugin]
published: false
---

## はじめに

Cursorみたいに、NeoVimでAIに質問できるプラグインを紹介します。
@[card](https://github.com/yetone/avante.nvim)

## avante.nvimとは

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

プロバイダーの設定が住んでいない場合は`ANTHROPIC_API_KEY`の入力を求められます。
![avante start](/images/avante/avante_start.png)

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
