---
title: "デスクトップは「清く・正しく・美しく」AeroSpace, JankyBorders, SketchyBar, alt-tab"
emoji: "🎄"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [JankyBorders, AeroSpace, SketchyBar]
published: true
---

:::message
この記事は[ミライトデザイン Advent Calendar 2024](https://qiita.com/advent-calendar/2024/miraito-inc)の11日目の記事です。
10日目は[FrozenVoice](https://qiita.com/FrozenVoice)さんの「[2024年に導入して満足度が高かったアイテム10選](https://qiita.com/FrozenVoice/items/2852a9333c73959f4145)」という記事でした。
:::

かなりの頻度でガジェットを購入していて驚きました😳
購入したものを見るのって楽しいですね！自分はAirPods Pro 2 が今年のMVPでした🏆

## 理想を求めて

- 思考を邪魔しない、アニメーション無しのワークスペース切り替え！
- ウィンドウの自動調整！
- 操作はキーボードで完結！
- 美しいメニューバー！
- 判別しやすいアクティブウィンドウ！
- 設定はコード管理！
- ウィンドウ切り替えはプレビュー表示！

この冬、私は「**すべて**」を手に入れたいと思う。🎅
![alt 完成系](/images/window-customization/my-dream-demo.gif)
_🎀🎄⭐️⭐️⭐️⭐️⭐️操作はやっぱキーボードっしょ⭐️⭐️⭐️⭐️⭐️🎄🎀_

![alt-tab デモ](/images/window-customization/demo-alt-tab.gif)
_⛷️ウィンドウ切り替えはプレビュー付きが好き⛷️_

![alt SketchyBar](/images/window-customization/menu-bar.png)
_🍎マークを🎄にしてクリスマス気分に_

### この記事でやること

- ウィンドウマネージャーの選定
- [AeroSpace](https://github.com/nikitabobko/AeroSpace)の設定 : ウィンドウマネージャー
- [JankyBorders](https://github.com/FelixKratz/JankyBorders)の設定 : アクティブウィンドウに枠をつける
- [SketchyBar](https://github.com/FelixKratz/SketchyBar)の設定 : メニューバーのカスタマイズ
- [alt-tab](https://github.com/lwouis/alt-tab-macos)の設定: ウィンドウ切り替えのプレビュー表示

参考になるかわからない自分のdotfilesも置いておきます。
@[card](https://github.com/mozumasu/dotfiles)

---

## デスクトップは人の思考やあり方を表す

> デスクトップの乱れは思考の乱れ

デスクトップは「清く・正しく・美しく」あるべきです。
ここでの「清く・正しく・美しく」はどんな意味なのでしょうか？

- **清く**: ウィンドウが整理されている
- **正しく**: 思考とウィンドウの挙動がシンクロしている
- **美しく**: 視界に入れたら心が踊るデザインになっている

センスは優れたデザインや美しいものをみて磨かれていくものであり、
プロダクト開発に勤しむものとして視界に映るデスクトップも美しくあるべきです。

この記事ではデスクトップ設定の一例を紹介しようと思います。

### どんな選択肢があるかを知る

まずデスクトップのカスタマイズの全体像を知ることが重要です。
どうやら世の中には「UnixPorn」という言葉があるようですね。

> 「UnixPorn」とは、 PC-UNIXのカスタマイズされたデスクトップスクリーンショットのことや、 そのスクリーンショットが沢山投稿されているredditの板のことを指しています。

@[card](https://neko-mac.blogspot.com/2022/04/unixporn.html)

ここからまずは自分デスクトップの最終形態をイメージしましょう。

## ウィンドウマネージャーの選定

### ウィンドウマネージャーとは

ウィンドウマネージャー (WM) とは、ウィンドウを管理するためのツールです。
以下のような種類があります。

- **スタック型 (SWM: Stacking Window Manager)**
  MacやWindowsはこのタイプ
  ウィンドウを重ねて表示
- **タイル型 (TWM: Tiling Window Manager)**
  ウィンドウを画面全体にタイル状に配置し、重ならないようにする
  自動で画面がリサイズされる

GitHubで探すときには「[window-manager](https://github.com/topics/window-manager)」で検索すると出てきます。

---

まずはウィンドウマネジメントツールを選定するにあたり、重要視するポイントを洗い出しましょう。
自分の場合は以下のようなポイントを重視しました。

- 全ての操作をキーボードで完結させる
- 脳のリソースを消費しすぎない
- 設定ファイルをコード管理できる
- MacのSIPを無効にしないで使用できる
- 外部ディスプレイ接続時も安定して使える
- Macでも使える

今まで [Rectangle](https://rectangleapp.com/) でウィンドウのリサイズや移動を行っていましたが、外部ディスプレイを接続するとウィンドウの位置がずれるなどの問題が発生しました。
また、それぞれのレイアウトに対応するキーバインドを覚えるのが面倒でした。

そこで代わりになりそうなウィンドウマネージャーを探して以下にまとめました。

---

### ウィンドウマネージャーの選定肢

#### Linux

タイル型

- [i3](https://i3wm.org/) ⭐️9.6k
  X11ベースのLinuxのタイル型ウィンドウマネージャー
- [sway](https://github.com/swaywm/sway) ⭐️14.8k
  X11用のi3ウィンドウマネージャーの代替として設計されたWayland上で動作するウィンドウマネージャー
  11ベースのウィンドウマネージャーよりも軽量でパフォーマンスが高い
  ウィンドウギャップや透過などの機能があるが、ぼかしや丸み、トランジッションなどの機能はない
  i3と互換性があるため、i3の設定ファイルをそのまま使える
- [Xmonad](https://github.com/xmonad/xmonad) ⭐️3.4k
  MacOSで使う場合は画面管理が大変[^1]
  Haskell で設定項目を記述する

- [Hyprland](https://github.com/hyprwm/Hyprland) ⭐️22.1k
  Waylandプロトコルに基づくウィンドウマネージャー
  見た目がよく多機能でカスタマイズ性高め[^2]
  自分がLinuxユーザーならこれを使っていたかも

  @[youtube](https://youtu.be/gOGM0uHCDFk?si=yt6YgrO3Zo7-pUZx)

#### Mac

フロート型

- [Magnet](https://magnet.crowdcafe.com/)
  導入に$4.99かかる。

- [Rectangle](https://github.com/rxhanson/Rectangle) ⭐️26.1k
  Macユーザーがよく使っている。
  自分もこれを使っていた。
  有料版の Rectangle Pro ($9.99) もある

- [Raycast](https://www.raycast.com)
  ランチャーツールだが、ウィンドウのリサイズや移動もできる。
  移動の挙動がしっくりこなくて断念。
  アプリケーション起動を特定のキーに割り当てができるため、1画面に1つ表示するような使い方をしている人に向いている

- [Loop](https://github.com/MrKai77/Loop) ⭐️7.1k
  マウスを画面端に持っていくことなくウィンドウを移動できる
  少ないキーバインドでいろんなレイアウトができるのが脳のリソースを消費しなくて良い
  単体でウィンドウに境界線をつけることができる
  設定はGUIで行う

タイル型

- [Amethyst](https://github.com/ianyh/Amethyst) ⭐️14.9
  XmonadのMac版
  設定ファイルはYAML形式で記述

- [yabai](https://github.com/koekeishiya/yabai)
  i3ライクに使えるタイル型ウィンドウマネージャー
  ワークスペースの切り替えのアニメーションを消すにはSIP無効化が必要
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) ⭐️8.7k
  独自のワークスペースがある！！切り替えアニメーションがない！！！
  起動したアプリを特定のワークスペースに自動で割り当て可能！！！
  コード管理できる！！！！
  君に決めた！！！！

AeroSpaceが自分の求めるものに近かったので試してみようと思います。
こちらの投稿者もAeroSpaceに行き着いたようです。気が合いますね。
@[card](https://www.reddit.com/r/MacOS/comments/18w0aej/aerospace_probably_the_best_window_manager_for/)

## AeroSpace

以下の動画と公式ドキュメントを参考に設定していきます。
最初に動画をみた後に公式ドキュメントを読むのがオススメです。

### AeroSpaceの設定で参考にしたもの

#### 公式ドキュメント

@[card](https://nikitabobko.github.io/AeroSpace/guide)

#### 使い方の概要

@[youtube](https://youtu.be/UOl7ErqWbrk?si=wFvtNex4sCGk_T0y)

#### 詳しい設定方法

@[youtube](https://youtu.be/-FoWClVHG5g?si=QhcJhuEkmHAHRWGI)

ただ、この動画を上げている方は最近[Raycastで管理する方法](https://youtu.be/DBifQv9AYhc?si=x-Xj3HETNmg6eXE2)に変えたとのことです。
両方試して合うものを使うのが良いと思います。

### AeroSpaceのメリット

自分が実際に使用した中で感じたメリットは以下の通りです。

- Macのワークスペースとは異なるAeroSpace独自のワークスペースを使用しており、ワークスペース切り替え時に無駄なアニメーションを挟まない
- タイル型WMなので、自動的にウィンドウのサイズを調整してくれる
- キーボードで操作が完結
- 設定ファイルでカスタマイズを行うため、コード管理できる
- 透けてるターミナルの後ろに他のウィンドウが表示されることがなくなり、ターミナルのかっこよさが際立つ (**重要**)
- `alt + 特定の文字`に特定のアプリケーションを割り当てることができるため、目的のウィンドウに素早く移動できる
- タスクごとにワークスペースを割り当てる使い方ができる

タスク間のスイッチコストが減って、作業効率が上がりました。

### AeroSpaceコマンドで起動/停止

AeroSpaceは以下のコマンドで起動/停止ができるため、使いたい時だけ使うこともできます。

```sh
# 起動
aerospace enable on
# 停止
aerospace enable off
```

:::details aerospace --help (日本語ver)

```sh
使用法: aerospace [-h|--help] [-v|--version] <サブコマンド> [<args>...]

サブコマンド:
  balance-sizes                   現在のワークスペース内のすべてのウィンドウのサイズをバランスさせる
  close                           フォーカスされたウィンドウを閉じる
  close-all-windows-but-current   フォーカスされたワークスペースで、現在のウィンドウ以外のすべてのウィンドウを閉じる
  config                          AeroSpaceの設定オプションを照会する
  debug-windows                   バグレポートを作成するためにアクセシビリティAPIのデバッグ情報を記録するインタラクティブコマンド
  enable                          一時的にウィンドウ管理を無効にする
  flatten-workspace-tree          フォーカスされたワークスペースのツリーをフラットにする
  focus                           指定された方向の最も近いウィンドウにフォーカスを設定する
  focus-back-and-forth            現在の要素と以前にフォーカスされた要素を交互に切り替える
  focus-monitor                   相対方向、順序、またはパターンでモニターにフォーカスする
  fullscreen                      フォーカスされたウィンドウのフルスクリーンモードを切り替える
  join-with                       フォーカスされたウィンドウと指定された方向の最も近いノードを共通の親コンテナの下に置く
  layout                          フォーカスされたウィンドウのレイアウトを指定されたレイアウトに変更する
  list-apps                       Dockに表示され、ユーザーインターフェースを持つ可能性のある実行中のアプリケーションのリストを表示する
  list-exec-env-vars              exec-*コマンドとコールバックが実行される環境変数をリストする
  list-monitors                   条件を満たすモニターを表示する
  list-windows                    条件を満たすウィンドウを表示する
  list-workspaces                 条件を満たすワークスペースを表示する
  macos-native-fullscreen         フォーカスされたウィンドウのmacOSフルスクリーンを切り替える
  macos-native-minimize           フォーカスされたウィンドウを最小化する
  mode                            指定されたバインディングモードをアクティブにする
  move                            フォーカスされたウィンドウを指定された方向に移動する
  move-mouse                      マウスを要求された位置に移動する
  move-node-to-monitor            相対方向、順序、またはパターンでモニターにウィンドウを移動する
  move-node-to-workspace          フォーカスされたウィンドウを指定されたワークスペースに移動する
  move-workspace-to-monitor       フォーカスされたワークスペースを次または前のモニターに移動する
  reload-config                   現在アクティブな設定をリロードする
  resize                          フォーカスされたウィンドウのサイズを変更する
  split                           フォーカスされたウィンドウを分割する
  summon-workspace                要求されたワークスペースをフォーカスされたモニターに移動する
  trigger-binding                 ユーザーが押したかのようにAeroSpaceバインディングをトリガーする
  workspace                       指定されたワークスペースにフォーカスする
  workspace-back-and-forth        フォーカスされたワークスペースと以前にフォーカスされたワークスペースを交互に切り替える
```

:::

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

#### ウィンドウフォーカスの移動

`alt` + `h/j/k/l`でウィンドウフォーカスを移動できます。

```toml:~/.config/aerospace/aerospace.toml
# See: https://nikitabobko.github.io/AeroSpace/commands#focus
alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'
```

#### ウィンドウの移動

ウィンドウの移動は`alt` + `shift` + `h/j/k/l`です。

```toml:~/.config/aerospace/aerospace.toml
# See: https://nikitabobko.github.io/AeroSpace/commands#move
alt-shift-h = 'move left'
alt-shift-j = 'move down'
alt-shift-k = 'move up'
alt-shift-l = 'move right'
```

#### レイアウト切り替え

AeroSpaceには2種類のレイアウトがあります。

- タイル: ウィンドウを重ねずに並べて表示
- アコーディオン: ウィンドウを重ねて表示

デフォルトのキーバインドは以下のように設定されています。
タイル: `alt` + `/`
アコーディオン: `alt` + `,`

```toml:~/.config/aerospace/aerospace.toml
alt-slash = 'layout tiles horizontal vertical'
alt-comma = 'layout accordion horizontal vertical'
```

#### ウィンドウのリサイズ

ウィンドウを小さく: `alt` + `shift` + `-`
ウィンドウを大きく: `alt` + `shift` + `=`

```toml:~/.config/aerospace/aerospace.toml
# See: https://nikitabobko.github.io/AeroSpace/commands#resize
alt-shift-minus = 'resize smart -50'
alt-shift-equal = 'resize smart +50'
```

自分はJIS配列なので以下のようにカスタマイズしています。

```toml:~/.config/aerospace/aerospace.toml
# alt + - でウィンドウを小さく, alt + = でウィンドウを大きく
alt-minus = 'resize smart -50'
alt-shift-minus = 'resize smart +50'
```

#### ワークスペース操作

ワークスペースを切り替えたい場合は、`alt` + `[1-9]`で切り替えることができます。
選択しているウィンドウを指定のワークスペースに移動したい場合は`alt` + `shift` + `[1-9]`で移動できます。

:::details ワークスペースの設定

```toml:~/.config/aerospace/aerospace.toml
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
```

:::

#### 複数モニター間の移動

ワークスペースを別のモニターに移動したい場合は、`alt` + `tab`で前のワークスペースに戻り、`alt` + `shift` + `tab`で次のワークスペースに移動します。

```toml:~/.config/aerospace/aerospace.toml
# See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
alt-tab = 'workspace-back-and-forth'
# See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'
```

---

### 特定のアプリケーションを指定のワークスペースに表示する

特定のアプリケーションを指定のワークスペースに表示する設定もできます。
`alt` + `S` でSlack、`alt` + `N` でNotionを表示するようにしています。

```toml:~/.config/aerospace/aerospace.toml
[[on-window-detected]]
if.app-id = 'com.tinyspeck.slackmacgap'
run = 'move-node-to-workspace S'

[[on-window-detected]]
if.app-id = 'notion.id'
run = 'move-node-to-workspace N'
```

アプリの`app-id`は以下のコマンドで取得できます。

```sh
aerospace list-apps
```

### 使用できるキー

使用できるキーは、設定ファイルに以下のように記述されています。

```toml:~/.config/aerospace/aerospace.toml
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
```

### キーバインドに複数の操作を割り当てる

複数の動作を同時に行いたい場合は配列で指定します。
以下の例では、`alt-shift-1`でウィンドウをワークスペース1に移動した後、ワークスペース1に移動します。

```diff toml:~/.config/aerospace/aerospace.toml
- alt-shift-1 = 'move-node-to-workspace 1'
+ alt-shift-1 = ['move-node-to-workspace 1', 'workspace 1']
```

### AeroSpaceの設定の反映 (サービスモード)

AeroSpaceの設定ファイルを変更した後は`alt` + `shift` + `;` → `Esc`で設定をリロードします。

```toml:~/.config/aerospace/aerospace.toml
# See: https://nikitabobko.github.io/AeroSpace/commands#mode
alt-shift-semicolon = 'mode service'

# 'service' binding mode declaration.
# See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
[mode.service.binding]
esc = ['reload-config', 'mode main']
r = ['flatten-workspace-tree', 'mode main'] # reset layout
f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
backspace = ['close-all-windows-but-current', 'mode main']
```

---

### AeroSpace使用時にMission Controlの画面が小さくなる問題

`^ + ↑`やトラックパッドを四本指で上にスワイプすると表示される Mission Controlで、各ウィンドウが画面が小さくなってしまいます。

こちらは設定 > デスクトップとDock > Mission Control > ウィンドウをアプリケーションごとにグループ化 を有効にすることで解決できます。

![Mission Contorol設定](/images/window-customization/mission-control.png)

GUIで設定するのが面倒な場合は以下のコマンドを実行します。

```sh
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer
```

---

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

自分は以下の色にしています。

```sh:.config/borders/bordersrc
#!/bin/bash

options=(
  style=round
  width=4.0
  hidpi=on
  active_color=0xc0ff00f2
  inactive_color=0xff0080ff
)

borders "${options[@]}"
```

## SketchyBar: Menu barのカスタマイズ

Menu barもカスタマイズしたい場合はSketchyBarを使います。

@[card](https://github.com/FelixKratz/SketchyBar)

### 準備: MACのデフォルトMenu barを隠す

コントロールセンター > 下の方にスクロール > メニューバーを自動的に表示/非表示 の設定にて`常に`を選択
設定すると、画面上部にマウスカーソルを持っていかない限り、メニューバーが表示されなくなります。

![alt デフォルトのメニューバーの設定](/images/window-customization/hide-default-menu-bar.png)

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

#### 足跡のアイコンを🎄に変更

以下のように変更すると足跡のアイコンが🎄に変わります。

```diff lua:~.config//sketchybar/items/widget/paw.lua
-   string = app_icons["paw"],
+   string = "🎄",
```

### AeroSpaceとSketchyBarの併用

SketchyBarにAeroSpaceのワークスペースを表示する方法は以下のページにまとまっています。

> 参照: [AeroSpace Goodies](https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar)

#### AeroSpaceとSketchyBarの同時起動

まずはJankyBordersと同様にSketchyBarをAeroSpace起動時に一緒に起動するようにします。
SketchyBarは`sketchybar`コマンドで起動できるため以下のように追加します。

```diff toml:.config/aerospace/aeospace.toml
- after-startup-command = ['exec-and-forget borders']
+ after-startup-command = ['exec-and-forget borders', 'exec-and-forget sketchybar']
```

## ウィンドウ間の切り替えをわかりやすく: alt-tab

MacOSはWindowsとは違い、ウィンドウ切り替えのプレビューで画面が表示されずにアイコンが表示されます。
Windowsを使用していたこともあり、Windowsのようにプレビューを表示できるようにしたいと思いました。

そこでalt-tabを導入しました。
@[card](https://github.com/lwouis/alt-tab-macos)

### alt-tabのお気に入りポイント

- windowの切り替えに現在のスペースにあるものが表示され、別のワークスペースで表示されているものは表示されない
- 同じアプリケーションが別ウィンドウで立ち上がっている場合、両方表示される
- 開いているウィンドウがないアプリは表示されない

ただし、AeroSpaceの現在いるワークスペース以外で起動しているアプリもalt-tabで表示されてしまうという問題があります。
alt-tabとAeroSpaceの統合は技術的に難しいようです。
@[card](https://github.com/lwouis/alt-tab-macos/issues/3773)

そのため、たまにしか開かないウィンドウをMacの別ワークスペースに分けて使うことが多いです。

---

### alt-tabのインストール

インストールは以下のコマンドで行います。

```sh
brew install --cask alt-tab
```

> 参照: [alt-tab — Homebrew Formulae](https://formulae.brew.sh/cask/alt-tab)

alt-tabを起動し、アクセシビティを許可します。
再度`alt-tab`を起動するとアプリの設定画面が表示されます。
自分は以下の設定で使用しています。

![alt alt-tab コントロール](/images/window-customization/alt-tab-control.png)
![alt alt-tab 外観](/images/window-customization/alt-tab-appearance.png)

### 余談: MACのワークスペースの切り替えアニメーションは完全にはオフにできない

ワークスペースの切り替えアニメーションはオフにはできるのですが、フェードアニメーションはオフにはできないようです。
![ディスプレイのアニメーションをオフ](/images/window-customization/disable-display-animation.png)
_ワークスペースの切り替えアニメーションをオフ_
_`設定` > `アクセシビリティ` > `ディスプレイ` > `視差効果を減らす` をオンにすることで無効化できる_

完全にアニメーション0にする手段が欲しいところ。。。

## 終わりに

[VimConf2024](https://vimconf.org/2024/)の参加者のデスクトップがカッコ良すぎて、気づいたらウィンドウのカスタマイズをしていました。
大満足のイベントでしたので、来年は[個人スポンサー](https://vimconf2024-individual-sponsor.peatix.com/)になろうと思います。

さて、明日のミライトデザインのアドカレは HADOマスター [ucan](https://qiita.com/ucan-lab) さんの「Laravel から一歩先へ。クリーンアーキテクチャによる柔軟な設計術」という記事です。
変化に強いアプリケーションを作るための設計術は必見ですね！

## 参照

[^1]:
    > XQuartz という、macOS 上で X Window System を動かすソフトウェアを使えば、Xmonad は動かせないこともないです。が、macOS 上のネイティブなアプリケーションは XQuartz 上で動作しない（参照: [Xmonad/Using xmonad on Apple OSX](https://wiki.haskell.org/Xmonad/Using_xmonad_on_Apple_OSX)）ため、画面管理が煩雑になってしまいます...
    > @[card](https://zenn.dev/defaultcf/articles/my-engineering-productivity-tool)

[^2]:
    > Hyprlandのカスタマイズはこちらの記事が参考になります。
    > @[card](https://zenn.dev/watagame/articles/hyprland-nix)
