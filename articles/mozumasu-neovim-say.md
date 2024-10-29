---
title: "Neovimを喋らせたろ"
emoji: "🐈"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [neovim, say]
published: true
publishedAt: 2024-10-30 07:00
---

:::message
この記事は [Vim 駅伝](https://vim-jp.org/ekiden/) の 10/30 の記事です。
前回の記事は mikoto2000 さんによる、 10/28 の「[WezTerm 上の Vim で ALT 系のマッピングを使いたい](https://mikoto2000.blogspot.com/2024/10/wezterm-vim-alt.html)」という記事でした。

次回は 11/1 に投稿される予定です。
:::

## はじめに

私は英語が全くできません。
できなさすぎて「[Neovimで翻訳したろ](https://zenn.dev/mozumasu/articles/mozumasu-translate-in-vim)」という記事を書いたばかりです。
晴れてNeovimで翻訳できるようになったわけですが、せっかくなら一緒に発音も覚えたいですよね？

そんなわけでNeovimくんに喋ってもらうことにしました。

@[tweet](https://x.com/mozumasu/status/1848324058901020683)

## sayコマンド

そもそもターミナル上で喋らせる手段があるの？と思って調べたところ、どうやら`say`コマンドとかいうものがあるようです。
MacOSなら標準で入っています。Ubuntuであれば、`sudo apt-get install gnustep-gui-runtime`でインストールできます。
@[card](https://qiita.com/zakuroishikuro/items/0c17acb21f119647c205)

以下のコマンドで喋ってくれます。すごい！

```sh
say -v [好きな声] "喋らせたい言葉"
```

声の選定からしていきます。
システム設定 > 読み上げで検索 > 読み上げ言語 > システムの声 > 声を管理 (アプデ後なら声のiマーク) から好きな声を選びます。
![say voice setting](/images/neovim-say/say_voice_setting.gif)
英語の Ava(プレミアム) がかなり自然に聞こえていい感じなのでこちらを使用することにしました。

## カーソル下の単語を喋らせる

早速Neovimで`say`コマンドを使ってみます。
以下のように設定すると、`<leader>say`でカーソル下の単語を喋ってくれます。
カーソル下にある文字は`<cword>`で取得できます。

```lua ~/.config/nvim/lua/config/keymaps.lua
-- say command
keymap("n", "<leader>say", function()
  local current_word = vim.fn.expand("<cword>")
  vim.api.nvim_feedkeys(":!say -v Ava " .. current_word .. "\n", "n", false)
end, { desc = "say command" })
```

サクッと発音を知りたい時に便利ですね！

こちらの記事の`<cword>`の使い方もオススメです。
@[card](https://eiji.page/blog/nvim-hlslens-intro/)

:::details 余談: ちょっとだけ幸せになる`<cword>`の活用例

1. カーソル下にあるURLやファイルを開く

```lua ~/.config/nvim/lua/config/keymaps.lua
keymap("n", "gh", function()
  local cfile = vim.fn.expand("<cfile>")
  if cfile:match("^https?://") then
    os.execute("open '" .. cfile .. "'") -- for macOS
  else
    vim.cmd("normal! gF!")
  end
end, { desc = "link open" })
```

2. カーソル下のGitHubリポジトリを開く

lazy.nvimを使ってプラグインを導入する時以下のようなコードを書くことがあります。

```lua ~/.config/nvim/lua/plugins/hoge.lua
return {
  -- プラグイン名
  "vim-jp/vimdoc-ja",
}
```

以下のように設定しておくと、プラグイン名のところにカーソルを合わせて`<leader>gR`を入力するとプラグインのGitHubリポジトリを開くことができます。

```lua ~/.config/nvim/lua/config/keymaps.lua
keymap("n", "<leader>gR", function()
  local github_repogitory_name = vim.fn.expand("<cfile>")
  if github_repogitory_name:match(".+/[^/]+") then
    os.execute("open 'https://github.com/" .. github_repogitory_name .. "'") -- for macOS
  else
    vim.cmd("normal!, gF!")
  end
end, { desc = "GitHub repogitory" })
```

:::

## 翻訳しつつ、元の英文を喋ってもらう

以下のように設定すると、選択範囲を翻訳しつつ、元の英文を喋ってもらえます。

```lua ~/.config/nvim/lua/config/keymaps.lua
      {
        "<leader>tj",
        function()
          -- ビジュアルモードで選択された範囲をヤンクし、レジスタに保存
          vim.cmd('normal! "vy')
          local selected_text = vim.fn.getreg("v")
          -- vim-translatorのコマンドを実行
          vim.cmd("'<,'>TranslateW")
          -- sayコマンドにレジスタの内容を渡して非同期実行
          vim.uv.spawn("say", { args = { "-v", "Ava", selected_text } }, function() end)
        end,
        mode = "v",
        desc = "Read aloud the selected text using say command and register",
      },
```

sayコマンドをただ実行すると、読み上げ中はNeovimが操作できなくなってしまいます。
`vim.uv.spawn`を使って非同期で実行することで、読み上げ中もNeovimを操作できるようにしました。
`TranslateW`は前回の記事で紹介した翻訳プラグイン[vim-translator](https://github.com/voldikss/vim-translator)のコマンドです。

## 読み上げているところをハイライトする

sayコマンドには、`--interactive`オプションで読み上げている箇所をハイライトすることができます。
これをNeovim上でも再現してみました。
が、--interactiveのようにいい感じにリアルタイムでハイライトする方法が思いつかなかったので、一語ずつsayコマンドを実行する形式にしてみました。
単語ごとに読むので、ゆっくり単語単体の発音を確認しながら練習するのには良さそうです。

```lua ~/.config/nvim/lua/plugins/translator.lua
      {
        "<leader>tj",
        function()
          -- 選択範囲をヤンク
          vim.cmd('normal! "vy')
          -- レジスタの内容を変数に格納
          local selected_text = vim.fn.getreg("v")
          local words = vim.split(selected_text, "%s+")

          -- 選択範囲の開始行と開始列を取得
          local start_line = vim.fn.line("'<")
          local start_col = vim.fn.col("'<")
          local current_search_pos = 1

          -- 特定の単語を強調表示
          local function highlight_word(word_start_col, word_end_col, line)
            -- 以前の一致をクリア
            vim.fn.clearmatches()
            -- ハイライト
            vim.fn.matchaddpos("Search", { { line, word_start_col, word_end_col - word_start_col + 1 } })
          end

          -- sayコマンド
          local function spawn_say(index)
            if index <= #words then
              local word = words[index]

              -- 選択範囲内の文字列に基づいて単語列の位置を計算
              local word_start_col, word_end_col = string.find(selected_text, word, current_search_pos, true)
              if word_start_col == nil then
                return
              end

              current_search_pos = word_end_col + 1

              -- 単語を強調表示
              vim.schedule(function()
                if start_line then
                  highlight_word(start_col + word_start_col - 1, start_col + word_end_col - 1, start_line)
                end
              end)

              vim.uv.spawn("say", { args = { "-v", "Ava", word } }, function()
                spawn_say(index + 1)
              end)
            else
              -- 読み上げ終了したらハイライトをクリア
              vim.schedule(function()
                vim.fn.clearmatches()
              end)
            end
          end

          spawn_say(1)
        end,
        mode = "v",
        desc = "Read aloud the selected text using say command and highlight words",
      },
```

## どうにかして読み上げを単語ごとではなく一度に行う(作成中...)

単語ごとに読む形式だと、繋げて読むことによって変わる発音がわからないのが難点です。
以下のコードはハイライトのスピードを無理やりsayコマンドに合わせています。
手動で速さを指定するのでまだまだハイライトがずれてしまいます。

```lua ~/.config/nvim/lua/plugins/translator.lua
      {
        "<leader>tj",
        function()
          vim.cmd('normal! "vy')
          local selected_text = vim.fn.getreg("v")
          local words = vim.split(selected_text, "%s+")

          -- 読み上げ速度を設定 (1分間に読む単語数)
          local reading_speed_long = 160 -- 通常の単語用の速度
          local reading_speed_short = 300 -- 短い単語用の速度
          local reading_speed_fast_words = 350 -- 比較的速い単語用の速度
          local initial_highlight_delay = 1000 -- 最初の単語を長めに表示するための遅延
          local sentence_end_delay = 600 -- 文末の遅延
          local symbol_delay = 100 -- 記号を含む単語の遅延設定

          -- 比較的速く読む単語のリストを定義
          local fast_words = { "and", "the", "of", "in", "on", "to", "is", "it", "at", "by" }

          -- 文の終わりを判定するためのパターンにカンマやコロンを追加
          local sentence_end_chars = "[%.%?%!%,%:,%(]" -- 文末の記号（. ? ! , :）

          -- 記号を含む単語を検出するためのパターン
          local symbol_chars = "[%+%/]" -- 記号（+ や /）を含む単語

          -- 現在のビジュアルモードの選択範囲の行とカラムを取得
          local start_line = vim.fn.line("'<") -- 選択範囲の開始行
          local start_col = vim.fn.col("'<") -- 選択範囲の開始カラム
          local current_search_pos = 1 -- 検索開始位置を管理

          -- 比較的速く読む単語のリストにあるかどうかを確認する関数
          local function is_fast_word(word)
            for _, fast_word in ipairs(fast_words) do
              if word == fast_word then
                return true
              end
            end
            return false
          end

          -- 単語が文末句読点 ( と : を含む) で終わっているかどうかをチェック
          local function is_sentence_end(word)
            return string.find(word, sentence_end_chars .. "$") ~= nil
          end

          -- 単語に特殊記号が含まれているかどうかをチェック
          local function contains_symbol(word)
            return string.find(word, symbol_chars) ~= nil
          end

          -- 単語を強調表示
          local function highlight_word(word_start_col, word_end_col)
            vim.fn.clearmatches()
            vim.fn.matchaddpos("Search", { { start_line, word_start_col, word_end_col - word_start_col + 1 } })
          end

          -- ハイライトをクリア
          local function clear_highlight()
            vim.fn.clearmatches()
          end

          -- sayコマンド実行
          local function read_text()
            vim.uv.spawn("say", { args = { "-v", "Ava", selected_text } }, function()
              vim.schedule(function()
                clear_highlight()
              end)
            end)
          end

          -- 単語ごとにハイライトを適用していく関数
          local function highlight_sequentially(index)
            if index > #words then
              -- 全ての単語がハイライトされた後にハイライトをクリア
              clear_highlight()
              return
            end

            -- 選択したテキスト内の現在の単語の開始位置と終了位置をセット
            local word = words[index]
            local word_start_col, word_end_col = string.find(selected_text, word, current_search_pos, true)
            if word_start_col then
              -- 検索位置を更新して次の単語の位置をセット
              current_search_pos = word_end_col + 1

              -- 現在の単語をハイライト
              vim.schedule(function()
                highlight_word(start_col + word_start_col - 1, start_col + word_end_col - 1)
              end)
            end

            local time_per_word
            if index == 1 then
              -- 最初の単語の場合、特別に長めに表示する
              time_per_word = initial_highlight_delay
            elseif is_fast_word(word) then
              -- 比較的速く読む単語の場合
              time_per_word = 60000 / reading_speed_fast_words
            elseif #word <= 3 then
              -- 3文字以内の短い単語の場合は高速でハイライト
              time_per_word = 60000 / reading_speed_short -- 短い単語用の時間
            else
              -- 通常の単語の場合は通常速度でハイライト
              time_per_word = 60000 / reading_speed_long -- 通常の単語用の時間
            end

            -- 文末の単語の場合、特別に長いハイライトを適用
            if is_sentence_end(word) then
              time_per_word = time_per_word + sentence_end_delay
            end

            -- 記号が含まれる単語の場合、特別な遅延を適用
            if contains_symbol(word) then
              time_per_word = time_per_word + symbol_delay
            end

            -- 次の単語に移動
            vim.defer_fn(function()
              highlight_sequentially(index + 1)
            end, time_per_word) -- 計算された時間で次の単語に移動
          end

          -- 全文をsayコマンドで読み上げ開始
          read_text()

          -- ハイライト
          highlight_sequentially(1)
        end,
        mode = "v",
        desc = "Read aloud the selected text using say command and highlight each word sequentially",
      },
```

手動で速さを指定するのが途方もないので別の方法で実現した方が良さそうです。

## 終わりに

よくよく考えたらポップアップ表示やfloating windowでsay --interactiveのようにハイライトすれば良いのでは...?と考えた時には時間切れでした😢
Neovimって無限に遊べて楽しいですね！！
