---
title: "モテるGit管理 (gh, ghq, git-cz, lazygit)"
emoji: "💪"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [lazygit, gh, ghq, git]
published: false
---

## はじめに

コード管理スマートにしたい！

⭐️愉快なつらみたち⭐️

- [ ] プレフィックス多すぎておぼえられな〜い
- [ ] プロジェクトごとにコミットメッセージのプレフィックスが違う..だと..？
- [ ] 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭
- [ ] GitHubリポジトリを用意するためにターミナルから離れるの...？
- [ ] プロジェクトのディレクトリに移動するために長いパスを打つ苦行
- [ ] あれ？ディレクトリどこにおいたっけ？？
- [ ] プロジェクトルートに戻るために`cd ../`を繰り返し続ける人生...
      etc...

こいつらを！全部！解決してやるぜぇ〜〜！！！💪

目指す姿↓↓
ここにGifを載せる

## 学習の初めをスマートに (gh, ghq)

手始めにこれらを解決しましょう。

> - [ ] GitHubリポジトリを用意するためにターミナルから離れるの...？
> - [ ] あれ？ディレクトリどこにおいたっけ？？
> - [ ] プロジェクトのディレクトリに移動するために長いパスを打つ苦行

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
以下のような設定をzshの設定ファイルに書き込むことで`Control + g`を押して、リポジトリ名を指定するだけで移動することができちゃうんです...！
しかもうろ覚えでも部分一致していれば移動できます！スマートすぎる！！

```shell:~/.zshrc
# ghq
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf
```

自分はファジーファインダーにfzf, プレビューにbatを使用しています。この部分はお好きなものに書き換えてください。
コードはこちらの記事に載っているものを使用させていただだいています。コードの詳細な解説もあるありがたい記事です。感謝🙏
@[card](https://qiita.com/tomoyamachi/items/e51d2906a5bb24cf1684)

解決ッ！🎉

> - [x] GitHubリポジトリを用意するためにターミナルから離れるの...？
> - [x] あれ？ディレクトリどこにおいたっけ？？
> - [x] プロジェクトのディレクトリに移動するために長いパスを打つ苦行

## コミットをスマートに

続いてのお題はこちら。

> - [ ] プレフィックス多すぎておぼえられな〜い
> - [ ] プロジェクトごとにコミットメッセージのプレフィックスが違う..だと..？
> - [ ] 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭

### コミットメッセージを美しく (git-cz)

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

これで解決ですね🎵

> - [x] プレフィックス多すぎておぼえられな〜い
> - [x] プロジェクトごとにコミットメッセージのプレフィックスが違う..だと..？

### Git管理を簡単に (Lazygit)

Git管理を簡単にするツール`lazygit`を使用します。
ターミナルでもNeovimでも使用することができます。
下記のように簡単にファイルをステージング&コミットし、Pushすることができます。
![lazygit](/images/lazy-git/lazygit.gif =700x)

コミットメッセージを英語にしたい場合はNeovimを使ってサクッと翻訳してコミットしましょう。

TODO: 英語に翻訳してコミット

LazyGitでよくやる操作を紹介します。

#### ステージングにあるファイルを一時退避 (Stash)

LazygitでStashしたい場合は以下の方法があります。

s: 変更の差分を丸ごとStash
S: Stash方法を選択してStash

ステージングだけStashする場合はこんな感じです。

- スペースキーでファイルをステージング
- ステージングしたファイルを`S` → `s`でStash
- Stashウィンドウを選択し、反映させたいStashをスペースで選択
- Stashした内容が反映される

![Stash](/images/lazy-git/stash.gif =700x)

#### コミット漏れを修正

ファイルをステージングした状態で`A`を押すと直前のコミットに追加することができます。

#### コミットメッセージを修正

修正したいコミットメッセージにカーソルを合わせて`r`を押すとコミットメッセージを編集することができます。

#### コミットの内容を変更したい (fixup)

特定のコミットを修正したい場合は、以下の手順で行います。

- コミットに加えたい内容をステージング
- 修正したい対象のコミットにカーソルを合わせて`F`を押す (fixupコミットが作成される)
- 修正したい対象のコミットに再度カーソルを合わて`S`を押す (auto squash)

fixupよくわからんって人は以下の記事を参考にしてください。
@[card](https://qiita.com/inukai-masanori/items/82eb0626fd75f3eb0922)

コミットメッセージの修正もできるようになりました🙌

> - [x] 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭

### Lazygitからgit-czを使う

## プロジェクトルートに戻る時もスマートに

最後にこれを解決しましょう。

> - [ ] プロジェクトルートに戻るために`cd ../`を繰り返し続ける人生...

実はgitコマンドには`git rev-parse --show-toplevel`という便利コマンドがあります。
これを以下のようにaliasに設定しておくと`proot`でプロジェクトルートに移動することができます。

```shell:~/.zshrc
abbr -S proot='cd $(git rev-parse --show-toplevel)' >>/dev/null
```

または

```shell:~/.zshrc
alias proot='cd $(git rev-parse --show-toplevel)'
```

これでもう`../`を繰り返す必要はありませんね🎵

> - [x] プロジェクトルートに戻るために`cd ../`を繰り返し続ける人生...

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

## おわりに

タイトルを考えるのが苦手で迷ったらモテるをつければいいと思っている節がある。
次回は真面目なタイトルを考えられるように頑張る。

## 参照

[ghqでリポジトリ管理を簡単にする](https://zenn.dev/oreo2990/articles/13c80cf34a95af)
