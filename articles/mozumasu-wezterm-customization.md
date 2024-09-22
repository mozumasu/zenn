---
title: "モテるターミナルにカスタマイズしよう（wezterm）"
emoji: "😊"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [wezterm, CLI, terminal]
published: false
---

## はじめに完成系を晒す

ターミナルがかっこいいとモテるらしいというのをどこかの記事で読んだので、かっこよくターミナルをカスタマイズしてみました。
完成系はこんな感じです。

![alt wezterm after setting](/images/wezterm-customization/after_setting.png =700x)
ついでにNeovim起動時の画面も晒しておきます。
![alt wezterm after setting](/images/wezterm-customization/after_setting_2.png =700x)

使用しているターミナルは[wezterm](https://wezfurlong.org/wezterm/)です。
weztermの特徴は以下の通りです。

- Rust製でとにかく早い
- 軽量
- カスタマイズ性高め
- 設定ファイルはNeovimと同じLua言語
- tmuxのような画面分割ができる
- 豊富なドキュメントがある
- **コピーモードが使いやすい！！！**

他にも色々良さがあるので、詳しくは公式ドキュメントを参照していただければと思います。
カスタマイズをたくさんしたい人にはオススメのターミナルです。

:::details 設定ファイル
メッセージをここに
:::

## weztermのインストール

Homebrewでインストールする場合は下記のコマンドを実行します。
※一部nightly限定の設定があるため、この記事ではnightly版を使用しています。

```bash
# 通常版
brew install --cask wezterm

# nightly版
brew install --cask wezterm@nightly

```

> Homebrew: <https://formulae.brew.sh/cask/wezterm>
> wezterm公式: <https://wezfurlong.org/wezterm/installation>

weztermを立ち上げると下記のような画面が表示されます。
![alt wezterm before setting](/images/wezterm-customization/before_setting.png)
※画像のターミナルは[starship](https://starship.rs/)を導入しているため、プロンプトの部分はすでにカスタマイズされています。

## 設定ファイルの用意

設定ファイルは`~/.wezterm.lua`に配置します。
uiの設定とキーバインドを別のファイルに分けて管理する派の方は`~/.config/wezterm/wezterm.lua`と`~/.config/wezterm/keybind.lua`で分けるのもありです。
この記事では後者で設定していきます。
このカスタマイズを機に設定ファイルをGitHubで管理したくなった場合は下記の記事が参考にしてください。
[ようこそdotfilesの世界へ #Vim - Qiita](https://qiita.com/yutkat/items/c6c7584d9795799ee164)

まずは下記のような設定ファイルの雛形を用意しましょう。

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

> 参照: [Configuration - Wez's Terminal Emulator](https://arc.net/l/quote/upsihqso)

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
何とこのタブ、カスタマイズできます！！！！そう！weztermならね！！！

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
+ config.hide_tab_bar_if_only_one_tab = true

return config
```

> [window_frame - Wez's Terminal Emulator](https://wezfurlong.org/wezterm/config/lua/config/window_frame.html?h=window_frame)

![alt window_frame](/images/wezterm-customization/window_frame_setting.png =700x)
透明になりましたね！！

`config.use_fancy_tab_bar = false`を設定すると下記の画像のようになり、タブバーは透過ができなくなるため注意してください。
カクカクしたタブをとるか、透過したタブをとるかはあなた次第です。

![alt use_fancy_tab_bar](/images/wezterm-customization/use_fancy_tab_bar_setting.png =700x)

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

![alt wezterm after setting](/images/wezterm-customization/after_setting.png =700x)

## 最後に

weztermの記事を書いた人はコメント欄でぜひ宣伝してください！私も読みたいので！！
ターミナル自慢お待ちしています！
いろんな人のカスタマイズを参考にしたい場合は下記がおすすめです。
[Show your wezterms · wez/wezterm · Discussion #628](https://github.com/wez/wezterm/discussions/628)

**weztermはいいぞ**
