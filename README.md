# Zenn CLI

- [📘 How to use](https://zenn.dev/zenn/articles/zenn-cli-guide)

## ディレクトリ構成

```sh
$ tree -a -L 3 -I node_modules -I .git --dirsfirst
.
├── .github # CI/CD
│   └── workflows
│       └── reviewdog.yml
├── articles # 記事
│   ├── .keep
│   └── mozumasu-aws-cli.md
├── books
│   └── .keep
├── images
│   ├── aws-cli-aws-configure-list.png
│   └── aws-cli-aws-default-profile.png
├── .gitignore
├── .textlintrc
├── README.md
├── changelog.config.js
├── makefile
├── package-lock.json
├── package.json
└── pnpm-lock.yaml
```

## CLIをアップデートする

Zenn CLIの表示がZenn.devと異なるときやCLI利用時に更新通知が表示されたときは下記のコマンドでアップデートを行う

```sh
pnpm install zenn-cli@latest
```

### 記事の追加

```sh
make na s=custom-suffix title="Custom Title" type=idea
```

### Topicの確認

```sh
make vt
```

## 運用方法

### ⭐️コミットメッセージ

git-czの設定ファイル ([changelog.config.js](changelog.config.js)) でコミットメッセージをテンプレート化している

| プレフィックス | ユースケース                              |
| -------------- | ----------------------------------------- |
| add            | 新規記事の追加                            |
| update         | 記事の追記や更新                          |
| publish        | 記事の公開                                |
| unpublish      | 記事の非公開                              |
| delete         | 記事の削除                                |
| fix            | 記事の誤字・脱字の修整                    |
| chore          | CI/CDの変更やパッケージのアップデートなど |
| docs           | ドキュメントの更新                        |

```

```
