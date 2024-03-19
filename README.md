# Zenn CLI

* [📘 How to use](https://zenn.dev/zenn/articles/zenn-cli-guide)

## CLIをアップデートする
Zenn CLIの表示がzenn.devと異なるときやCLI利用時に更新通知が表示されたときは下記のコマンドでアップデートを行う
```
npm install zenn-cli@latest
``` 
## 記事の追加
```
make na s=custom-suffix title="Custom Title" type=idea
```

# 運用方法
## ⭐️コミットメッセージ
| プレフィックス | ユースケース |
| --- | --- |
| add | 新規に記事を作成したとき |
| update | 記事を追記、更新したとき |
| style | 記事の文体やマークダウンを修正したとき |
| fix | 記事の誤字・脱字を修整したとき |
| publish | 記事をZennに公開したとき |
| chore | パッケージをアップデートしたとき |