---
title: "unixporn入門"
emoji: "🌟"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["unixporn", "Übersicht", "aerospace", "simplebar"]
published: false
---

## はじめに

Zennにはunixpornの記事がZennZenn無い。

### unixpornって？

unixpornとは、Unix系OS（LinuxやmacOSなど）のデスクトップ環境をかっこよくカスタマイズし、画面や設定を共有するコミュニティのことです。

@[card](https://www.reddit.com/r/unixporn/)

## できた画面

カスタマイズした結果、こんな感じの画面になりました。

[mozumasu/dotfiles](https://github.com/mozumasu/dotfiles)

---

あなたは`cmd-tab`を連打してウィンドウを切り替えてやいないだろうか?
エンジニアたるもの、欲しいウィンドウは一発で表示しなくてはならない。
もちろん、ウィンドウを切り替え時にアニメーションを流すなんぞもってのほかである。

### ウィンドウマネージャー: Aerospace

ウィンドウマネージャー(通称: WM)を導入して

- ウィンドウ切り替え時のアニメーション
- ウィンドウを`cmd-tab`で探す
- ウィンドウサイズの調整

から卒業しよう。

Aerospaceがあればキーボードのみでウィンドウのサイズ変更やウィンドウの切り替えが可能である。
しかも、1つの画面に2や3つウィンドウが増えても自動で画面のサイズを調整してくれる。

慣れればウィンドウが重ならず、ウィンドウを探す時間がなくなるはずだ。

### ウィジェット: Übersicht

`Übersicht`はウィジェットを表示するためのアプリケーションである。

### メニューバー: simple-bar

前提条件

Simple-barはクローンによりインストールを行う。

```sh
# 公式ドキュメントの例
git clone https://github.com/Jean-Tinland/simple-bar $HOME/Library/Application\ Support/Übersicht/widgets/simple-bar
```

私は設定ファイルをgit管理したいため`~/.connfig`配下を指定しました。

```sh
# 公式ドキュメントの例
git clone https://github.com/Jean-Tinland/simple-bar ~/.config/ubersicht/widgets/simple-bar
```

> 参照: [simple-bar documentation · Jean Tinland](https://www.jeantinland.com/toolbox/simple-bar/documentation/installation/)

インストールが完了したらメニューバーの`Übersicht`をクリック > Preferences で画像のように設定します。

# 公式ドキュメントの例

## simple-bar

## メニューバー

## おわりに

メモリの修理ができたらLinuxでもチャレンジしたい。
