---
title: "クール・ウィンドウ・マネジメント"
emoji: "😺"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [JankyBorders, AeroSpace, SketchyBar]
published: false
---

:::message
この記事は[ミライトデザイン Advent Calendar 2024](https://qiita.com/advent-calendar/2024/miraito-inc)の12/7の記事です。
明日12/8は[]()さんの「[]()」という記事です。
:::

## はじめに

日々プロダクト開発に勤しむものとして、視界に映るディスプレイも美しくあるべきです。
もちろん従来のデザインも美しいのですが、やはり自分の信じる美しさを追求していくことも大切です。

どうやら世の中には「UnixPorn」という言葉があるようです。

> 「UnixPorn」とは、 PC-UNIXのカスタマイズされたデスクトップスクリーンショットのことや、 そのスクリーンショットが沢山投稿されているredditの板のことを指しています。

@[card](https://neko-mac.blogspot.com/2022/04/unixporn.html)

この存在を知ってからというものデスクトップをカスタマイズせずにはいられなくなったため、
今回はウィンドウマネジメントやMenu barのカスタマイズについて紹介します。

## この記事でやること

- [AeroSpace](https://github.com/nikitabobko/AeroSpace)の設定 : ウィンドウマネジメントツール
- [JankyBorders](https://github.com/FelixKratz/JankyBorders)の設定 : アクティブウィンドウに枠をつける
- [SketchyBar](https://github.com/FelixKratz/SketchyBar)の設定 : メニューバーのカスタマイズ

:::details 設定ファイルの完成系(AeroSpace, JankyBorders, SketchyBar)

:::

## AeroSpace: ウィンドウマネジメント

私はRaycastでウィンドウのリサイズや移動を行っていましたが、外部ディスプレイを接続するとウィンドウの位置がずれるなどの問題が発生しました。
また、設定をコード管理したいという思いもあり、他のウィンドウマネジメントツールを探してみました。

ウィンドウ管理するツールといえば、以下のようなものがあります。

@[card](https://github.com/rxhanson/Rectangle)
@[card](https://magnet.crowdcafe.com/)
@[card](https://github.com/i3/i3)
@[card](https://github.com/koekeishiya/yabai)
@[card](https://www.raycast.com)

Yabaiも候補にあるのですが、MACのセキュリティ設定を変更する必要があるため、今回はAeroSpaceを使用してみることにしました。
AeroSpaceというツールが動画で使い方を解説していたためこちらを使用してみることにしました。
@[card](https://github.com/nikitabobko/AeroSpace)

youtubeに詳細な解説がのっているためぜひ参考にしていただきたいです。
どんな機能があるかは概要紹介の動画を見ていただけるとわかりやすいです。

**使い方の概要**

@[youtube](https://youtu.be/UOl7ErqWbrk?si=wFvtNex4sCGk_T0y)

**詳しい設定方法**

@[youtube](https://youtu.be/-FoWClVHG5g?si=QhcJhuEkmHAHRWGI)

### AeroSpaceのインストール

```sh
brew install --cask nikitabobko/tap/aerospace
```

### AeroSpaceの設定

AeroSpaceの設定は以下の2箇所のどちらかで行います。

- `~/.aerospace.toml`
- $`{XDG_CONFIG_HOME}/aerospace/aerospace.toml`

※`XDG_CONFIG_HOME`が設定されていない場合は、`~/.config/aerospace/aerospace.toml`が読み込まれます。

公式ドキュメントにあるコードを`~/.config/aerospace/aerospace.toml`にコピーします。

:::details aerospace.tomlのデフォルト設定

```toml:~/.config/aerospace/aerospace.toml
# Place a copy of this config to ~/.aerospace.toml
# After that, you can edit ~/.aerospace.toml to your liking

# You can use it to add commands that run after login to macOS user session.
# 'start-at-login' needs to be 'true' for 'after-login-command' to work
# Available commands: https://nikitabobko.github.io/AeroSpace/commands
after-login-command = []

# You can use it to add commands that run after AeroSpace startup.
# 'after-startup-command' is run after 'after-login-command'
# Available commands : https://nikitabobko.github.io/AeroSpace/commands
after-startup-command = []

# Start AeroSpace at login
start-at-login = false

# Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
enable-normalization-flatten-containers = true
enable-normalization-opposite-orientation-for-nested-containers = true

# See: https://nikitabobko.github.io/AeroSpace/guide#layouts
# The 'accordion-padding' specifies the size of accordion padding
# You can set 0 to disable the padding feature
accordion-padding = 30

# Possible values: tiles|accordion
default-root-container-layout = 'tiles'

# Possible values: horizontal|vertical|auto
# 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
#               tall monitor (anything higher than wide) gets vertical orientation
default-root-container-orientation = 'auto'

# Mouse follows focus when focused monitor changes
# Drop it from your config, if you don't like this behavior
# See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
# See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
# Fallback value (if you omit the key): on-focused-monitor-changed = []
on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

# You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
# Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
# Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
automatically-unhide-macos-hidden-apps = false

# Possible values: (qwerty|dvorak)
# See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
[key-mapping]
preset = 'qwerty'

# Gaps between windows (inner-*) and between monitor edges (outer-*).
# Possible values:
# - Constant:     gaps.outer.top = 8
# - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
#                 In this example, 24 is a default value when there is no match.
#                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
#                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
[gaps]
inner.horizontal = 0
inner.vertical =   0
outer.left =       0
outer.bottom =     0
outer.top =        0
outer.right =      0

# 'main' binding mode declaration
# See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
# 'main' binding mode must be always presented
# Fallback value (if you omit the key): mode.main.binding = {}
[mode.main.binding]

# All possible keys:
# - Letters.        a, b, c, ..., z
# - Numbers.        0, 1, 2, ..., 9
# - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
# - F-keys.         f1, f2, ..., f20
# - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
#                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
# - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
#                   keypadMinus, keypadMultiply, keypadPlus
# - Arrows.         left, down, up, right

# All possible modifiers: cmd, alt, ctrl, shift

# All possible commands: https://nikitabobko.github.io/AeroSpace/commands

# See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
# You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
# alt-enter = '''exec-and-forget osascript -e '
# tell application "Terminal"
#     do script
#     activate
# end tell'
# '''

# See: https://nikitabobko.github.io/AeroSpace/commands#layout
alt-slash = 'layout tiles horizontal vertical'
alt-comma = 'layout accordion horizontal vertical'

# See: https://nikitabobko.github.io/AeroSpace/commands#focus
alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'

# See: https://nikitabobko.github.io/AeroSpace/commands#move
alt-shift-h = 'move left'
alt-shift-j = 'move down'
alt-shift-k = 'move up'
alt-shift-l = 'move right'

# See: https://nikitabobko.github.io/AeroSpace/commands#resize
alt-shift-minus = 'resize smart -50'
alt-shift-equal = 'resize smart +50'

# See: https://nikitabobko.github.io/AeroSpace/commands#workspace
alt-1 = 'workspace 1'
alt-2 = 'workspace 2'
alt-3 = 'workspace 3'
alt-4 = 'workspace 4'
alt-5 = 'workspace 5'
alt-6 = 'workspace 6'
alt-7 = 'workspace 7'
alt-8 = 'workspace 8'
alt-9 = 'workspace 9'
alt-a = 'workspace A' # In your config, you can drop workspace bindings that you don't need
alt-b = 'workspace B'
alt-c = 'workspace C'
alt-d = 'workspace D'
alt-e = 'workspace E'
alt-f = 'workspace F'
alt-g = 'workspace G'
alt-i = 'workspace I'
alt-m = 'workspace M'
alt-n = 'workspace N'
alt-o = 'workspace O'
alt-p = 'workspace P'
alt-q = 'workspace Q'
alt-r = 'workspace R'
alt-s = 'workspace S'
alt-t = 'workspace T'
alt-u = 'workspace U'
alt-v = 'workspace V'
alt-w = 'workspace W'
alt-x = 'workspace X'
alt-y = 'workspace Y'
alt-z = 'workspace Z'

# See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
alt-shift-1 = 'move-node-to-workspace 1'
alt-shift-2 = 'move-node-to-workspace 2'
alt-shift-3 = 'move-node-to-workspace 3'
alt-shift-4 = 'move-node-to-workspace 4'
alt-shift-5 = 'move-node-to-workspace 5'
alt-shift-6 = 'move-node-to-workspace 6'
alt-shift-7 = 'move-node-to-workspace 7'
alt-shift-8 = 'move-node-to-workspace 8'
alt-shift-9 = 'move-node-to-workspace 9'
alt-shift-a = 'move-node-to-workspace A'
alt-shift-b = 'move-node-to-workspace B'
alt-shift-c = 'move-node-to-workspace C'
alt-shift-d = 'move-node-to-workspace D'
alt-shift-e = 'move-node-to-workspace E'
alt-shift-f = 'move-node-to-workspace F'
alt-shift-g = 'move-node-to-workspace G'
alt-shift-i = 'move-node-to-workspace I'
alt-shift-m = 'move-node-to-workspace M'
alt-shift-n = 'move-node-to-workspace N'
alt-shift-o = 'move-node-to-workspace O'
alt-shift-p = 'move-node-to-workspace P'
alt-shift-q = 'move-node-to-workspace Q'
alt-shift-r = 'move-node-to-workspace R'
alt-shift-s = 'move-node-to-workspace S'
alt-shift-t = 'move-node-to-workspace T'
alt-shift-u = 'move-node-to-workspace U'
alt-shift-v = 'move-node-to-workspace V'
alt-shift-w = 'move-node-to-workspace W'
alt-shift-x = 'move-node-to-workspace X'
alt-shift-y = 'move-node-to-workspace Y'
alt-shift-z = 'move-node-to-workspace Z'

# See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
alt-tab = 'workspace-back-and-forth'
# See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

# See: https://nikitabobko.github.io/AeroSpace/commands#mode
alt-shift-semicolon = 'mode service'

# 'service' binding mode declaration.
# See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
[mode.service.binding]
esc = ['reload-config', 'mode main']
r = ['flatten-workspace-tree', 'mode main'] # reset layout
f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout backspace = ['close-all-windows-but-current', 'mode main']

# sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
#s = ['layout sticky tiling', 'mode main']

alt-shift-h = ['join-with left', 'mode main']
alt-shift-j = ['join-with down', 'mode main']
alt-shift-k = ['join-with up', 'mode main']
alt-shift-l = ['join-with right', 'mode main']
```

:::

> 参照: [AeroSpace Guide](https://nikitabobko.github.io/AeroSpace/guide#configuring-aerospace)

#### Window間のスペースを調整する

`~/.config/aerospace/aerospace.toml`に以下の設定を追加します。

```diff toml:~/.config/aerospace/aerospace.toml
[gaps]
- inner.horizontal = 0
- inner.vertical =   0
- outer.left =       0
- outer.bottom =     0
- outer.top =        0
- outer.right =      0
+ inner.horizontal = 10
+ inner.vertical =   10
+ outer.left =       10
+ outer.bottom =     10
+ outer.top =        10
+ outer.right =      10
```

### AeroSpaceキーバインド

#### レイアウト切り替え

| キーバインド | コマンド                               | 説明                               |
| ------------ | -------------------------------------- | ---------------------------------- |
| `alt-slash`  | `layout tiles horizontal vertical`     | タイルレイアウトの切り替え         |
| `alt-period` | `layout accordion horizontal vertical` | アコーディオンレイアウトの切り替え |

#### ウィンドウフォーカスの移動

| キーバインド | コマンド      | 説明                 |
| ------------ | ------------- | -------------------- |
| `alt-h`      | `focus left`  | 左のウィンドウに移動 |
| `alt-j`      | `focus down`  | 下のウィンドウに移動 |
| `alt-k`      | `focus up`    | 上のウィンドウに移動 |
| `alt-l`      | `focus right` | 右のウィンドウに移動 |

#### ウィンドウの移動

| キーバインド  | コマンド     | 説明                 |
| ------------- | ------------ | -------------------- |
| `alt-shift-h` | `move left`  | ウィンドウを左へ移動 |
| `alt-shift-j` | `move down`  | ウィンドウを下へ移動 |
| `alt-shift-k` | `move up`    | ウィンドウを上へ移動 |
| `alt-shift-l` | `move right` | ウィンドウを右へ移動 |

#### ウィンドウのリサイズ

| キーバインド      | コマンド           | 説明         |
| ----------------- | ------------------ | ------------ |
| `alt-shift-minus` | `resize smart -50` | サイズを縮小 |
| `alt-shift-equal` | `resize smart +50` | サイズを拡大 |

#### ワークスペース操作

| キーバインド      | コマンド                       | 説明                                 |
| ----------------- | ------------------------------ | ------------------------------------ |
| `alt-[1-9]`       | `workspace [1-9]`              | ワークスペースを切り替え             |
| `alt-shift-[1-9]` | `move-node-to-workspace [1-9]` | ウィンドウを指定ワークスペースに移動 |

#### 複数モニター間の移動

| キーバインド    | コマンド                                       | 説明                               |
| --------------- | ---------------------------------------------- | ---------------------------------- |
| `alt-tab`       | `workspace-back-and-forth`                     | 前のワークスペースに戻る           |
| `alt-shift-tab` | `move-workspace-to-monitor --wrap-around next` | ワークスペースを次のモニターに移動 |

#### モード切り替え

| キーバインド    | コマンド                                       | 説明                               |
| --------------- | ---------------------------------------------- | ---------------------------------- |
| `alt-tab`       | `workspace-back-and-forth`                     | 前のワークスペースに戻る           |
| `alt-shift-tab` | `move-workspace-to-monitor --wrap-around next` | ワークスペースを次のモニターに移動 |

### 特定のアプリケーションを指定のワークスペースに表示する

特定のアプリケーションを指定のワークスペースに表示する設定もできます。
自分はこちらは設定していません。

```diff toml:~/.config/aerospace/aerospace.toml

```

### キーバインドに複数の操作を割り当てる

複数の動作を同時に行いたい場合は配列で指定します。
以下の例では、`alt-shift-1`でウィンドウをワークスペース1に移動した後、ワークスペース1に移動します。

```diff toml:~/.config/aerospace/aerospace.toml
- alt-shift-1 = 'move-node-to-workspace 1'
+ alt-shift-1 = ['move-node-to-workspace 1', 'workspace 1']
```

### AeroSpace使用時にMission Controlの画面が小さくなる問題

`^ + ↑`やトラックパッドを四本指で上にスワイプすると表示される Mission Controlで、各ウィンドウが画面が小さくなってしまいます。
こちらは設定 > デスクトップとDock > Mission Control > ウィンドウをアプリケーションごとにグループ化 を有効にすることで解決できます。

![Mission Contorol設定](/images/window-customization/mission-control.png)

## JankyBorders: アクティブウィンドウに枠をつける

アクティブウィンドウがどれだがわからなくなることはありませんか？
私はあります。
そんな時はアクティブになっているウィンドウに枠をつけるとわかりやすくなります。

@[card](https://github.com/FelixKratz/JankyBorders)

### JankyBordersのインストール

```sh
brew tap FelixKratz/formulae
brew install borders
```

### JankyBordersの設定

AeroSpaceと併用する場合は以下の設定を追加します。

```diff toml:.config/aerospace/aeospace.toml
- after-startup-command = []
+ after-startup-command = ['exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0']
```

`after-startup-command`や`after-login-command`を使用する場合は`start-at-login`を`true`に設定します。

```diff toml:.config/aerospace/aeospace.toml
# Start AeroSpace at login
+ start-at-login = false
- start-at-login = true
```

以下のコマンドで起動するとウィンドウに枠がつきます。

```sh
brew services start borders
```

設定ファイル (`~/.config/borders/bordersrc`) を用意して外観を設定することもできます。
設定ファイルを使用する場合は、AeroSpaceの起動時に指定したbordersの引数を削除します。

```diff toml:.config/aerospace/aeospace.toml
- after-startup-command = ['exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0']
+ after-startup-command = ['exec-and-forget borders']
```

```sh:.config/borders/bordersrc
#!/bin/bash

options=(
  style=round
  width=5.0
  hidpi=on
  active_color=0xc0ff00f2
  inactive_color=0xff0080ff
)

borders "${options[@]}"
```

すでにbordersを起動している場合は以下のコマンドで再起動します。

```sh
brew services restart borders
```

するとアクティブウィンドウに枠がつきます。画像では左のウィンドウがアクティブな状態です。
枠の色や太さは変更可能です。

![Jankeyborders](/images/window-customization/jankeyborders.png)

## SketchyBar: Menu barのカスタマイズ

Menu barもカスタマイズしたい場合はSketchyBarを使います。

@[card](https://github.com/FelixKratz/SketchyBar)

### 準備: MACのデフォルトMenu barを隠す

コントロールセンター > 下の方にスクロール > メニューバーを自動的に表示/非表示 の設定にて`常に`を選択
設定すると、画面上部にマウスカーソルを持っていかない限り、メニューバーが表示されなくなります。

### SketchyBarのインストール

```sh
brew tap FelixKratz/formulae
brew install sketchybar
```

設定例を実行可能なパスにコピーします。

```sh
mkdir -p ~/.config/sketchybar/plugins
cp $(brew --prefix)/share/sketchybar/examples/sketchybarrc ~/.config/sketchybar/sketchybarrc
cp -r $(brew --prefix)/share/sketchybar/examples/plugins/ ~/.config/sketchybar/plugins/
```

sketchybarを起動します。

```sh
brew services start sketchybar
```

実行すると生まれ変わったMenu barが表示されます。

![SketchyBar](/images/window-customization/sketchybar.png)

> 参照: [Setup | SketchyBar](https://felixkratz.github.io/SketchyBar/setup)

ここからは自分好みにカスタマイズしていきましょう。
他の人の設定例は[こちら](https://github.com/FelixKratz/SketchyBar/discussions/47)

私はこちらの方の設定を使わせていただいています。
@[card](https://github.com/SoichiroYamane/dotfiles)

### SoichiroYamaneさんのdotfilesを試す

dotfilesをクローンし、sketchybarの設定を追加します。
元の設定は.bakをつけてバックアップしておきます。

```sh
git clone https://github.com/SoichiroYamane/dotfiles.git
mv ~/.config/sketchybar ~/.config/sketchybar.bak
cp -r ./dotfiles/sketchybar ~/.config/sketchybar
```

インストール用のスクリプトを実行します。

```sh
cd ~/.config/sketchybar/helpers
./install.sh
```

sketchybarを再起動します。

```sh
brew services restart sketchybar
```

iconが反映されないため、iconのアップデートスクリプトを実行します。

```sh
./sketchybar/icon_updater.sh
```

SketchyBarを全体的に自分は小さくしたいため以下のような変更を加えています。

:::details sketchybar設定変更

```diff toml:.config/sketchybar/default.lua
local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
  update_freq = 1,
  icon = {
    font = {
      family = settings.font.text,
-     style = settings.font.style_map["Bold"],
-     size = 16.0,
+     style = settings.font.style_map["Semibold"],
+     size = 10.0,
    },
    color = colors.yellow,
    highlight = colors.background,
-   padding_left = 6,
-   padding_right = 2,
+   padding_left = 4,
+   padding_right = 1,
    corner_radius = 6,
    background = { image = { corner_radius = 12 } },
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
-     size = 13.0,
+     size = 10.0,
    },
    color = colors.yellow,
    highlight = colors.background,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
-   height = 34,
+   height = 30,
    corner_radius = 10,
-   border_width = 2,
+   border_width = 1,
    border_color = colors.yellow,
    image = {
      corner_radius = 0,
    },
  },
  popup = {
    background = {
      border_width = 2,
      corner_radius = 12,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 50,
  },
  padding_left = 8,
  padding_right = 8,
  -- scroll_texts = true,
})
```

```diff toml:.config/sketchybar/bar.lua
local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  -- topmost = "window",
- height = 44,
+ height = 30,
  margin = 0,
  color = 0x0000000,
  y_offset = 0,
  padding_right = 8,
  padding_left = 8,
})
```

:::

反映されると以下のようなMenu barが表示されます。

![SketchyBar](/images/window-customization/sketchybar2.png)

### AeroSpaceとSketchyBarの併用

AeroSpaceの公式ドキュメントを参考に、AeroSpaceとSketchyBarを併用する方法を紹介します。

> 参照: [AeroSpace Goodies](https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar)

#### AeroSpaceとSketchyBarの同時起動

まずはJankyBordersと同様にSketchyBarをAeroSpace起動時に一緒に起動するようにします。
SketchyBarは`sketchybar`コマンドで起動できるため以下のように追加します。

```diff toml:.config/aerospace/aeospace.toml
- after-startup-command = ['exec-and-forget borders']
+ after-startup-command = ['exec-and-forget borders', 'exec-and-forget sketchybar']
```

#### AeroSpaceのワークスペースをSketchyBarに表示

デフォルトの設定のままだとAeroSpaceのワークスペースが表示されないため、設定をする必要があります。
また、外部ディスプレイを接続するとMenu barが表示されなくなる問題があります。

![bar-hidden](/images/window-customization/bar-hidden.png)
_外部ディスプレイ接続時_
