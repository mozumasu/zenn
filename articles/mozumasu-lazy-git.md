---
title: "モテるGit管理"
emoji: "💪"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [lazygit, gh, ghq, git]
published: false
---

## はじめに

コード管理スマートにしたい！

⭐️愉快なつらみたち⭐️

- プレフィックス多すぎておぼえられな〜い！
- プロジェクトごとにプレフィックスが違う..だと..？
- 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭
- GitHubリポジトリを用意するためにターミナルから離れるの...？
- プロジェクトのディレクトリに移動するために長いパスを打つ苦行
- あれ？ディレクトリどこにおいたっけ？？
  etc...

こいつらを！全部！解決してやるぜぇ〜〜！！！💪

目指す姿↓↓
ここにGifを載せる

## 使用するツールの紹介と導入

### ghq

@[card](https://github.com/x-motemen/ghq)

インストール

```sh
brew install ghq
```

`ghq`で管理するリポジトリのディレクトリのパスは`~/.gitconfig`の`[ghq] root`で指定します。

```ini:~/.gitconfig
[ghq]
 root = /Users/username/src
```

### GitHub CLI (gh)

@[card](https://github.com/cli/cli)
GitHub CLIの導入は以下の記事を参考にしてください。
@[card](https://zenn.dev/toraco/articles/d6b760fd11bf3a)

### git-cz

[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)というコミットメッセージの標準規格に従ったコミットメッセージを作成することができます。
@[card](https://github.com/streamich/git-cz)

インストール

```sh
npm install -g git-cz
```

## 学習の初めをスマートに

新しい言語やツールを試す時、GitHubリポジトリを用意してローカルにもディレクトリを用意すると思います。
これをGUIでやるのは面倒です。

怠惰にターミナルからサクッとやっちゃいましょう。

**1. まずはGitHubリポジトリを作ります。**

```sh
ghq repo create project-name
```

**2. 続いてローカルにGitHubリポジトリをクローンします。**

```sh
shq get project-name
```

ユーザー名を指定することもできます。
自分以外のリポジトリをクローンする時などに用います。

```sh
ghq get user-name/project-name
```

`ghq get`すると、`.gitconfig` の`[ghq] root`で指定したディレクトリ+`github.com/user-name/project-name`+`github.com/user-name/project-name`にリポジトリがクローンされます。
今いるディレクトリを意識せずに指定のディレクトリにクローンできるのは認知不可が低くて快適ですね。

**3. 作成したリポジトリに移動します。**

「でも結局リポジトリに移動するのだから、パスを打たないといけないのは変わらなくない？」って思いましたよね？
ところがどっこい、リポジトリ名を指定するだけで移動することができちゃうんです...！
しかもうろ覚えでも部分一致していれば移動できちゃいます！スマートすぎるぅ〜！！

## コミットをスマートに

### コミットメッセージを美しく

フォーマットを整えつつ絵文字文字をいい感じにつけてくれる`git-cz`を使用します。
以下のように対話形式でコミットメッセージを作成することができるため、プレフィックスが覚えられない問題もgit-czが解決してくれます。
![git-cz](/images/lazy-git/git_cz.gif =700x)

#### プロジェクトごとにプレフィックスを設定

プロジェクトごとに固有のプレフィックスがある場合はプロジェクトのルートに`changelog.config.js`を設置し、プレフィックスを設定します。

:::details zennのリポジトリの例

```js:changelog.config.js
module.exports = {
  disableEmoji: false,
  format: "{type}: {emoji}{subject}",
  list: [
    "add",
    "update",
    "publish",
    "unpublish",
    "delete",
    "fix",
    "chore",
    "docs",
  ],
  maxMessageLength: 64,
  minMessageLength: 3,
  questions: [
    "type",
    "scope",
    "subject",
    "body",
    "breaking",
    "issues",
    "lerna",
  ],
  types: {
    add: {
      description: "新規記事の追加",
      emoji: "🚀",
      value: "add",
    },
    update: {
      description: "記事の追記や更新",
      emoji: "🎸",
      value: "update",
    },
    publish: {
      description: "記事の公開",
      emoji: "🔖",
      value: "publish",
    },
    unpublish: {
      description: "記事の非公開",
      emoji: "🙈",
      value: "unpublish",
    },
    delete: {
      description: "記事の削除",
      emoji: "🗑",
      value: "delete",
    },
    fix: {
      description: "記事の誤字・脱字の修正",
      emoji: "🐛",
      value: "fix",
    },
    chore: {
      description: "CI/CDの変更やパッケージのアップデートなど",
      emoji: "🤖",
      value: "chore",
    },
    fix: {
      description: "不具合の修正",
      emoji: "🐛",
      value: "fix",
    },
    docs: {
      description: "ドキュメントの更新",
      emoji: "✏️",
      value: "docs",
    },
  },
  messages: {
    type: "Select the type of change that you're committing:",
    subject: "Write a short, imperative mood description of the change:\n",
    body: "Provide a longer description of the change:\n ",
    breaking: "List any breaking changes:\n",
    issues: "Issues this commit closes, e.g #123:",
  },
};
```

:::

### Git管理をシンプルに

Git管理を簡単にするツール`lazygit`を使用します。
ターミナルでもNeovimでも使用することができます。
下記のように簡単にファイルをステージング&コミットし、Pushすることができます。
![lazygit](/images/lazy-git/lazygit.gif =700x)

コミットメッセージを英語にしたい場合はNeovimを使ってサクッと翻訳してコミットしましょう。

TODO: 英語に翻訳してコミット

## 参照

[ghqでリポジトリ管理を簡単にする](https://zenn.dev/oreo2990/articles/13c80cf34a95af)

```

```
