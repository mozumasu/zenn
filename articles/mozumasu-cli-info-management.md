---
title: "ターミナルでメモ管理 (Neovim/nb/WezTerm/zeno.zsh) "
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [neovim, cli, wezterm, nb]
published: false
---

## なぜyouはターミナルでメモを?

もともと私はNotionユーザーでした。
しかし、GUIがメインのツールはどうしてもカスタマイズに限界があったり、キーバインドを強制されたりと、**「人間がツールに合わせないといけない」** という課題がありました。

また、情報整理にかける時間を減らし、最小限のキー入力でメモを取れるようにしたいという思いもありました。

とくに検索機能は弱く、正規表現での検索ができなかったり、検索結果のプレビューができなかったりと、**「情報を取り出す」** という点でストレスを感じることが多々ありました。

Neovimで画像を表示できるようになったこともあり、これを機にターミナルでメモを取る環境を整えることにしました。

@[card](https://www.reddit.com/r/neovim/comments/1irk9mg/snacksimage_inline_image_math_video_frame/)
[snacks.image: inline image / math / video (frame) rendering : r/neovim](https://www.reddit.com/r/neovim/comments/1irk9mg/snacksimage_inline_image_math_video_frame/)

### メモに求めるもの

記録を残す上で最も大切なのは、以下のような「メモを取る動作」を高速に回すことだと思います。

メモを取る動作

- ファイルを作成 → 編集 → 保存
- 検索 → 追記
- 別ファイルへの参照を追加

そしてこの動作を高速に回すためには、以下のような要件が必要だと考えました。

- ディレクトリ管理を意識しない
- どのパスからでもアクセスできる
- ファイル名もタイトルも考えたくない
- 自動保存してGitHubで管理

これらを満たすツールとして、私は `nb` を選びました。
`Obsidian` も検討したのですが、CLIコマンドの提供が無さそうだったので、今回は見送りました。

## nb

nbはメモを管理するCLIツールです。

@[card](https://github.com/xwmx/nb)

以下のように、コマンドでメモを追加/編集/検索などができます。

```sh:nbの基本操作コマンド
# メモを追加 (エイリアス: nb a)
nb add

# メモ一覧を表示 (エイリアス: nb ls)
nb list

# メモを編集 (エイリアス: nb e)
nb edit メモ番号

# メモを検索（タイトル・内容両方） (エイリアス: nb q)
nb search "キーワード"

# タイトル・ファイル名のみで検索
nb ls "キーワード"

# 内容のみで検索したい場合はgrep/rgを使用
rg "キーワード" "$(nb notebooks current --path)"
```

メモは自動保存されるため、保存をサボってしまう人でも安心ですね。
GitHubリポジトリと連携する設定をしておくと、自動でpushまでやってくれます。

nbのインストールはHomebrewで簡単に行えます。

```sh
# nbのインストール
brew install xwmx/taps/nb
# 最新版の場合
brew install xwmx/taps/nb --head
```

### nbのnotebook管理

nbのメモはnotebookという単位で管理することができます。
ディレクトリ構造は以下のようになります。

```sh:nbのディレクトリ構成
~/.nb/
├── home/       # デフォルトのnotebook
│   ├── .git/
│   ├── 20251031152222.md
│   └── 20251101093045.md
└── work/       # 追加したnotebook
    ├── .git/
    ├── 20251105140030.md
    └── 20251106183012.md
```

例えば、普段使いのメモは home 、仕事用のメモは work のように notebook で分けて管理できます。
notebookごとにGitリポジトリを紐づける設定ができるので、普段使いのメモはプライベートリポジトリに、仕事用のメモはローカルのみで管理するといった使い方も可能です。

notebook のディレクトリはコマンドで簡単に作成できます。
コマンドで操作が可能なため、ディレクトリ構造を意識せずにメモを管理できます。

```sh:notebookの操作コマンド
# notebook一覧を表示
nb notebooks

# notebookを作成
nb notebooks add work

# notebookを切り替え
nb use work

# 現在のnotebookを確認
nb notebooks current

# 別のnotebookのメモを操作（notebook名:をつける）
nb ls work:
nb edit work:1
```

### nbの設定

#### nbで使用するエディタの設定

設定ファイルは`~/.nbrc`を使用します。
このファイルはnbをインストールと同時に自動生成されます。
内容は以下のようになっています。

```sh:~/.nbrc
#!/usr/bin/env bash
###############################################################################
# .nbrc
#
# Configuration file for `nb`, a command line note-taking, bookmarking,
# and knowledge base application with encryption, search, Git-backed syncing,
# and more in a single portable script.
#
# Edit this file manually or manage settings using the `nb settings`
# subcommand. Configuration options are set as environment variables, eg:
#   export NB_ENCRYPTION_TOOL=gpg
#
# https://github.com/xwmx/nb
###############################################################################
```

エディタを設定するには以下のコマンドを実行します。

```sh
# 使用するエディタを設定
nb set editor nvim
```

すると、`~/.nbrc` に以下の行が追加されます。

```sh
export EDITOR="nvim" # Set by `nb` • Thu Jan  9 12:52:05 JST 2025
```

このように、コマンドで設定を行うと自動的に設定ファイルに追記してくれます。
もちろん、手動で設定ファイルを編集しても問題ありません。

#### nbのファイルを管理するディレクトリの設定

各プロジェクトの移動はghqで行なっているため、nbのメモを保存するディレクトリもghqの管理下に置くことにしました。
ghqで使用しているディレクトリの指定は以下のように設定しています。

```sh
[ghq]
 root = ~/src
```

このディレクトリ配下であればghq listでnbのリポジトリも表示されるようになります。
ghq getでGitHubからリポジトリをクローンすると、`ghqのroot` + `github.com/自分のユーザー名/` 配下に配置されるため `github.com/mozumasu/nb` をnb管理ディレクトリに設定します。

```sh
nb set nb_dir
# ~/src/github.com/mozumasu/nbを入力してEnter
```

上記のコマンドを実行すると、 `~/.nbrc` に以下の行が追加されます。

```sh
export NB_DIR="${NB_DIR:-/Users/mozumasu/src/github.com/mozumasu/nb}" # Set by `nb` • Sat Jan 11 20:09:06 JST 2025
```

:::message

`~` は実際のパスである/Users/mozumasuとして解釈されます。
.nbrcに手動で~表記にしてもうまく反映されないため注意しましょう

:::

ノートを追加して、実際に ~/src/github.com/mozumasu/nb 配下にnbのディレクトリが追加されるか確認してみましょう。

```sh
# ノートを追加
nb notebooks add example
# ノートに対応するディレクトリが作成されているか確認
ls ~/src/github.com/mozumasu/nb
# example/ home/
```

#### GitHubリポジトリと連携する

nbのノートブックをGitHub管理して別端末でも利用できるように設定します。
どのノートブックのリポジトリかわかるように、nb-ノートブック名でリモートリポジトリを作成しましょう。

```sh
# デフォルトのnotebook (home) を管理するGitHubリポジトリを作成
gh repo create nb-home --private
```

用意したリモートリポジトリをnbのnotebookに紐づけます。

```sh
# 使用するノートブックを指定
nb use home
# 使用するリモートリポジトリの設定
nb remote set git@github.com:mozumasu/nb-home.git
```

これで、homeノートブックの変更が自動でGitHubリポジトリにpushされるようになります。

#### リストで表示される絵文字のカスタマイズ

`nb ls` でノート一覧を表示したときに、ノートの種類ごとに絵文字が表示されます。
この絵文字は設定ファイルでカスタマイズ可能です。

![nbのリストの絵文字](/images/info-management/nb-indicators.png)

```sh:~/.nbrc
export  NB_INDICATOR_AUDIO="🔉"
export  NB_INDICATOR_BOOKMARK="🔖"
export  NB_INDICATOR_DOCUMENT="📄"
export  NB_INDICATOR_EBOOK="📖"
export  NB_INDICATOR_ENCRYPTED="🔒"
export  NB_INDICATOR_FOLDER="📂"
export  NB_INDICATOR_IMAGE="🌄"
export  NB_INDICATOR_PINNED="📌"
export  NB_INDICATOR_TODO="✔️ "
export  NB_INDICATOR_TODO_DONE="✅"
export  NB_INDICATOR_VIDEO="📹"
```

:::details 最終的な~/.nbrcの例

```sh:~/.nbrc
#!/usr/bin/env bash
###############################################################################
# .nbrc
#
# Configuration file for `nb`, a command line note-taking, bookmarking,
# and knowledge base application with encryption, search, Git-backed syncing,
# and more in a single portable script.
#
# Edit this file manually or manage settings using the `nb settings`
# subcommand. Configuration options are set as environment variables, eg:
#   export NB_ENCRYPTION_TOOL=gpg
#
# https://github.com/xwmx/nb
###############################################################################

export EDITOR="nvim"                                                  # Set by `nb` • Thu Jan  9 12:52:05 JST 2025
export NB_DIR="${NB_DIR:-/Users/mozumasu/src/github.com/mozumasu/nb}" # Set by `nb` • Sat Jan 11 20:09:06 JST 2025

export NB_INDICATOR_AUDIO="🔉"
export NB_INDICATOR_BOOKMARK="🔖"
export NB_INDICATOR_DOCUMENT="📄"
export NB_INDICATOR_EBOOK="📖"
export NB_INDICATOR_ENCRYPTED="🔒"
export NB_INDICATOR_FOLDER="📂"
export NB_INDICATOR_IMAGE="🌄"
export NB_INDICATOR_PINNED="📌"
export NB_INDICATOR_TODO="✔️ "
export NB_INDICATOR_TODO_DONE="✅"
export NB_INDICATOR_VIDEO="📹"
```

:::

### zeno.zshとnbを組みあわせて幸せに

いちいち `nb ls` でノート番号を確認して `nb edit 番号` とするのは面倒です。
Tab補完で、fzfのようにプレビューが出せれば最高ですよね。
それ、zeno.zshでできちゃうんです。

![alt nbでzeno.zshの補完を使う](/images/info-management/nb-zeno.gif)
_nbのノート番号をzeno.zshでTab補完する_

zeno.zsh は zsh/fishのプラグインで以下の機能があります。

- スニペット設定
- fzf補完
- コマンド履歴検索

@[card](https://github.com/yuki-yano/zeno.zsh)

#### zeno.zshのインストール

シェルのプラグインマネージャーとして、動作が早い `sheldon` を使用してインストールします。

@[card](https://github.com/rossmacarthur/sheldon)

```sh
# 設定ファイルを生成
sheldon init --shell zsh

# Initialize new config file `~/.config/sheldon/plugins.toml`? [y/N] y
# Initialized ~/.config/sheldon/plugins.toml
```

実行すると以下のようなsheldonの設定ファイルが生成されます。

```toml:~/.config/sheldon/plugins.toml
# `sheldon` configuration file
# ----------------------------
#
# You can modify this file directly or you can use one of the following
# `sheldon` commands which are provided to assist in editing the config file:
#
# - `sheldon add` to add a new plugin to the config file
# - `sheldon edit` to open up the config file in the default editor
# - `sheldon remove` to remove a plugin from the config file
#
# See the documentation for more https://github.com/rossmacarthur/sheldon#readme

shell = "zsh"

[plugins]

# For example:
#
# [plugins.base16]
# github = "chriskempson/base16-shell"
```

合わせて、以下のコマンドを zshの設定ファイル(`~/.zshrc`)に追記して、プラグインを読み込むようにします。

```sh:~/.zshrc
eval "$(sheldon source)"
```

zeno.zshをインストールしたい場合は、以下のようにpluginsセクションに追記します。

```diff toml:~/.config/sheldon/plugins.toml
[plugins]
+ [plugins.zeno]
+ github = "yuki-yano/zeno.zsh"
+ [plugins.fast-syntax-highlighting]
+ github = "zdharma-continuum/fast-syntax-highlighting"
```

:::message

zsh-syntax-highlightingを使用している場合、zeno.zshの補完がうまく動作しないことがあります。
そのため、fast-syntax-highlightingに乗り換えることをおすすめします。

> FAQ
> Q: zsh-syntax-highlighting does not work well.
> A: Use fast-syntax-highlighting instead.

:::

:::message

もっとzeno.zshについて知りたい方はぜひ以下の記事もご覧ください!

@[card](https://eiji.page/blog/zeno-zsh-intro/)
@[card](https://eiji.page/blog/zeno-zsh-snippet/)

:::

zeno.zshの設定は、`~/.config/zeno/config.yml` に記述します。
nbのノート番号をTab補完したい場合はcompletionsセクションに以下のように追加します。

```yaml:~/.config/zeno/config.yml
completions:
  - name: nb edit
    patterns:
      - "^nb e( .*)? $"
      - "^nb edit( .*)? $"
    sourceCommand: "nb ls --no-color | grep -E '^\\[[0-9]+\\]'"
    options:
      --ansi: true  # ← ANSIカラー有効
      --prompt: "'nb edit >'"
      --preview: "echo {} | sed -E 's/^\\[([0-9]+)\\].*/\\1/' | xargs nb show"
    callback: "sed -E 's/^\\[([0-9]+)\\].*/\\1/'"
```

合わせてサブコマンドのヘルプを確認するための補完を設定するのもおすすめです。

```yaml:~/.config/zeno/config.yml
# TODO
completions:
  - name: nb subcommands
    patterns:
      - ^\s*nb\s*$
      - ^\s*nb\s+help\s*$
    sourceCommand: nb subcommands
    options:
      --prompt: "'nb subcommand >'"
    callback: echo {}
```

スニペットを登録する場合は以下のように追記してください。

```diff yaml:~/.config/zeno/config.yml
completions:
  ...

+ snippets:
+   - name: Edit Note
+     keyword: nbe
+     snippet: nb edit
+ 
+   - name: List Note
+     keyword: nbl
+     snippet: nb ls --limit 20
+ 
+   - name: List All Note
+     keyword: nbla
+     snippet: nb ls --all
+
+   - name: nb search
+     keyword: nbg
+     snippet: rg "{{keyword}}" "$(nb notebooks current --path)"
```

スニペットは以下のように、`space` キーで展開できます。

![zeno.zshのスニペットをnbで使う](/images/info-management/nb-zeno-snippet.gif)

### nb用に設定したシェル関数

#### nba: URLから記事をメモに追加

URLを渡すと記事のタイトルを自動取得してnbにメモを追加する関数です。

![nbにURLから記事を追加する](/images/info-management/nb-add-link.gif)

```sh:~/.zshrc
# nb add article - Add a note with article title and URL
# Usage: nba <url>              - Auto-fetch title from URL
#        nba <title> <url>      - Use specified title
function nba() {
  if [ $# -lt 1 ]; then
    echo "Usage: nba <url>           # Auto-fetch title"
    echo "       nba <title> <url>   # Manual title"
    return 1
  fi

  local title=""
  local url=""

  if [ $# -eq 1 ]; then
    url="$1"
    echo "Fetching title from: $url"

    title=$(curl -sL --max-redirs 3 --max-time 5 --compressed "$url" | head -c 512 | perl -0777 -ne 'print $1 if /<title[^>]*>([^<]+)<\/title>/i')
    title=$(echo "$title" | perl -pe 's/^\s+|\s+$//g; s/\s+/ /g')

    if [ -z "$title" ]; then
      echo "Error: Could not fetch title from URL"
      return 1
    fi
    echo "Title: $title"
  else
    title="$1"
    url="$2"
  fi

  local content="# ${title}

参照: [${title}](${url})"

  nb add --filename "${title}.md" --content "$content"
  echo "Note created: [${title}](${url})"
}
```

#### nbq: 検索結果をfzfで選択して編集

`nb search`の検索結果をfzfでプレビューしながら選択し、そのまま編集できる関数です。
![nbの検索結果をfzfでプレビューして編集する](/images/info-management/nb-fzf-grep.gif)

```sh:~/.zshrc
# nb query - Search notes and select with fzf preview
# Usage: nbq <search query>
function nbq() {
  if [ -z "$1" ]; then
    echo "Usage: nbq <search query>"
    return 1
  fi

  local query="$*"
  local results=$(nb q "$query" --no-color 2>/dev/null | grep -E '^\[[0-9]+\]')

  if [ -z "$results" ]; then
    echo "No results found for: $query"
    return 1
  fi

  export _NBQ_QUERY="$query"

  local selected=$(echo "$results" | fzf --ansi \
    --preview 'note_id=$(echo {} | sed -E "s/^\[([0-9]+)\].*/\1/")
               echo "=== Note [$note_id] ==="
               echo ""
               nb show "$note_id" | head -5
               echo ""
               echo "=== Matching lines ==="
               echo ""
               nb show "$note_id" | grep -i --color=always -C 2 "$_NBQ_QUERY" | head -30' \
    --preview-window=right:60%:wrap \
    --header "Search: $query")

  unset _NBQ_QUERY

  if [ -n "$selected" ]; then
    local note_id=$(echo "$selected" | sed -E 's/^\[([0-9]+)\].*/\1/')
    nb edit "$note_id"
  fi
}
```

## Neovim

Neovimをメモ編集用のエディタとして使用している理由は以下の通りです。

- 最も効率よくテキストするためのキーバインド
- 見た目もキーバインドもカスタマイズ可能
- 外部コマンドが実行できる
- 普段使用しているプラグインをそのまま使える

nb用に設定したNeovimの設定を紹介していきます。

### バッファタイトルの設定

nbのファイル名は自動でタイムスタンプになるため、ファイル名だけでは内容がわかりません。

![nvimでnbのノートを表示](/images/info-management/nvim-buffer-tab-before.png)

タブやバッファラインにファイル名ではなく1行目のタイトルを表示できます。

まず、nbのヘルパー関数を定義します。

```lua:~/.config/nvim/lua/config/nb.lua
local M = {}

-- nbノートのタイトルを取得する関数
function M.get_title(filepath)
  -- nbのディレクトリパスに合わせて変更してください
  local nb_dir = vim.fn.expand("~/.nb")
  if not filepath:match("^" .. nb_dir) then
    return nil
  end

  local file = io.open(filepath, "r")
  if not file then
    return nil
  end

  local first_line = file:read("*l")
  file:close()

  if first_line then
    -- "# タイトル" 形式からタイトルを抽出
    return first_line:match("^#%s+(.+)")
  end
  return nil
end

return M
```

LazyVimではタブの表示に [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) がデフォルトで使われているので、以下のように設定を拡張します。

```lua:~/.config/nvim/lua/plugins/bufferline.lua
return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    local nb = require("config.nb")
    opts.options = opts.options or {}
    opts.options.name_formatter = function(buf)
      local title = nb.get_title(buf.path)
      return title or buf.name
    end
  end,
}
```

![nbのタイトルをバッファラインに表示](/images/info-management/nvim-buffer-tab-after.png)
_bufferlineにnbのタイトルを表示_

### 検索の設定

ノートのタイトルや、ノートの内容をgrep検索して開きたいときに便利なのがファジーファインダー系のプラグインです。
LazyVimでは `snacks.nvim` がデフォルトで使用されているので、これを活用します。

@[card](https://github.com/folke/snacks.nvim)

検索でもファイル名ではなく、メモのタイトルで検索できるようにしています。

![snacks.nvimでnbのノートを検索する](/images/info-management/nb-snacks.gif)
_snacks.nvimでnbのノートを検索する_

以下は最小構成のnb用LazyVimプラグイン設定です。

```lua:~/.config/nvim/lua/plugins/nb.lua
-- nbコマンドを実行してノート一覧を取得
local function list_notes()
  local output = vim.fn.systemlist("NB_EDITOR=: NO_COLOR=1 nb list --no-color")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return output
end

-- ノートIDからファイルパスを取得
local function get_note_path(note_id)
  local path = vim.fn.system("NB_EDITOR=: NO_COLOR=1 nb show --path " .. note_id)
  return vim.trim(path)
end

-- snacks.nvimでノートを検索して開く
local function pick_notes()
  local Snacks = require("snacks")
  local notes = list_notes()
  if not notes then
    vim.notify("Failed to get notes", vim.log.levels.ERROR)
    return
  end

  -- ノート一覧をパース
  local items = {}
  for _, line in ipairs(notes) do
    local note_id, title = line:match("^%[(.-)%]%s+(.+)")
    if note_id then
      table.insert(items, {
        text = string.format("[%s] %s", note_id, title or "No title"),
        note_id = note_id,
      })
    end
  end

  -- ピッカーを表示
  Snacks.picker({
    title = "nb Notes",
    items = items,
    format = function(item)
      return { { item.text } }
    end,
    preview = function(ctx)
      local item = ctx.item
      if not item.file then
        item.file = get_note_path(item.note_id)
      end
      return Snacks.picker.preview.file(ctx)
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        local path = get_note_path(item.note_id)
        vim.cmd.edit(path)
      end
    end,
  })
end

return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>np", pick_notes, desc = "nb picker" },
  },
}
```

この設定で `<leader>np` を押すとnbのノート一覧がsnacks.nvimのピッカーで表示され、プレビューを見ながらノートを選択して開くことができます。

## WezTerm

メモを取るときに重宝している機能

### 特定のペインをZooMする機能

### ペインをトグルする

メモを書いていて、ふとコマンドを実行したくなることってありますよね?
そんな時はペインをZoomする機能にフォーカスも指定してあげると便利です。

### workspaceでメモ用のターミナルを分ける

メモ用にどのペインからもアクセスできるターミナルがあったら便利だと思いませんか?
そんな時はWezTermの [Workspaces](https://wezterm.org/recipes/workspaces.html?h=workspace) 機能を使うと良いでしょう。
Workspacesとは、 ターミナルの 作業空間(タブや分割した画面など)を丸ごと切り替える機能です。
イメージとしては、拡張デスクトップや、 ブラウザのタブのセット切り替えみたいなイメージです。

詳しくはこちらの記事が参考になります。
@[card](https://zenn.dev/sankantsu/articles/e713d52825dbbb)
