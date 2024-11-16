---
title: "クソザコだってVimりたい！(Neovim,LazyVim)"
emoji: "💤"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [lazyvim, neovim, lua]
published: false
---

## 概要

NeovimをカスタマイズしてVimのキーバインドを練習する環境を構築していくよ=^・ω・^=

こんな人にオススメ

- Vimのキーバインドを開発で試してみたいな
- カスタマイズってどうやるの？
- LazyVimってどんな感じで設定されてるんだろ
- 思考の速さでコーディングしたい

## なぜ人はVimるのか

Vimは歴史のあるテキストエディターです。
昨今新しいエディターが次々と登場していますが、今もVimを使い始める人が後を絶ちません。(ソース: [エンジニアの楽園Vim-jp](https://vim-jp.org/docs/chat.html))
その自分なりに理由を考えてみました。

- 起動が爆速
- ターミナルで使える
- VimならVim Script、NeovimならLuaで細かくカスタマイズできる
- マウスを使わずに爆速コーディングできる
- 独特だが慣れると快適なキーバインド
- かっこいい
- ただでさえかっこいいのに、カスタマイズでさらにかっこいい

ちなみにVimといえば、VimとNeovimという2つのエディターがあります。
違いを知りたい方は下記の記事を参考にしてみてください。
今回はNeovimを使っていきます。
@[card](https://qiita.com/powdersugar828828/items/f31ca3bd28d3163fae6a)

Vimmerの方の画面を見ると人間離れした速さでコードを書いていてまるで魔法を使っているかのように感じます。
そんなVimmerに憧れて、Vimを使ってみたいと思っている方も多いのではないでしょうか？

Vimに慣れるためには実際に使ってみることが一番です。

🐮 < 「設定が済んでいるやつで試せたらなぁ〜」
🦥 < 「そんなあなたにセットアップ済みのNeovimをご紹介！！」

LazyVimのスターターを導入すれば今すぐVimのキーバインドでコーディングを始めることができます！
![LazyVim](https://user-images.githubusercontent.com/292349/213447056-92290767-ea16-430c-8727-ce994c93e9cc.png)

しかも見た目はこんな感じに簡単に変更できちゃうんです。(デフォルトのキーバインド: `leader`→`u`→`C`)
![alt change color](/images/lazyvim/change_color.gif =700x)
日替わりでテーマを変えて楽しむことだってできちゃいまね。

設定済みのNeovimを使ってみることによって、設定方法を知りつつキーバインドの設定なども参考にすることができます。
この記事を読み終わる頃にはNeovimのカスタマイズに興味が湧いていることでしょう。

早速LazyVimを使ってバチイケコーディング環境を構築しちゃいましょう！

## LazyVimとは

LazyVimとは[lazy.nvim](https://github.com/folke/lazy.nvim)というプラグインマネージャーでNeovimをセットアップしたものです。
@[card](https://www.lazyvim.org/)
このセットアップは簡単に拡張したり、カスタマイズできたりするのでVimの初心者にもおすすめです。

すでにセットアップ済みのNeovimといえば、LazyVim意外にも[AstroNvim](https://astronvim.com/)というものもあります。
LazyVimとAstroNvimの設定を見比べるのも結構面白いです。
@[card](https://github.com/AstroNvim/astrocommunity)

### Dockerでサクッと試す

お試しで触ってみたい方はDockerで試すことができます。

```sh
docker run -w /root -it --rm alpine:edge sh -uelic '
  apk add git lazygit neovim ripgrep alpine-sdk --update
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  cd ~/.config/nvim
  nvim
'
```

::: details Dockerの雑な説明

Dockerを使用すると、ホストマシンの隔離された領域で特定のコマンドを1つのプロセスとして実行することができます。

今回の場合は、隔離された領域にAlpine Linuxの最新版をインストールし、LazyVimをセットアップするためのコマンドを実行してnvimというNeovimを起動するコマンドを実行しています。

Dockerはこちらの本が仕組みから解説されていておすすめです。
[開発系エンジニアのためのDocker絵とき入門](https://amzn.asia/d/9CO0UzZ)
:::

---

## LazyVimのスターターを導入

公式ドキュメントに従ってLazyVimを導入していきます。

> [🛠️ Installation | LazyVim](https://www.lazyvim.org/installation)

まず既存のNeovimの設定ファイルをバックアップします。

```sh
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

LazyVimをインストールします。

```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

不要な.gitディレクトリを削除します。

```sh
rm -rf ~/.config/nvim/.git
```

試しにNeovimを起動してみましょう。

```sh
nvim
```

## 設定方法

LazyVimの公式ドキュメントが充実しているので、参考にしつつ設定していきましょう。

## ファイル構成

LazyVimの設定ファイルの全体像は以下の通りです。

```sh
~/.config/nvim               # Neovimの設定ディレクトリ
├── lua
│   ├── config
│   │   ├── autocmds.lua     # 自動コマンド（autocmd）の設定ファイル
│   │   ├── keymaps.lua      # キーマッピング（ショートカットキー）の設定ファイル
│   │   ├── lazy.lua         # Lazy.nvim（プラグインマネージャー）の設定ファイル
│   │   └── options.lua      # 基本オプション設定ファイル
│   └── plugins              # プラグインの設定ファイルを保存するディレクトリ
│       ├── spec1.lua        # プラグインの設定を記述したLuaスクリプト（1つ目の設定例）
│       └── spec2.lua        # プラグインの設定を記述したLuaスクリプト（2つ目の設定例）
└── init.toml                # Neovimの初期化設定ファイル（Lazy.nvimや特殊設定で使う場合）
```

> [⚙️ Configuration | LazyVim](https://www.lazyvim.org/configuration)

一般的な設定は`~/.config/nvim/lua/config`ディレクトリに配置します。
このディレクトリ配下にある`autocmds.lua`, `keymaps.lua`, `lazy.lua`, `options.lua`の4つのファイルは自動で読み込まれるため、手動でrequireする必要はありません。

```sh diff
~/.config/nvim                 # Neovimの設定ディレクトリ
  ├── lua
  │   ├── config
+ │   │   ├── autocmds.lua     # 自動コマンド（autocmd）の設定ファイル
+ │   │   ├── keymaps.lua      # キーマッピング（ショートカットキー）の設定ファイル
+ │   │   ├── lazy.lua         # Lazy.nvim（プラグインマネージャー）の設定ファイル
+ │   │   └── options.lua      # 基本オプション設定ファイル
  │   └── plugins              # プラグインの設定ファイルを保存するディレクトリ
  │       ├── spec1.lua        # プラグインの設定を記述したLuaスクリプト（1つ目の設定例）
  │       └── spec2.lua        # プラグインの設定を記述したLuaスクリプト（2つ目の設定例）
  └── init.toml                # Neovimの初期化設定ファイル（Lazy.nvimや特殊設定で使う場合）
```

> [General Settings | LazyVim](https://www.lazyvim.org/configuration/general)

プラグインを追加したい場合は、`~/.config/nvim/lua/config/plugins`ディレクトリに配置します。
例としてspec1.lua, spec2.luaというファイルがありますが、実際にプラグインを追加する場合は`プラグイン名.lua`や`機能名.lua`などのファイル名にしておくとわかりやすいです。

```sh diff
~/.config/nvim                 # Neovimの設定ディレクトリ
  ├── lua
  │   ├── config
  │   │   ├── autocmds.lua     # 自動コマンド（autocmd）の設定ファイル
  │   │   ├── keymaps.lua      # キーマッピング（ショートカットキー）の設定ファイル
  │   │   ├── lazy.lua         # Lazy.nvim（プラグインマネージャー）の設定ファイル
  │   │   └── options.lua      # 基本オプション設定ファイル
  │   └── plugins              # プラグインの設定ファイルを保存するディレクトリ
+ │       ├── spec1.lua        # プラグインの設定を記述したLuaスクリプト（1つ目の設定例）
+ │       └── spec2.lua        # プラグインの設定を記述したLuaスクリプト（2つ目の設定例）
  └── init.toml                # Neovimの初期化設定ファイル（Lazy.nvimや特殊設定で使う場合）
```

## 日本語や赤い波線が引かれる

拡張子が.mdのファイルを開くと日本語に大量の赤い波線が引かれていることがあります。
![alt マークダウンファイルの日本語に赤い波線が引かれる](/images/lazyvim/spellcheck.png =700x)
下記のようにoptions.luaに設定を追加することで解決できます。

```lua:~/.config/nvim/lua/config/options.lua
-- vim標準スペルチェックから日本語を除外
vim.opt.spelllang:append("cjk")
```

また、Vimの辞書に登録されていない単語がある場合にも赤い線が引かれることがあります。
辞書に登録したい場合は登録したい文字にカーソルを合わせて`zg`を押します。

Vimでの日本語の扱いは以下の記事が参考になります。
@[card](https://zenn.dev/vim_jp/articles/e038e42b0e78d5)

## どんな設定がされているかをコードで確認したい

そんな時は、公式ドキュメントの`General Settings`が参考になります。
それぞれの項目の`Default Auto Commands`タブに設定内容が書いてあります。
[General Settings | LazyVim](https://www.lazyvim.org/configuration/general)

## 既存の設定を変えたい

設定を変えたい場合はすでに設定されている項目を上書きしたり無効化することができます。
参照：[Plugins | LazyVim](https://www.lazyvim.org/configuration/plugins)

### プラグインを追加

プラグインを追加する場合は`~/.config/nvim/lua/config/plugins/`ディレクトリに拡張子がluaのファイルを追加します。
ファイル名はプラグイン名や、機能を表す名前にしておくとわかりやすいです。

```lua:~/.config/nvim/lua/config/plugins/hoge.lua
return {
  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
    },
  },
}
```

### プラグインを無効化

プラグインを無効化する場合は、enabledをfalseに設定します。
設定したコードを削除せずに無効化できるのが嬉しいですね。

```lua:~/.config/nvim/lua/config/plugins/hoge.lua
return {
  -- プラグイン名, enabled = false で無効化できる
  { "folke/trouble.nvim", enabled = false },
}
```

## キーバインドを変更

キーバインドを自分で設定する場合は、`LazyVim.safe_keymap_set`ではなく、`vim.keymap.set`を使用します。
デフォルトのキーバインドを無効化したい場合は、`vim.keymap.del`を使用します。

```lua

```

> [Keymaps | LazyVim](https://www.lazyvim.org/configuration/keymaps)

### キーバインドを無効化

特定のキーバインドを無効化する場合は下記のようにfalseを設定していして無効化できます。

```lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- キーバインドを指定して無効化
    {"<leader>/", false},
    -- キーバインドの変更
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    -- add a keymap to browse plugin files
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
  },
},
```

### キーバインドをまとめて無効化

一つずつ指定して設定するのが面倒な場合は下記のように無効化することも可能です。

```lua
return {
  "nvim-telescope/telescope.nvim",
  -- すでにある設定を無効化して、新しく設定
  keys = function()
    return {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    }
  end,
},
```

::: details deprecated: floatingターミナルの設定を変更

ver13.x以降では`LazyVim.terminal`は非推奨となりました。
<https://www.lazyvim.org/news#13x>

### ターミナルに枠をつける

公式ドキュメントですでに設定されている内容を確認すると、下記のようになっています。

```lua
-- floating terminal
local lazyterm = function() LazyVim.terminal(nil, { cwd = LazyVim.root() }) end
map("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<leader>fT", function() LazyVim.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
```

ふむふむ、どうやら`control` + `/`でターミナルを表示/非表示ができるようですね。
押してみると、ターミナルが表示されました。

境界線がわかりづらいので、ターミナルに枠をつけてみましょう。
下記の記事によると、`lazyvim.util`を使うと枠がつけられるようです。
@[card](https://zenn.dev/sijiaoh/articles/bfa3a2e2054cee)

早速設定してみましょう。

```lua:~/.config/nvim/lua/config/keymaps.lua
local keymap = vim.keymap.set
-- terminal
local lazyterm = function()
  util.terminal(nil, { cwd = util.root(), border = "rounded" })
end

-- floating terminal
keymap("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
keymap("n", "<leader>fT", function()
  LazyVim.terminal()
end, { desc = "Terminal (cwd)" })
keymap("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
keymap("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
meymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
```

`border`は`"rounded"`の他にも`"single"`や`"double"`もあるようです。
自分はデフォルトのキーバインドがしっくりこなかったので、カスタマイズしています。↓
::: details ターミナルのキーバインド（オレオレ設定編）
デフォルトから変えたもの

- ノーマルモードに戻るキーバインド: `<esc><esc>`→`<esc>`
- 使用していないキーバインドを無効化(`vim.keymap.del`で指定)

プロジェクトのルートで開きたい時は`<c-/>`, カレントディレクトリで開きたい時は`<c-_>`で設定しています。
片方でサーバーを常時起動して、もう片方で作業をする、みたいな使い方にも便利です。

```lua:~/.config/nvim/lua/config/keymaps.lua
local keymap = vim.keymap.set
local keydel = vim.keymap.del

-- terminal
local lazyterm = function()
  util.terminal(nil, { cwd = util.root(), border = "rounded" })
end

-- floating terminal
keymap("n", "<c-_>", lazyterm, { desc = "Terminal (cwd)" })
keymap("n", "<c-/>", function()
  util.terminal(nil, { border = "double" })
end, { desc = "Terminal (root)" })
keymap("t", "<esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- disable default keymappings
keydel("n", "<leader>ft", { desc = "Terminal (cwd)" })
keydel("n", "<leader>fT", { desc = "Terminal (root)" })
keydel("t", "<C-h>", { desc = "Go to Left Window" })
keydel("t", "<C-j>", { desc = "Go to Lower Window" })
keydel("t", "<C-k>", { desc = "Go to Upper Window" })
keydel("t", "<C-l>", { desc = "Go to Right Window" })
```

:::

## Neovimから出たくない

みなさんは、エディタ内でありとあらゆることを完結させたいという欲望はありませんか？
私はあります。できるだけNeovimに引きこもれるように設定していきましょう。

### Lazy Extras

LazyVimには[Extras](https://www.lazyvim.org/extras)という機能があり、セットアップ済みの拡張機能を追加することができます。
Extrasはコマンド`:LazyExtras`でサクッと追加する方法と、設定ファイルに追加する方法の2通りがあります。

```diff lua:~/.config/nvim/lua/config/lazy.lua
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
+   { import = "lazyvim.plugins.extras.util.octo" },
    { import = "plugins" },
  },
})
```

常に追加したい機能はファイルに追加し、一時的に使いたい機能はコマンドで追加するという使い分けができます。

### GitHub

issueやプルリクエストは[Octo](https://www.lazyvim.org/extras/util/octo)で管理できます。

### docker管理

どうせならNeovim内でDockerも管理したいですよね？したいよね？
そんなあなたにおすすめのプラグインがこちら！
colimaでdockerを起動し、lazydockerでコンテナを管理しましょう！

@[card](https://github.com/abiosoft/colima)
@[card](https://github.com/jesseduffield/lazydocker)
`control + /`でターミナルを開いて、`colima start`でDockerを起動します。
そして、`<leader>d`でlazydockerを開くことができます。
lazydockerのキーバインドは`?`を押すと現在いるpane内で使用できるキーバインド一覧が表示されます。

lazydockerをNeovim内で開くための設定は以下の通りです。

```lua:~/.config/nvim/lua/config/keymaps.lua
-- lazydocker
if vim.fn.executable("lazydocker") == 1 then
  vim.keymap.set("n", "<leader>d", function()
    util.terminal("lazydocker", { esc_esc = false, ctrl_hjkl = false, border = "rounded" })
  end, { desc = "LazyDocker" })
end
```

Dockerfileを書く場合はLazyExtrasの機能を追加するものもあるので、ぜひ試してみてください。

```lua:~/.config/nvim/lua/config/lazy.lua
    { import = "lazyvim.plugins.extras.lang.docker" },
```

> [Docker | LazyVim](https://www.lazyvim.org/extras/lang/docker)

## ちょっとしたTips

### 他の人の設定をみてみる

周りにVimmerがおらず、設定方法が悩ましい場合はGitHubの検索を使うのがオススメです。
GitHubにはファイルパスを指定して検索する機能があります。
以下のように検索欄に入力すると、neo-tree.luaというファイルを検索することができます。
プラグイン名.luaみたいな感じで検索することが多いです。

```sh
path:**/neo-tree.lua
```

パス意外にもissueやPRで検索することもできます。
検索ヒット数が少ないのであればフィルターをCodeにしてファイル名のみで検索をかけることもあります。

## 最後に

Vimmerが増えたら嬉しいな。

### 参照

URLを開く
[VimでgfしたらURLをブラウザで開く](https://blog.atusy.net/2023/12/09/gf-open-url/)
