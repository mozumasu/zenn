---
title: "NeoVimで翻訳したろ"
emoji: "😊"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [neovim, vim]
published: false
---

:::message
この記事は [Vim 駅伝](https://vim-jp.org/ekiden/) の 10/14 の記事です。
前回の記事は [delphinus](https://x.com/delphinus35) さんによる、 10/11 の「[0.10 時代の Neovim Lua](https://qiita.com/delphinus/items/2c993527df40c9ebaea7)」という記事でした。

次回は 10/21 に投稿される予定です。
:::

## はじめに

個人開発やdotfilesを育てている時に、ふとカッコつけて英語でコミットメッセージやコメントを書きたくなることがあります。
しかし、そのためだけにNeovimから離れるなんて耐えられません。
そこでNeovim内で翻訳できるプラグインをご紹介します。

## 翻訳できるプラグイン

単語や行ごとに翻訳するなら
@[card](https://github.com/voldikss/vim-translator)
長めの文章を翻訳するなら
@[card](https://github.com/potamides/pantran.nvim)

といった感じで使い分けています。
どちらもGoogle翻訳を使用しています。他の翻訳エンジンも設定可能です。

:::details 設定ファイル(パッケージマネージャー: lazy.nvim)

`<cmd>`と`:`が混在しているのは、Visualモードの時の挙動が安定しないためです。
置き換えのコマンド(`<leader>trj`や`<leader>tre`で設定しているやつ)は複数行ある場合はうまく動きません。

```lua ~/.config/nvim/lua/plugins/translator.lua
return {
  {
    "voldikss/vim-translator",
    cmd = { "TranslateW", "TranslateW --target_lang=en" },
    keys = {
      -- Popup
      { "<leader>t", "", desc = "Translate" },
      { "<leader>tj", "<cmd>TranslateW<CR>", mode = "n", desc = "Translate words into Japanese" },
      { "<leader>tj", ":'<,'>TranslateW<CR>", mode = "v", desc = "Translate lines into Japanese" },
      { "<leader>te", "<cmd>TranslateW --target_lang=en<CR>", mode = "n", desc = "Translate words into English" },
      { "<leader>te", ":'<,'>TranslateW --target_lang=en<CR>", mode = "v", desc = "Translate lines into English" },
      -- Replace
      { "<leader>tr", "", desc = "Translate Replace" },
      -- Replace to Japanese
      { "<leader>trj", ":'<,'>TranslateR<CR>", mode = "v", desc = "Replace to Japanese" },
      {
        "<leader>trj",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          -- Execute the conversion command after a short delay.
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR\n", "n", false)
          end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to Japanese",
      },
      -- Replace to English
      { "<leader>tre", ":'<,'>TranslateR --target_lang=en<CR>", mode = "v", desc = "Replace to English" },
      {
        "<leader>tre",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          -- Run translator command after a short delay
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR --target_lang=en\n", "n", false)
          end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to English",
      },
    },
    config = function()
      vim.g.translator_target_lang = "ja"
      vim.g.translator_default_engines = { "google" }
      vim.g.translator_history_enable = true
      vim.g.translator_window_type = "popup"
      vim.g.translator_window_max_width = 0.5
      vim.g.translator_window_max_height = 0.9 -- 1 is not working
    end,
  },

  {
    "potamides/pantran.nvim",
    keys = {
      { "<leader>tw", "<cmd>Pantran<CR>", mode = { "n", "v" }, desc = "Show Translate Window" },
    },
    config = function()
      require("pantran").setup({
        default_engine = "google",
        engines = {
          google = {
            fallback = {
              default_source = "en",
              default_target = "ja",
            },
            -- NOTE: must set `DEEPL_AUTH_KEY` env-var
            -- deepl = {
            --   default_source = "",
            --   default_target = "",
            -- },
          },
        },
        ui = {
          width_percentage = 0.8,
          height_percentage = 0.8,
        },
        window = {
          title_border = { "⭐️ ", " ⭐️    " }, -- for google
          window_config = { border = "rounded" },
        },
        controls = {
          mappings = { -- Help Popup order cannot be changed
            edit = {
              -- normal mode mappings
              n = {
                -- ["j"] = "gj",
                -- ["k"] = "gk",
                ["S"] = require("pantran.ui.actions").switch_languages,
                ["e"] = require("pantran.ui.actions").select_engine,
                ["s"] = require("pantran.ui.actions").select_source,
                ["t"] = require("pantran.ui.actions").select_target,
                ["<C-y>"] = require("pantran.ui.actions").yank_close_translation,
                ["g?"] = require("pantran.ui.actions").help,
                --disable default mappings
                ["<C-Q>"] = false,
                ["gA"] = false,
                ["gS"] = false,
                ["gR"] = false,
                ["ga"] = false,
                ["ge"] = false,
                ["gr"] = false,
                ["gs"] = false,
                ["gt"] = false,
                ["gY"] = false,
                ["gy"] = false,
              },
              -- insert mode mappings
              i = {
                ["<C-y>"] = require("pantran.ui.actions").yank_close_translation,
                ["<C-t>"] = require("pantran.ui.actions").select_target,
                ["<C-s>"] = require("pantran.ui.actions").select_source,
                ["<C-e>"] = require("pantran.ui.actions").select_engine,
                ["<C-S>"] = require("pantran.ui.actions").switch_languages,
              },
            },
            -- Keybindings here are used in the selection window.
            select = {},
          },
        },
      })
    end,
  },
}
```

:::

## vim-translator (Vim/Neovim)

ポップアップウィンドウで翻訳を表示したり、文字を置き換えたりすることができます。
@[card](https://github.com/voldikss/vim-translator)

### カーソル位置の単語を翻訳

`:TranslateW`でカーソル位置の単語を翻訳してポップアップを表示します。

![TranslateW](/images/translate-in-vim/translate_to_ja.png =700x)

`:TranslateW`の引数に`--target_lang=en`を渡すことで言語を指定できます。
![TranslateW --target_lang=en](/images/translate-in-vim/translate_to_en.png =700x)

### 選択した文字を翻訳

選択した状態でも翻訳することができます。
![TranslateW line](/images/translate-in-vim/translate_line_to_ja.gif =700x)

### 選択した文字を翻訳して置換

`:TranslateR`で選択範囲の文字を翻訳して置換もできます。

![TranslateR](/images/translate-in-vim/translate_replace_to_ja.gif =700x)

### 選択しなくても翻訳して置換

以下のように設定することで、文字を選択していなくてもカーソル行をまとめて翻訳して置換できます。

```lua ~/.config/nvim/lua/plugins/translator.lua
    keys = {
      { "<leader>t", "", desc = "Translate" },
      { "<leader>tr", "", desc = "Translate Replace" },
      -- Replace to Japanese
      {
        "<leader>trj",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          -- Execute the conversion command after a short delay.
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR\n", "n", false)
          end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to Japanese",
      },
      -- Replace to English
      { "<leader>tre", ":'<,'>TranslateR --target_lang=en<CR>", mode = "v", desc = "Replace to English" },
      {
        "<leader>tre",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          -- Run translator command after a short delay
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR --target_lang=en\n", "n", false)
          end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to English",
      },
    },
```

![TranslateR without selection](/images/translate-in-vim/translate_replace_without_selection.gif =700x)

## pantran.nvim (Neovim)

長めの文章を翻訳する時に使っています。
日本語を英語に翻訳してコメントやコミットメッセージを書く時にも重宝します。

@[card](https://github.com/potamides/pantran.nvim)

### ウィンドウで翻訳

### おまけ: manコマンドの出力をどうにかこうにかして翻訳する

急ぎでmanコマンドの内容確認しないといけない時に日本語にして読みたくなることがあります。
絶対もっといい方があるとは思いつつ置いておきます。
