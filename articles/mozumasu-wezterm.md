---
title: "Re: モテるターミナル (WezTerm)"
emoji: "💝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [wezterm, CLI, terminal]
published: false
---

:::message

この記事は[ミライトデザイン Advent Calendar 2025](https://qiita.com/advent-calendar/2025/miraito-inc)の17日目です。
6日目は[kakiuchi](https://qiita.com/tkek321)さんの「[開放閉鎖の原則](https://qiita.com/tkek321)」という記事でした。

:::

## はじめに完成系

以前「[モテるターミナルにカスタマイズしよう（WezTerm）](https://zenn.dev/mozumasu/articles/mozumasu-wezterm-customization)」という記事を書きました。
その後もWezTermを使い続けて、さらにカスタマイズを重ねてきたので、その知見を共有します。

![alt WezTerm after setting](/images/wezterm-customization/after_setting.png =700x)

動いている様子はこんな感じです。

![alt WezTerm after setting](/images/wezterm-customization/after_setting.gif =700x)

特にお気に入りのカスタマイズはこちらです。

- アクティブタブと非アクティブタブの色を変更
- コピーモードや設定モードの時は左下のworkspace名の文字の色を変更

## 忙しい人向け: 完成系の設定ファイル

:::details 完成系の設定ファイル

以下のように設定を分割して管理しています。

```console
~/.config/wezterm/
├── wezterm.lua          # メイン設定ファイル
├── keymaps.lua          # キーバインド設定
├── appearance.lua       # 外観設定
└── tab.lua              # タブ設定
```

:::

## WezTermの良さ

[WezTerm](https://wezfurlong.org/wezterm/) は Rust 製のターミナルエミュレータです。
@[card](https://github.com/wezterm/wezterm)

他のターミナルと比較して、WezTermの良さは以下の点にあると思います。

- **Lua言語で設定できる**: プログラミング言語で設定を書ける
- **`leader`キーがある**: Vimのような prefix キーを設定でき、キーバインドの幅が広がる
- **キーテーブルがある**: モード切り替えで同じキーに異なる機能を割り当てられる
- **繰り返し操作を一つのキーバインドにまとめられる**: 複数のアクションを一つのキーに割り当て可能
- **CLIコマンドも提供している**: スクリプトに組み込みやすく自動化が容易
- **ホットリロード**: 設定変更がすぐに反映される
- **コピーモードが使いやすい**: Vimのキーバインドでターミナル内のテキストをコピーできる

なんといってもカスタマイズ性が高いのが魅力です。
タブ1つとってもその幅や色、形状まで細かく設定できます。

## Quick Start

### インストール

Homebrewでインストールする場合は下記のコマンドを実行します。
※一部nightly限定の設定があるため、この記事ではnightly版を使用しています。

```sh
# 通常版
brew install --cask wezterm

# nightly版
brew install --cask wezterm@nightly
```

> ref: [Download - Wez's Terminal Emulator](https://wezterm.org/installation)

### 設定ファイルの準備

設定ファイルは`~/.wezterm.lua`または`~/.config/wezterm/wezterm.lua`に配置します。
ホームディレクトリではなく、設定は~/.configにまとめたい派なので、私は後者を使っています。

```bash
mkdir -p ~/.config/wezterm
touch ~/.config/wezterm/wezterm.lua
```

基本的な設定の雛形は以下の通りです。

```lua:~/.config/wezterm/wezterm.lua
-- wezterm API を組み込む
local wezterm = require("wezterm")

-- ここに設定内容を記述していく
local config = wezterm.config_builder()

-- 設定ファイルの変更を自動で読み込む
config.automatically_reload_config = true

-- 最後に、weztermに設定を戻す
return config
```

### 基本設定

私は[macSKK](https://github.com/mtgto/macSKK?tab=readme-ov-file)ユーザーなので、`Control-j` で改行されないように設定しています。

```diff lua:~/config/wezterm/wezterm.lua macSKK向け
local wezterm = require("wezterm")

 -- ここに設定内容を記述していく
local config = wezterm.config_builder()

 -- 設定ファイルの変更を自動で読み込む
config.automatically_reload_config = true

+ -- macSKK向け: Control-jで改行されないようにする設定
+ config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

return config
```

> ref: [macSKK: Q. Wezterm で C-j を押すと改行されてしまいます](https://github.com/mtgto/macSKK?tab=readme-ov-file#q-wezterm-%E3%81%A7-c-j-%E3%82%92%E6%8A%BC%E3%81%99%E3%81%A8%E6%94%B9%E8%A1%8C%E3%81%95%E3%82%8C%E3%81%A6%E3%81%97%E3%81%BE%E3%81%84%E3%81%BE%E3%81%99)

また、デフォルトの設定ではClaude Codeのプロンプト内で改行ができないため、Shift+Enterで改行できるように設定しています。

```diff lua:~/config/wezterm/wezterm.lua Claude Codeで改行
local wezterm = require("wezterm")

 -- ここに設定内容を記述していく
local config = wezterm.config_builder()

 -- 設定ファイルの変更を自動で読み込む
config.automatically_reload_config = true

 -- macSKK向け: Control-jで改行されないようにする設定
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

+ -- Claude Codeで改行できるようにする
+ config.keys = { { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") } }
return config
```

#### フォントの設定

フォントは[HackGen](https://qiita.com/tawara_/items/374f3ca0a386fab8b305)が好きなため、このフォントをインストールして設定していきます。

```sh
# フォントをインストール
brew install font-hackgen
brew install font-hackgen-nerd
```

> - [yuru7/HackGen: Hack と源柔ゴシックを合成したプログラミングフォント 白源 (はくげん／HackGen)](https://github.com/yuru7/HackGen)

```diff lua:~/config/wezterm/wezterm.lua フォントを設定
local wezterm = require("wezterm")

 -- ここに設定内容を記述していく
local config = wezterm.config_builder()

 -- 設定ファイルの変更を自動で読み込む
config.automatically_reload_config = true

 -- macSKK向け: Control-jで改行されないようにする設定
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

 -- Claude Codeで改行できるようにする
config.keys = { { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") } }

+ -- font
+ config.font_size = 14.0
+ config.font = wezterm.font("HackGen Console NF")

return config
```

変更前と変更後はこんな感じ。

#### 背景の透過とぼかし

ターミナルといえばスケスケですよね?
ターミナルの背景を透過させ、ぼかしを入れる設定を追加します。

```diff lua:~/config/wezterm/wezterm.lua 透過度とぼかし
local wezterm = require("wezterm")

 -- ここに設定内容を記述していく
local config = wezterm.config_builder()

 -- 設定ファイルの変更を自動で読み込む
config.automatically_reload_config = true

 -- macSKK向け: Control-jで改行されないようにする設定
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

 -- Claude Codeで改行できるようにする
config.keys = { { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") } }

 -- font
config.font_size = 14.0
config.font = wezterm.font("HackGen Console NF")

+ -- 背景の透過度とぼかし
+ config.window_background_opacity = 0.7
+ config.macos_window_background_blur = 13

return config
```

> mac: [macos_window_background_blur](https://wezfurlong.org/wezterm/config/lua/config/macos_window_background_blur.html)
> windows: [win32_system_backdrop](https://wezfurlong.org/wezterm/config/lua/config/win32_system_backdrop.html)

やっぱりスケスケに限る~~~!

### デフォルトのキーバインドを設定ファイルに出力

WezTermのキーバインドは `wezterm show-keys --lua` で確認できます。
デフォルトののキーバインドを変更して自分好みにカスタマイズしていくのがオススメです。

```sh
# デフォルトの設定をファイルに出力
wezterm show-keys --lua > ~/.config/wezterm/keymaps.lua
```

すると、以下のようなファイルが生成されます。

```lua :~/.config/wezterm/keymaps.lua
local wezterm = require("wezterm")
local act = wezterm.action

return {
  keys = {
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    -- いろんなキーバインドが続く...
  },

  key_tables = {
    copy_mode = {
      { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      -- コピーモードのキーバインドが続く...
    },

    search_mode = {
      { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
      -- 検索モードのキーバインドが続く...
    },
  },
}
```

:::details wezterm show-keys --lua で作成されたkeymaps.luaの全体

```lua :デフォルトのkeymaps.lua
local wezterm = require("wezterm")
local act = wezterm.action

return {
  keys = {
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
    { key = "!", mods = "CTRL", action = act.ActivateTab(0) },
    { key = "!", mods = "SHIFT|CTRL", action = act.ActivateTab(0) },
    { key = '"', mods = "ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = '"', mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "#", mods = "CTRL", action = act.ActivateTab(2) },
    { key = "#", mods = "SHIFT|CTRL", action = act.ActivateTab(2) },
    { key = "$", mods = "CTRL", action = act.ActivateTab(3) },
    { key = "$", mods = "SHIFT|CTRL", action = act.ActivateTab(3) },
    { key = "%", mods = "CTRL", action = act.ActivateTab(4) },
    { key = "%", mods = "SHIFT|CTRL", action = act.ActivateTab(4) },
    { key = "%", mods = "ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "%", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "&", mods = "CTRL", action = act.ActivateTab(6) },
    { key = "&", mods = "SHIFT|CTRL", action = act.ActivateTab(6) },
    { key = "'", mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "(", mods = "CTRL", action = act.ActivateTab(-1) },
    { key = "(", mods = "SHIFT|CTRL", action = act.ActivateTab(-1) },
    { key = ")", mods = "CTRL", action = act.ResetFontSize },
    { key = ")", mods = "SHIFT|CTRL", action = act.ResetFontSize },
    { key = "*", mods = "CTRL", action = act.ActivateTab(7) },
    { key = "*", mods = "SHIFT|CTRL", action = act.ActivateTab(7) },
    { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "-", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
    { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = act.ResetFontSize },
    { key = "0", mods = "SHIFT|CTRL", action = act.ResetFontSize },
    { key = "0", mods = "SUPER", action = act.ResetFontSize },
    { key = "1", mods = "SHIFT|CTRL", action = act.ActivateTab(0) },
    { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
    { key = "2", mods = "SHIFT|CTRL", action = act.ActivateTab(1) },
    { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
    { key = "3", mods = "SHIFT|CTRL", action = act.ActivateTab(2) },
    { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
    { key = "4", mods = "SHIFT|CTRL", action = act.ActivateTab(3) },
    { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
    { key = "5", mods = "SHIFT|CTRL", action = act.ActivateTab(4) },
    { key = "5", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
    { key = "6", mods = "SHIFT|CTRL", action = act.ActivateTab(5) },
    { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
    { key = "7", mods = "SHIFT|CTRL", action = act.ActivateTab(6) },
    { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
    { key = "8", mods = "SHIFT|CTRL", action = act.ActivateTab(7) },
    { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
    { key = "9", mods = "SHIFT|CTRL", action = act.ActivateTab(-1) },
    { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },
    { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "=", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
    { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
    { key = "@", mods = "CTRL", action = act.ActivateTab(1) },
    { key = "@", mods = "SHIFT|CTRL", action = act.ActivateTab(1) },
    { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
    { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "F", mods = "CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "F", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "H", mods = "CTRL", action = act.HideApplication },
    { key = "H", mods = "SHIFT|CTRL", action = act.HideApplication },
    { key = "K", mods = "CTRL", action = act.ClearScrollback("ScrollbackOnly") },
    { key = "K", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
    { key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
    { key = "L", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    { key = "M", mods = "CTRL", action = act.Hide },
    { key = "M", mods = "SHIFT|CTRL", action = act.Hide },
    { key = "N", mods = "CTRL", action = act.SpawnWindow },
    { key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
    { key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
    { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "Q", mods = "CTRL", action = act.QuitApplication },
    { key = "Q", mods = "SHIFT|CTRL", action = act.QuitApplication },
    { key = "R", mods = "CTRL", action = act.ReloadConfiguration },
    { key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    { key = "T", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    {
      key = "U",
      mods = "CTRL",
      action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },
    {
      key = "U",
      mods = "SHIFT|CTRL",
      action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },
    { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
    { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
    { key = "W", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "X", mods = "CTRL", action = act.ActivateCopyMode },
    { key = "X", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
    { key = "Z", mods = "CTRL", action = act.TogglePaneZoomState },
    { key = "Z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
    { key = "[", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
    { key = "^", mods = "CTRL", action = act.ActivateTab(5) },
    { key = "^", mods = "SHIFT|CTRL", action = act.ActivateTab(5) },
    { key = "_", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
    { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    { key = "f", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "h", mods = "SHIFT|CTRL", action = act.HideApplication },
    { key = "h", mods = "SUPER", action = act.HideApplication },
    { key = "k", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
    { key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
    { key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    { key = "m", mods = "SHIFT|CTRL", action = act.Hide },
    { key = "m", mods = "SUPER", action = act.Hide },
    { key = "n", mods = "SHIFT|CTRL", action = act.SpawnWindow },
    { key = "n", mods = "SUPER", action = act.SpawnWindow },
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "q", mods = "SHIFT|CTRL", action = act.QuitApplication },
    { key = "q", mods = "SUPER", action = act.QuitApplication },
    { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    { key = "r", mods = "SUPER", action = act.ReloadConfiguration },
    { key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
    {
      key = "u",
      mods = "SHIFT|CTRL",
      action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },
    { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
    { key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "x", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
    { key = "z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
    { key = "{", mods = "SUPER", action = act.ActivateTabRelative(-1) },
    { key = "{", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
    { key = "}", mods = "SUPER", action = act.ActivateTabRelative(1) },
    { key = "}", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
    { key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },
    { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
    { key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
    { key = "PageUp", mods = "SHIFT|CTRL", action = act.MoveTabRelative(-1) },
    { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
    { key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "PageDown", mods = "SHIFT|CTRL", action = act.MoveTabRelative(1) },
    { key = "LeftArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Left") },
    { key = "LeftArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "RightArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Right") },
    { key = "RightArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "UpArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
    { key = "UpArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "DownArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },
    { key = "DownArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
    { key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
  },

  key_tables = {
    copy_mode = {
      { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
      { key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
      { key = "Escape", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
      { key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "c", mods = "CTRL", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      { key = "g", mods = "CTRL", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "q", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      {
        key = "y",
        mods = "NONE",
        action = act.Multiple({
          { CopyTo = "ClipboardAndPrimarySelection" },
          { Multiple = { "ScrollToBottom", { CopyMode = "Close" } } },
        }),
      },
      { key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
      { key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
      { key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
      { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
      { key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
    },

    search_mode = {
      { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
      { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
      { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
      { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
      { key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
      { key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
      { key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
      { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
    },
  },
}
```

:::

しかし、このままだと設定ファイルが読みこまれません。
次の章ではファイルを分割して、メインの設定ファイルから読み込む方法を解説します。

## 設定ファイルの分割

設定をカスタマイズしていくと、`wezterm.lua`がどんどん長くなってきます。
WezTermではLuaの**モジュール**という仕組みを使って、設定ファイルを複数に分割できます。

:::message

**Luaのモジュールとは？**
モジュールとは、関数や変数をまとめた再利用可能なファイルのことです。
`require 'ファイル名'` で別ファイルの内容を読み込むことができます。

:::

手順は以下の通りです。

1. 分割したい設定ごとにファイルを作成
2. メインの設定ファイルでモジュールを読み込む

さっそく、先ほど出力した `keymaps.lua` をモジュールとして使えるように修正していきましょう。
`1. 分割したい設定ごとにファイルを作成`はできているため、`2. メインの設定ファイルでモジュールを読み込む`を行います。

> ref: [Making your own Lua Modules - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/files.html#making-your-own-lua-modules)

### 1. モジュール化する

```lua :~/.config/wezterm/keymaps.lua
# モジュール化前
local wezterm = require("wezterm")
local act = wezterm.action

return {
  keys = {
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    -- いろんなキーバインドが続く...
  },

  key_tables = {
    copy_mode = {
      { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      -- コピーモードのキーバインドが続く...
    },

    search_mode = {
      { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
      -- 検索モードのキーバインドが続く...
    },
  },
}
```

```diff lua:~/.config/wezterm/keymaps.lua
# モジュール化後
local wezterm = require("wezterm")
local act = wezterm.action

+ -- 他のファイルに公開するためのテーブル（入れ物）を作る
+ local module = {}

- return {
-   keys = {
-     { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
-     { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
-     -- いろんなキーバインドが続く...
-   },
- 
-   key_tables = {
-     copy_mode = {
-       { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
-       -- コピーモードのキーバインドが続く...
-     },
- 
-     search_mode = {
-       { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
-       -- 検索モードのキーバインドが続く...
-     },
-   },
- }
+ local keys = {
+     { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
+     { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
+     -- いろんなキーバインドが続く...
+ }
+ 
+ local key_tables = {
+   copy_mode = {
+     { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
+     -- コピーモードのキーバインドが続く...
+   },
+   search_mode = {
+     { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
+     -- 検索モードのキーバインドが続く...
+   },
+ }

+ -- この関数は module テーブルに入れるので外部から使える
+ -- config にキーバインドを適用する関数
+ function module.apply_to_config(config)
+   config.keys = keys
+   config.key_tables = key_tables
+ end

+ -- module テーブルを返すことで、外部から使えるようになる
+ return module
```

### 2. メインの設定ファイルでモジュールを読み込む

`~/.config/wezterm/wezterm.lua` で作成したモジュールを使います。
`require 'keymaps'` で `keymaps.lua` の内容を読み込み、`module` テーブルが返されます。
これを `keymap` 変数に格納することで、`keymaps.apply_to_config(config)` のように関数を呼び出せます。

```diff lua:~/config/wezterm/wezterm.lua
local wezterm = require("wezterm")

 -- ここに設定内容を記述していく
local config = wezterm.config_builder()

 -- 設定ファイルの変更を自動で読み込む
config.automatically_reload_config = true

 -- macSKK向け: Control-jで改行されないようにする設定
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

 -- Claude Codeで改行できるようにする
config.keys = { { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") } }

 -- font
config.font_size = 14.0
config.font = wezterm.font("HackGen Console NF")

 -- 背景の透過度とぼかし
config.window_background_opacity = 0.7
config.macos_window_background_blur = 13

+ -- 自作モジュールの読み込み (.luaは省略可能)
+ local keymaps = require 'keymaps'

+ -- モジュール内の関数を呼び出して設定を適用
+ keymaps.apply_to_config(config)

return config
```

自作モジュールの読み込みと設定の適用はまとめて書くこともできます。

```lua
-- モジュールを読み込んで設定を適用
require('keymaps').apply_to_config(config)
```

:::details ここまでの設定ファイルまとめ

```lua :~/.config/wezterm/wezterm.lua
```

```lua :~/.config/wezterm/keymaps.lua
```
:::

## キーバインドの設定

### leaderキーの設定

`leader`キーはVimの`<Leader>`のようなもので、キーバインドのprefixとして使います。
デフォルトは`Control+a`ですが、Emacsの行頭移動と被るため`Control+q`に変更しています。

```lua
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }
```

### キーテーブル

キーテーブルを使うと、特定のモードでのみ有効なキーバインドを定義できます。

```lua
-- キーテーブルのアクティブ状態をステータスバーに表示
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

config.keys = {
  -- ... 上記のキーバインド ...

  -- Paneサイズ調整モードに入る
  { key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
}

config.key_tables = {
  -- Paneサイズ調整モード (leader + s)
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "Enter", action = "PopKeyTable" },  -- モード終了
  },
}
```

## 外観のカスタマイズ

### タブバーの設定

タブバーをすっきりさせる設定です。

```lua
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- タブの閉じるボタンを非表示 (nightlyのみ)
config.show_close_tab_button_in_tabs = false

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブ同士の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
```

### タブの形をカスタマイズ

タブの形を変更し、アクティブなタブに色をつけます。

```lua
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)
```

## おわりに

今月の初めに、[爆速CLI入門 ~最初に知りたかったTips~](https://zenn.dev/mozumasu/articles/mozumasu-cli-beginner)や[ターミナルでメモ管理 (Neovim, nb, zeno.zsh)](https://zenn.dev/mozumasu/articles/mozumasu-cli-info-management)という記事を書きました。
本記事と合わせて、より快適なCLIライフを楽しんでいただければ幸いです。
