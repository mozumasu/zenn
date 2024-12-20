---
title: "NeovimのCopilotを設定する"
emoji: "💭"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [neovim, copilot]
published: false
---

## はじめに

LazyVimでは~/.config/nvim/init.luaに以下の設定を追加するとCopilotが使用できるようになります。

```diff lua:~/.config/nvim/lua/config/lazy.lua
require("lazy").setup({
  spec = {
+   { import = "lazyvim.plugins.extras.ai.copilot" },
    -- import/override with your plugins
    { import = "plugins" },
  },
```

しかし、Extrasに変更が加わって自分の環境でうまく動かなくなる事象が発生しました。
そのため、Extrasをそのままimportするのをやめて、設定ファイルを追加して管理することにしました。

今回はそのついでに以下の設定を追加していきます。

- YAMLでもcopilot補完を有効にする
- Enter補完をTab補完に変更

## Copilotの設定

### ExtrasのCopilotの設定を非有効にする

公式ドキュメントにもコードはのっていますが、extrasをそのまま使用するのではなく、
現状のデフォルト設定から変更して使用したいためまずextras管理をやめます。

```diff lua:~/.config/nvim/lua/config/lazy.lua
require("lazy").setup({
  spec = {
-   { import = "lazyvim.plugins.extras.ai.copilot" },
    -- import/override with your plugins
    { import = "plugins" },
  },

```

### Copilotの設定ファイルを用意する

Copilotの設定ファイル`~/.config/nvim/lua/config/copilot.lua`を用意します。
用意したファイルに現状のLazyVimのcopilot.luaの設定をコピーして貼り付けます。

@[card](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/copilot.lua)

```lua:~/.config/nvim/lua/config/copilot.lua
return {
  recommended = true,
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- add ai_accept action
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      LazyVim.cmp.actions.ai_accept = function()
        if require("copilot.suggestion").is_visible() then
          LazyVim.create_undo()
          require("copilot.suggestion").accept()
          return true
        end
      end
    end,
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(
        opts.sections.lualine_x,
        2,
        LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
          local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
          if #clients > 0 then
            local status = require("copilot.api").status.data.status
            return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
          end
        end)
      )
    end,
  },

  vim.g.ai_cmp
      and {
        -- copilot cmp source
        {
          "hrsh7th/nvim-cmp",
          optional = true,
          dependencies = { -- this will only be evaluated if nvim-cmp is enabled
            {
              "zbirenbaum/copilot-cmp",
              opts = {},
              config = function(_, opts)
                local copilot_cmp = require("copilot_cmp")
                copilot_cmp.setup(opts)
                -- attach cmp source whenever copilot attaches
                -- fixes lazy-loading issues with the copilot cmp source
                LazyVim.lsp.on_attach(function()
                  copilot_cmp._on_insert_enter({})
                end, "copilot")
              end,
              specs = {
                {
                  "hrsh7th/nvim-cmp",
                  optional = true,
                  ---@param opts cmp.ConfigSchema
                  opts = function(_, opts)
                    table.insert(opts.sources, 1, {
                      name = "copilot",
                      group_index = 1,
                      priority = 100,
                    })
                  end,
                },
              },
            },
          },
        },
        {
          "saghen/blink.cmp",
          optional = true,
          dependencies = { "giuxtaposition/blink-cmp-copilot" },
          opts = {
            sources = {
              default = { "copilot" },
              providers = {
                copilot = {
                  name = "copilot",
                  module = "blink-cmp-copilot",
                  kind = "Copilot",
                  score_offset = 100,
                  async = true,
                },
              },
            },
          },
        },
      }
    or nil,
}
```

### YAMLでもcopilot補完を有効にする

このコードを編集していきます。
まず、YAMLでもcopilotの補完したいので、filetypesに`yaml = true`を追加します。

```diff lua:~/.config/nvim/lua/plugins/copilot.lua
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
+       yaml = true,
        help = true,
      },
    },
  },
```

### Enter補完をTab補完に変更

Tab補完にするために以下の変更を加えます。

```diff lua:~/.config/nvim/lua/plugins/copilot.lua
        {
          "saghen/blink.cmp",
          optional = true,
          dependencies = { "giuxtaposition/blink-cmp-copilot" },
          opts = {
-           keymap = { preset = "default" },
+           keymap = { preset = "super-tab" },
            sources = {
              default = { "copilot" },
              providers = {
                copilot = {
                  name = "copilot",
                  module = "blink-cmp-copilot",
                  kind = "Copilot",
                  score_offset = 100,
                  async = true,
                },
              },
            },
          },
        },
```

### スパルタンVimmer

タブ補完には以下の選択しがあり、スパルタンVimmerは`<C-y>`を使用するようです。
