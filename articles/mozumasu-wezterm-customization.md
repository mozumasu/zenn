---
title: "[wezterm] モテるターミナルにカスタマイズしよう"
emoji: "😊"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [wezterm, CLI, terminal]
published: false
---

## はじめに

ターミナルがかっこいいとモテるらしいというのをどこかの記事で読んだので、かっこよくターミナルをカスタマイズしてみました。
完成系はこんな感じです。

使用しているターミナルは[wezterm](https://wezfurlong.org/wezterm/)です。
weztermの特徴は以下の通りです。

- Rust製でとにかく早い
- カスタマイズ性が高い
- 設定ファイルはNeovimと同じLua言語
- tmuxのような画面分割ができる
- 豊富なドキュメントがある

他にも色々良さがあるので、詳しくは公式ドキュメントを参照していただければと思います。

## weztermのインストール

Homebrewでインストールする場合は下記のコマンドを実行します。

```bash
brew install --cask wezterm
```

> Homebrew: <https://formulae.brew.sh/cask/wezterm>
> wezterm公式: <https://wezfurlong.org/wezterm/installation>

## 設定ファイルの用意

設定ファイルは`~/.wezterm.lua`に配置します。
uiの設定とキーバインドを別のファイルに分けて管理する派の方は`~/.config/wezterm/wezterm.lua`と`~/.config/wezterm/keybind.lua`で分けるのもありです。
この記事では後者で設定していきます。
このカスタマイズを機に設定ファイルをGitHubで管理したくなった場合は下記の記事が参考にしてください。
[ようこそdotfilesの世界へ #Vim - Qiita](https://qiita.com/yutkat/items/c6c7584d9795799ee164)

設定ファイルを作成したら下記のような設定の雛形を用意しましょう。

```lua:~/.wezterm.lua
-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'

-- and finally, return the configuration to wezterm
return config
```

> 参照: [Configuration - Wez's Terminal Emulator](https://arc.net/l/quote/upsihqso)

## window全体の設定

### fontサイズの変更

まずは作業がしやすいようにフォントサイズを変更しましょう。
また、カラースキームは設定しないため削除します。
(Luaのコメントアウトがdiffで-表示されてしまうためコメントアウトも削除しています。)

```diff lua:~/.wezterm.lua
- -- Pull in the wezterm API
local wezterm = require 'wezterm'

- -- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true
+ config.font_size = 12.0

- -- This is where you actually apply your config choices

- -- For example, changing the color scheme:
- config.color_scheme = 'AdventureTime'

- -- and finally, return the configuration to wezterm
return config
```

### IMEで日本語を入力をできるようにする

```diff:lua



```

### 背景の透過

続いては己の気分をブチ上げるための設定をします。
そう、背景の透過です。
人類皆一度はスケスケのターミナルに憧れを抱くものです。

```diff lua:~/.wezterm.lua
local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.automatically_reload_config = true
config.font_size = 12.0
+ config.window_background_opacity = 0.85

return config
```

値は0~1の間で設定します。0に近いほどスケスケになります。

### ぼかしを追加

とはいえ、スケスケすぎると文字が見づらいというもの。
ぼかしを入れつつスケスケと生産性を両立しましょう。
これができる大人というもの。

## タブの設定

手始めにタブを透明にしてみましょう。

```

```

## 最後に

イケイケターミナルで自己肯定感アゲてこ！🫶🩷
オレオレ設定やdotfilesの布教をお待ちしております。
