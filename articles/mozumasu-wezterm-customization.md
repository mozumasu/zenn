---
title: "モテるターミナルにカスタマイズしよう（WezTerm）"
emoji: "💘"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [wezterm, CLI, terminal]
published: true
---

## はじめに完成系を晒す

ターミナルがかっこいいとモテるらしいというのをどこかの記事で読んだので、かっこよくターミナルをカスタマイズしてみました。
意外と簡単にできるので身構えずにコーヒーでも飲みながらやってみてください。☕️

完成系はこんな感じです。スケスケ&ぼかしが入っていていい感じですね！

![alt WezTerm after setting](/images/wezterm-customization/after_setting.png =700x)
現在有効になっているタブが黄色くなります。

![alt WezTerm after setting](/images/wezterm-customization/after_setting.gif =700x)

ついでにNeovimの画面も晒しておきます。
![alt WezTerm after setting](/images/wezterm-customization/after_setting_2.png =700x)

使用しているターミナルは[WezTerm](https://wezfurlong.org/wezterm/)です。
WezTermの特徴は以下の通りです。

- Rust製でとにかく早い
- 軽量
- カスタマイズ性高め
- 設定ファイルはNeovimと同じLua言語
- tmuxのような画面分割ができる
- 豊富なドキュメントがある
- **コピーモードが使いやすい！！！**

`Leader`キー(自分はControl+Q) + `[`でコピーモードに入り、Vimのキーバインドで操作してコピーすることができます。
![alt WezTerm after setting](/images/wezterm-customization/copy_mode.gif =700x)

コピーモードのキーバインドはデフォルトでは`Control+Shift+X`に割り当てられています。

他にも色々良さがあるので、詳しくは公式ドキュメントを参照していただければと思います。
カスタマイズをたくさんしたい人にはオススメのターミナルです。

### 忙しい人向け：完成系の設定ファイル

読むのが面倒な人向けに完成系の設定ファイルを晒しておきます。

:::details WezTerm設定ファイル

```lua:~/.config/wezterm/wezterm.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブの形をカスタマイズ
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

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config

```

```lua:~/.config/wezterm/keybinds.lua
local wezterm = require("wezterm")
local act = wezterm.action

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

return {
  keys = {
    {
      -- workspaceの切り替え
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
    },
    {
      --workspaceの名前変更
      key = "$",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "(wezterm) Set workspace title:",
        action = wezterm.action_callback(function(win, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      }),
    },
    {
      key = "W",
      mods = "LEADER|SHIFT",
      action = act.PromptInputLine({
        description = "(wezterm) Create new workspace:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },
    -- コマンドパレット表示
    { key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
    -- Tab移動
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    -- Tab入れ替え
    { key = "{", mods = "LEADER", action = act({ MoveTabRelative = -1 }) },
    -- Tab新規作成
    { key = "t", mods = "SUPER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    -- Tabを閉じる
    { key = "w", mods = "SUPER", action = act({ CloseCurrentTab = { confirm = true } }) },
    { key = "}", mods = "LEADER", action = act({ MoveTabRelative = 1 }) },

    -- 画面フルスクリーン切り替え
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

    -- コピーモード
    -- { key = 'X', mods = 'LEADER', action = act.ActivateKeyTable{ name = 'copy_mode', one_shot =false }, },
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    -- コピー
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    -- 貼り付け
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

    -- Pane作成 leader + r or d
    { key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Paneを閉じる leader + x
    { key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
    -- Pane移動 leader + hlkj
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    -- Pane選択
    { key = "[", mods = "CTRL|SHIFT", action = act.PaneSelect },
    -- 選択中のPaneのみ表示
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

    -- フォントサイズ切替
    { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    -- フォントサイズのリセット
    { key = "0", mods = "CTRL", action = act.ResetFontSize },

    -- タブ切替 Cmd + 数字
    { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
    { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
    { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
    { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
    { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
    { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
    { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
    { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
    { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },

    -- コマンドパレット
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- 設定再読み込み
    { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    -- キーテーブル用
    { key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    {
      key = "a",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
    },
  },
  -- キーテーブル
  -- https://wezfurlong.org/wezterm/config/key-tables.html
  key_tables = {
    -- Paneサイズ調整 leader + s
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape
      { key = "Enter", action = "PopKeyTable" },
    },
    activate_pane = {
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
    -- copyモード leader + [
    copy_mode = {
      -- 移動
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      -- 最初と最後に移動
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      -- 左端に移動
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      --
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      -- 単語ごと移動
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      -- ジャンプ機能 t f
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      -- 一番下へ
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      -- 一番上へ
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      -- viweport
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      -- スクロール
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      -- 範囲選択モード
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      -- コピー
      { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },

      -- コピーモードを終了
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    },
  },
}

```

:::

## WezTermのインストール

Homebrewでインストールする場合は下記のコマンドを実行します。
※一部nightly限定の設定があるため、この記事ではnightly版を使用しています。

```bash
# 通常版
brew install --cask wezterm

# nightly版
brew install --cask wezterm@nightly

```

> Homebrew: <https://formulae.brew.sh/cask/wezterm>
> WezTerm公式: <https://wezfurlong.org/wezterm/installation>

WezTermを立ち上げると下記のような画面が表示されます。
![alt WezTerm before setting](/images/wezterm-customization/before_setting.png)
※画像のターミナルは[starship](https://starship.rs/)を導入しているため、プロンプトの部分はすでにカスタマイズされています。
starshipのカスタマイズ方法は記憶の彼方にあるのでとりあえずコードだけ晒しておきます。
:::details starshipの設定

```toml:~/.config/starship.toml
format = """
$directory\
[ ](fg:#88C0D0 bg:#1d2230)\
$git_branch\
$git_status\
[ ](fg:#1d2230)\
\n$character
"""

right_format = """
$cmd_duration\
$username\
✨
$time
"""

# コマンドラインに1行分のスペースを入れる
add_newline = true

[username]
style_user = "white bold"
style_root = "black bold"
format = "user: [$user]($style) "
disabled = false


# left_promptとright_promptの間を何で埋めるか設定
[fill]
symbol = ' '

[directory]
style = "fg:#2E3440 bg:#88C0D0 bold"
# format = "[ $path ]($style)"
truncation_length = 10
truncate_to_repo = false
truncation_symbol = "…/"
# truncation_symbol = ' ' # nf-fa-folder_open
# truncate_to_repo = false
# style = 'fg:#7aa2f7 bg:#1a1b26'
read_only = ' 󰌾 ' # nf-md-lock
read_only_style = 'fg:#f7768e bg:#1a1b26'
format = '[ $path ]($style)[$read_only]($read_only_style)'


[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[aws]
disabled = true
[gcloud]
disabled = true

[git_branch]
symbol = ""
style = "bg:#1d2230"
format = '[[ $symbol $branch ](fg:#769ff0 bg:#1d2230)]($style)'

[git_status]
style = "bg:#1d2230"
format = '[[($all_status$ahead_behind )](fg:#769ff0 bg:#1d2230)]($style)'

[cmd_duration]
min_time = 1
style = 'fg:#e0af68'
format = "[$duration]($style)" # nf-pl-right_soft_divider, nf-mdi-clock

[time]
disabled = false
time_format = "%R" # Hour:Minute Format
# style = "bg:#1d2230"
format = '[[   $time ](fg:#a0a9cb)]($style)'

[character]
vimcmd_symbol = '[V](bold green) '

```

:::

## 設定ファイルの用意

設定ファイルは`~/.wezterm.lua`に配置します。
uiの設定とキーバインドを別のファイルに分けて管理する派の方は`~/.config/wezterm/wezterm.lua`と`~/.config/wezterm/keybind.lua`で分けるのもありです。
この記事では後者で設定していきます。

このカスタマイズを機に設定ファイルをGitHubで管理したくなった場合は下記の記事が参考にしてください。
@[card](https://qiita.com/yutkat/items/c6c7584d9795799ee164)

まずは、`~/.config/wezterm`ディレクトリを作成し、その中に`wezterm.lua`を作成します。

```bash
mkdir -p ~/.config/wezterm
touch ~/.config/wezterm/wezterm.lua
```

続いて、設定ファイルに下記のような雛形を記述します。

```lua:~/.config/wezterm/wezterm.lua
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

> [Configuration - Wez's Terminal Emulator](https://arc.net/l/quote/upsihqso)

## window全体の設定

### fontサイズの変更

まずは作業がしやすいようにフォントサイズを変更しましょう。
また、カラースキームは設定しないため削除します。
(Luaのコメントアウトがdiffで-表示されてしまうためコメントアウトも削除しています。)

```diff lua:~/.config/wezterm/wezterm.lua
- -- Pull in the wezterm API
local wezterm = require 'wezterm'
-
- -- This will hold the configuration.
local config = wezterm.config_builder()

config.automatically_reload_config = true
+ config.font_size = 12.0

- -- This is where you actually apply your config choices
-
- -- For example, changing the color scheme:
- config.color_scheme = 'AdventureTime'
-
- -- and finally, return the configuration to wezterm
return config
```

> [font_size - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/font_size.html?h=font_size)

### IMEで日本語を入力をできるようにする

IMEで日本語を入力するには下記の設定が必要なので追加します。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
+ config.use_ime = true

return config
```

> [use_ime - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/use_ime.html?h=use_ime)

### 背景の透過

続いては己の気分をブチ上げるための設定をします。
そう、背景の透過です。
人類皆一度はスケスケのターミナルに憧れを抱くものです。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
+ config.window_background_opacity = 0.85

return config
```

> [Colors & Appearance - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/appearance.html?h=window_background_opacity#window-background-opacity)

値は0~1の間で設定します。0に近いほどスケスケになります。
0.85だと画像のような透け感になります。

![alt opacity 0.85](/images/wezterm-customization/opacity_setting.png =700x)

なんだかちょっとできる人の雰囲気がでてきましたね。

### ぼかしを追加

とはいえ、スケスケすぎると文字が見づらいというもの。
ぼかしを入れてスケスケと視認性を両立し、「こいつ、、、デキる！」感を演出していきましょう。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
+ config.macos_window_background_blur = 20

return config
```

> mac: [macos_window_background_blur - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/macos_window_background_blur.html?h=macos_window_background_blur)
> windows: [win32_system_backdrop - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/win32_system_backdrop.html)

![alt blur 20](/images/wezterm-customization/blur_setting.png =700x)

＼( 'ω')／ウオオオオオアアアーーーーッ！！！良いｯ！！！
ここまでくるともう、あなたはデキる人です。
私が保証しましょう。

## タブの設定

先のターミナルを見てあなたはきっとこう思ったはずです。

「なんかタブがしっくりこないなぁ、、、」

そんなあなたに朗報です。
何とこのタブ、カスタマイズできます！！！！そう！WezTermならね！！！

### タイトルバーの削除

まずはタブバーの上部のタイトルバーを消しましょう。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
+ config.window_decorations = "RESIZE"

return config
```

> [window_decorations - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/window_decorations.html)

![alt window_decorations](/images/wezterm-customization/window_decorations_setting.png =700x)

タイトルバーが消えてちょっとすっきりしました。

### タブバーを非表示

タブを使用しない場合は下記の設定で非表示にすることができます。
私はタブのヘビーユーザーなのでこちらは設定していません。

```lua:~/.config/wezterm/wezterm.lua
config.show_tabs_in_tab_bar = false
```

### タブが一つしかない時に非表示

タブが一つしかない時はタブバー要らんな、、、という場合は下記の設定で非表示にすることができます。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
+ config.hide_tab_bar_if_only_one_tab = true

return config
```

### タブバーを透明にする

タイトルバーが消え去り、残すところはタブバーのみです。
こいつの色も透明にしてやりましょう。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

+ config.window_frame = {
+   inactive_titlebar_bg = "none",
+   active_titlebar_bg = "none",
+ }

return config
```

> [window_frame - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/window_frame.html?h=window_frame)

![alt window_frame](/images/wezterm-customization/window_frame_setting.png =700x)
透明になりましたね！！

~~`config.use_fancy_tab_bar = false`を設定すると下記の画像のようになり、タブバーは透過ができなくなるため注意してください。~~
~~カクカクしたタブをとるか、透過したタブをとるかはあなた次第です。~~

![alt use_fancy_tab_bar](/images/wezterm-customization/use_fancy_tab_bar_setting.png =700x)

:::message
2025/04追記: use_fancy_tab_bar= falseでも透過できました!
カクカクのタブでも透過できるのでよりスマートな見た目にすることもできます!

それぞれ、タブバーの透過の方法が異ります。

**use_fancy_tab_bar = trueの場合**

```lua
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
```

**use_fancy_tab_bar = falseの場合**

```lua
config.colors = {
  tab_bar = {
    background = "none",
  },
}
```

![alt use_fancy_tab_bar_false](/images/wezterm-customization/use_fancy_tab_bar_false.png =700x)

:::

> [use_fancy_tab_bar - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/use_fancy_tab_bar.html)

### タブバーを背景と同じ色にする

透明にしたもののこれはこれで何だが違和感があります。
この違和感を消すべく、タブバーを背景と同じ色にしましょう。
デフォルトの背景が黒色なので、colorsには`#000000`を指定します。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

 config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }
+ config.window_background_gradient = {
+   colors = { "#000000" },
+ }

return config
```

> [window_background_gradient - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/window_background_gradient.html?h=window_background_gradient)

![alt window_background_gradient](/images/wezterm-customization/window_background_gradient_setting.png =700x)
タブバーが背景と同じ色になりました！！見栄えがいいね！！

`window_background_gradient`は背景にグラデーションをつけることもできます。
下記は公式ドキュメントの例です。
![alt radial-gradient](https://wezfurlong.org/wezterm/screenshots/linear-gradient.png)
_参照: [window_background_gradient - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/window_background_gradient.html?h=window_background_gradient)_

### タブバーの+を消す

タブを追加する時は`Cmd+T`を使うので、タブバーの+はなくても困ることがありません。
非表示にてスッキリしましょう。視界から入る情報は必要なもののみにして集中力をマシマシにしましょう。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

 config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }
 config.window_background_gradient = {
   colors = { "#000000" },
 }
+ config.show_new_tab_button_in_tab_bar = false

return config
```

> [show_new_tab_button_in_tab_bar - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/show_new_tab_button_in_tab_bar.html?h=show_new_tab_button_in_tab_bar)

設定前
![alt close button available](/images/wezterm-customization/show_new_tab_button_in_tab_bar_before_setting.png =700x)
設定後
![alt close tab button unavailable](/images/wezterm-customization/show_new_tab_button_in_tab_bar_after_setting.png =700x)

### タブの閉じるボタンを非表示

タブを削除する時は`Cmd+W`を使うので、タブを閉じるボタンも非表示にしちゃいましょう。
こちらの設定はnightlyでのみ使用可能です。(2024/9/13現在)

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

 config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }
 config.window_background_gradient = {
   colors = { "#000000" },
 }
config.show_new_tab_button_in_tab_bar = false
+ config.show_close_tab_button_in_tabs = false

return config
```

> [show_close_tab_button_in_tabs - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/show_close_tab_button_in_tabs.html)

設定前
![alt close button available](/images/wezterm-customization/show_close_tab_button_in_tabs_before_setting.png =700x)
設定後
![alt close tab button unavailable](/images/wezterm-customization/show_close_tab_button_in_tabs_after_setting.png =700x)

### タブ同士の境界線を非表示

タブの形を変更したいため、タブ同士の不要な境界線も非表示にしていきます。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

 config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }
 config.window_background_gradient = {
   colors = { "#000000" },
 }
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
+ config.colors = {
+   tab_bar = {
+     inactive_tab_edge = "none",
+   },
+ }

return config
```

> [Colors & Appearance - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/appearance.html?h=inactive_tab_edge#dynamic-color-escape-sequences)

設定前
![alt before inactive_tab_edge](/images/wezterm-customization/inactive_tab_edge_before_setting.png =700x)

設定後
![alt after inactive_tab_edge](/images/wezterm-customization/inactive_tab_edge_setting.png =700x)

ちょっとした間違い探しみたいですね。

### アクティブタブに色をつける

アクティブの状態になっているタブの色も設定できます。
通常時のタブの色と、アクティブ時のタブの色を定義しています。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

 config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }
 config.window_background_gradient = {
   colors = { "#000000" },
 }
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
+ wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
+   local background = "#5c6d74"
+   local foreground = "#FFFFFF"
+
+   if tab.is_active then
+     background = "#ae8b2d"
+     foreground = "#FFFFFF"
+   end
+
+   local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
+
+   return {
+     { Background = { Color = background } },
+     { Foreground = { Color = foreground } },
+     { Text = title },
+   }
+ end)

return config
```

> [format-tab-title - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html?h=title)

無事に色がつきましたね！
![alt format-tab-title](/images/wezterm-customization/format-tab-title_setting.png =700x)

### タブの形を変更

タブの形も変更しちゃいましょう。

```diff lua:~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

 config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }
 config.window_background_gradient = {
   colors = { "#000000" },
 }
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
+ local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
+ local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
+   local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
+   local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
+     { Background = { Color = edge_background } },
+     { Foreground = { Color = edge_foreground } },
+     { Text = SOLID_LEFT_ARROW },
     { Background = { Color = background } },
     { Foreground = { Color = foreground } },
    { Text = title },
+     { Background = { Color = edge_background } },
+     { Foreground = { Color = edge_foreground } },
+     { Text = SOLID_RIGHT_ARROW },
  }
end)

return config
```

> [wezterm.nerdfonts - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html?h=nerd)

\\\\⭐️⭐️完成⭐️⭐️//

![alt WezTerm after setting](/images/wezterm-customization/after_setting.png =700x)

公式ドキュメントには他にもたくさんの設定があります。
ぜひ自分好みにカスタマイズしてみてください。

## キーバインドの設定

見た目が整ったところで、操作性も整えていきましょう。

### キーバインド設定ファイルを作成

WezTermのキーバインドはたくさんあります。
下記のコマンドを入力すると、現在の設定が表示されます。

```shell
wezterm show-keys
```

...結構ありますね。この量を全て書いていくのは大変なので現在の設定をファイルに流し込んでからカスタマイズしていきましょう。

```shell
cd ~/.config/wezterm
wezterm show-keys --lua > keybinds.lua
```

keybinds.luaを読み込めるようにwezterm.luaに下記を追加しましょう。

```lua:~/.config/wezterm/wezterm.lua
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
```

デフォルトのキーバインドを無効にする場合は下記の設定を追加します。

```lua:~/.config/wezterm/wezterm.lua
config.disable_default_key_bindings = true
```

### leaderキーの設定

`leader`キーとはprefixキーのことで、Vimでいうところの`<Leader>`にあたります。
つまり、「これからショートカットキーを打つモードに入るぜ！」という合図をするのようなものです。
デフォルトでは`Control`+`a`に設定されていますが、このキーバインドはEmacsの行頭へ移動するキーバインドと被るため私は`Control`+`q`に変更しています。

```lua:~/.config/wezterm/wezterm.lua
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }
```

> [Key Binding - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/keys.html#voidsymbol)

自分が設定しているキーバインドも置いておきます。

:::details keybinds.lua

```lua:~/.config/wezterm/keybinds.lua
local wezterm = require("wezterm")
local act = wezterm.action

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

return {
  keys = {
    {
      -- workspaceの切り替え
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
    },
    {
      --workspaceの名前変更
      key = "$",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "(wezterm) Set workspace title:",
        action = wezterm.action_callback(function(win, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      }),
    },
    {
      key = "W",
      mods = "LEADER|SHIFT",
      action = act.PromptInputLine({
        description = "(wezterm) Create new workspace:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },
    -- コマンドパレット表示
    { key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
    -- Tab移動
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    -- Tab入れ替え
    { key = "{", mods = "LEADER", action = act({ MoveTabRelative = -1 }) },
    -- Tab新規作成
    { key = "t", mods = "SUPER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    -- Tabを閉じる
    { key = "w", mods = "SUPER", action = act({ CloseCurrentTab = { confirm = true } }) },
    { key = "}", mods = "LEADER", action = act({ MoveTabRelative = 1 }) },

    -- 画面フルスクリーン切り替え
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

    -- コピーモード
    -- { key = 'X', mods = 'LEADER', action = act.ActivateKeyTable{ name = 'copy_mode', one_shot =false }, },
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    -- コピー
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    -- 貼り付け
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

    -- Pane作成 leader + r or d
    { key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Paneを閉じる leader + x
    { key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
    -- Pane移動 leader + hlkj
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    -- Pane選択
    { key = "[", mods = "CTRL|SHIFT", action = act.PaneSelect },
    -- 選択中のPaneのみ表示
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

    -- フォントサイズ切替
    { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    -- フォントサイズのリセット
    { key = "0", mods = "CTRL", action = act.ResetFontSize },

    -- タブ切替 Cmd + 数字
    { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
    { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
    { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
    { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
    { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
    { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
    { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
    { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
    { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },

    -- コマンドパレット
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- 設定再読み込み
    { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    -- キーテーブル用
    { key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    {
      key = "a",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
    },
  },
  -- キーテーブル
  -- https://wezfurlong.org/wezterm/config/key-tables.html
  key_tables = {
    -- Paneサイズ調整 leader + s
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape
      { key = "Enter", action = "PopKeyTable" },
    },
    activate_pane = {
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
    -- copyモード leader + [
    copy_mode = {
      -- 移動
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      -- 最初と最後に移動
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      -- 左端に移動
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      --
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      -- 単語ごと移動
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      -- ジャンプ機能 t f
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      -- 一番下へ
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      -- 一番上へ
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      -- viweport
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      -- スクロール
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      -- 範囲選択モード
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      -- コピー
      { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },

      -- コピーモードを終了
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    },
  },
}
```

:::

## 最後に

WezTermの記事を書いた人はコメント欄でぜひ宣伝してください！
ターミナル&dotfiles自慢もお待ちしています！
いろんな人のカスタマイズを参考にしたい場合はWezTermのGitHub Discussionsを見てみるのもいいかもしれません。
[Show your wezterms · wez/wezterm · Discussion #628](https://github.com/wez/wezterm/discussions/628)

**WezTermはいいぞ**
