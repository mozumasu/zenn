---
title: "入力したキーを画面に表示してGIF画像にする(KeyCastr, ShowKeys)"
emoji: "👌"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: [KeyCastr, SowKeys, tool]
published: false
---

## 入力したキーを画面に表示する

たまに技術系の記事やGitHubのREADMEなどで、キー入力が表示されたGifを見かけることがあります。
ツールの使い方を説明する上で便利そうだったのでキー入力を表示するツールを探してみました。
見つけたのは以下の2つです。

- [keycastr/keycastr: KeyCastr, an open-source keystroke visualizer](https://github.com/keycastr/keycastr)
- [jmhobbs/ShowKeys: Simple OSX app to allow display of pressed keys. Great for screencasts.](https://github.com/jmhobbs/ShowKeys)

以下の理由でKeyCastrを選択しました。

- ショートカットでキー入力の表示をON/OFFできる
- 入力した内容を適度に区切って表示してくれる
- メンテナンスが現在も行われている

### KeyCastr

KeyCastrはHomebrewでインストールできます。

```sh
brew install --cask keycastr
```

アプリを起動すると、画面にキー入力が表示されるようになります。

### KeyCastrの設定項目

キーの

### ShowKeys

ShowKeysも気になる方向けに導入方法を紹介します。
ダウンロードはReleaseページからできます。自分は[0.3](https://github.com/jmhobbs/ShowKeys/releases/tag/0.3)をダウンロードしました。

[Releases · jmhobbs/ShowKeys](https://github.com/jmhobbs/ShowKeys/releases)

そのままアプリを開こうとすると、「開発元が未確認のため開けません。」といったエラーが出ます。
アプリを起動できない場合は、以下の手順で開くことができます。

1. ダウンロードしたzipを解凍
2. 解凍後のShowKeys.appをアプリケーションフォルダに移動
3. Finderで`Control`キーを押しながらアプリをクリックして、ショートカットメニューから開くを選択

この方法で開ない方はMACの設定画面＞セキュリティとプライバシー＞アクセシビリティからShowKeys.appを追加して上記の手順を試してみてください。
こちらもアプリの設定画面からキーの表示時間や文字サイズ、色などを変更できます。

## 動画をGIFにする

自分はこちらの方法で動画をGIFに変換しています。
Windowsユーザーであれば、[ScreenToGif](https://github.com/NickeManarin/ScreenToGif)が良さそうです。
@[card](https://zenn.dev/ctrlkeykoyubi/articles/how-to-screen-to-gif)

MACユーザーなら下記の方法がオススメです。
自分はこちらの方法で動画をGIFに変換しています。
@[card](https://zenn.dev/chot/articles/8d2b0e6e0f7741)
