---
title: "モテるGit管理 (gh, ghq, git-cz, lazygit)"
emoji: "💪"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [lazygit, gh, ghq, git]
published: true
published_at: 2024-12-04 07:00
---

:::message
この記事は[ミライトデザイン Advent Calendar 2024](https://qiita.com/advent-calendar/2024/miraito-inc)の4日目です。
3日目は[ブッチ](https://zenn.dev/t_kitamura)さんの「2024年 お世話になったAIサービス」という記事でした。
:::

@[card](https://zenn.dev/t_kitamura/articles/dd2161bb4d3038)

この頃海外のエンジニアの環境構築動画を見るのにハマっているため、Mapifyから試してみようと思います。
また、「[ドキュメント読み込み機能が便利だった](https://zenn.dev/t_kitamura/articles/dd2161bb4d3038#%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%81%BF%E6%A9%9F%E8%83%BD%E3%81%8C%E4%BE%BF%E5%88%A9%E3%81%A0%E3%81%A3%E3%81%9F)」にある公式ドキュメントベースで回答を生成してくれるの便利ですね！

## はじめに

コード管理スマートにしたい！

⭐️愉快なつらみたち⭐️

- [ ] GitHubリポジトリを用意するためにターミナルから離れるの...？
- [ ] あれ？ディレクトリどこにおいたっけ？？
- [ ] プロジェクトのディレクトリに移動するために長いパスを打つ苦行
- [ ] プレフィックス多すぎておぼえられな〜い
- [ ] プロジェクトごとにコミットメッセージのプレフィックスが違う..だと..？
- [ ] 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭
- [ ] プロジェクトルートに戻るために`cd ../`を繰り返し続ける人生...
      etc...

こいつらを！全部！解決してやるぜぇ〜〜！！！💪

## 学習の初めをスマートに

手始めにこれらを解決しましょう。

> - [ ] GitHubリポジトリを用意するためにターミナルから離れるの...？
> - [ ] あれ？ディレクトリどこにおいたっけ？？
> - [ ] プロジェクトのディレクトリに移動するために長いパスを打つ苦行

こんな感じでCLIでGitHubリポジトリとローカルのリポジトリを用意することができるようになります。

![demo gh ghq](/images/lazy-git/demo_gh_ghq.gif)

[gh](https://github.com/cli/cli)コマンドでGitHubリポジトリを作成し、[ghq](https://github.com/x-motemen/ghq)コマンドでローカルに clone & git init します。
そしてghqでgit管理しているプロジェクト一覧を取得し、[fzf](https://github.com/junegunn/fzf)で選択してプロジェクトディレクトリへ移動します。

```sh
# GitHubリポジトリを作成
gh repo create [プロジェクト名] --private

# ローカルにクローン & git init
ghq get [プロジェクト名]

# ^Gでghqで管理しているリポジトリ一覧を取得し、fzfで選択して移動
```

それぞれのツールの導入やら使い方やらを解説していきます。

---

### GitHubの操作をCLIで (gh)

GitHubの操作をCLIで行いたい時は GitHub CLI (gh コマンド) を使用します。
@[card](https://github.com/cli/cli)
導入は以下の記事が参考になります。
@[card](https://zenn.dev/toraco/articles/d6b760fd11bf3a)

リポジトリを作成したい時は

```sh
# プライベートリポジトリ
gh repo create [プロジェクト名] --private
# 公開リポジトリ
gh repo create [プロジェクト名] --public
```

リポジトリを削除したい場合は

```sh
gh repo delete [プロジェクト名]
```

みたいな感じでサクッとできます。

PRやらIssueやらも操作できるので詳しくは`gh --help`を確認してみてください。

:::details gh --help (日本語ver.)

```text
GitHubとコマンドラインからシームレスに連携します。

使用法
  gh <コマンド> <サブコマンド> [フラグ]

コアコマンド
  auth:        ghとgitをGitHubに認証する
  browse:      ブラウザでリポジトリを開く
  codespace:   コードスペースに接続して管理する
  gist:        gistを管理する
  issue:       イシューを管理する
  org:         組織を管理する
  pr:          プルリクエストを管理する
  project:     GitHubプロジェクトを操作する
  release:     リリースを管理する
  repo:        リポジトリを管理する

GitHub Actionsコマンド
  cache:       GitHub Actionsキャッシュを管理する
  run:         ワークフロー実行の詳細を表示する
  workflow:    GitHub Actionsワークフローの詳細を表示する

エイリアスコマンド
  co:          "pr checkout"のエイリアス

追加コマンド
  alias:       コマンドショートカットを作成する
  api:         認証されたGitHub APIリクエストを行う
  attestation: アーティファクトの証明書を操作する
  completion:  シェル補完スクリプトを生成する
  config:      ghの設定を管理する
  extension:   gh拡張機能を管理する
  gpg-key:     GPGキーを管理する
  label:       ラベルを管理する
  ruleset:     リポジトリのルールセット情報を表示する
  search:      リポジトリ、イシュー、プルリクエストを検索する
  secret:      GitHubシークレットを管理する
  ssh-key:     SSHキーを管理する
  status:      リポジトリ全体の関連イシュー、プルリクエスト、通知に関する情報を表示する
  variable:    GitHub Actions変数を管理する

ヘルプトピック
  actions:     GitHub Actionsの操作について学ぶ
  environment: ghで使用できる環境変数
  exit-codes:  ghが使用する終了コード
  formatting:  ghからエクスポートされたJSONデータのフォーマットオプション
  mintty:      MinTTYでghを使用する際の情報
  reference:   すべてのghコマンドの包括的なリファレンス

フラグ
  --help      コマンドのヘルプを表示する
  --version   ghのバージョンを表示する

例
  $ gh issue create
  $ gh repo clone cli/cli
  $ gh pr checkout 321

詳細情報
  コマンドの詳細については`gh <コマンド> <サブコマンド> --help`を使用してください。
  マニュアルはhttps://cli.github.com/manualを参照してください。
  終了コードについては`gh help exit-codes`を使用して学んでください。
```

::::

今いるリポジトリをブラウザで開くコマンドもあり、URLの共有や画面共有の時に便利ですね。

```sh
# 今いるリポジトリをブラウザで開く
gh browse
```

✌️✌️✌️✌️解決✌️✌️✌️✌️
これでターミナルとずっと一緒❤️❤️

> - [x] GitHubリポジトリを用意するためにターミナルから離れるの...？

---

### ローカルにあるリポジトリを管理 (ghq, fzf)

ghqはローカルにあるリポジトリを管理するためのツールです。
@[card](https://github.com/x-motemen/ghq)
ghqで管理すると、クローンするパスが整理されるため、今自分がいるディレクトリや配置先のディレクトリを意識せずにクローンできます。
クローンするためにいちいちディレクトリ移動する必要がなくなるのがいいですね。
以下のコマンドで管理しているリポジトリの一覧を取得できるのも便利です。

```sh
# ghqで管理しているリポジトリ一覧
ghq list
```

fzfはリストから曖昧検索して選択することができるツールです。
@[card](https://github.com/junegunn/fzf)

#### ghqの導入

```sh
brew install ghq
```

`ghq`で管理するリポジトリのディレクトリのパスは`~/.gitconfig`の`[ghq] root`で指定します。

```ini:~/.gitconfig
[ghq]
 root = /Users/username/src
```

#### ghqでクローン

自分が管理しているレポジトリはリポジトリ名単体でクローンできます。

```sh
ghq get project-name
```

自分以外のリポジトリをクローンする時はリポジトリの所有者名をつけます。

```sh
ghq get user-name/project-name
```

`ghq get`は以下のパスにクローンしたものを配置します。

```text
[.gitconfigで指定したディレクトリ] + [github.com/user-name/project-name]
```

例えば、mozumasu/dotfilesをクローンした場合は以下のようになります。

```text
/Users/mozumasu/src/github.com/src/mozumasu/dotfiles
```

:::details ghq --help (日本語ver.)

```text
NAME:
   ghq - リモートリポジトリのクローンを管理

USAGE:
   ghq [グローバルオプション] コマンド [コマンドオプション]

VERSION:
   1.7.1 (rev:5bf53dc)

AUTHORS:
   motemen <motemen@gmail.com>
   Songmu <y.songmu@gmail.com>

COMMANDS:
   get, clone  リモートリポジトリのクローン/同期
   list        ローカルリポジトリの一覧
   rm          ローカルリポジトリの削除
   root        リポジトリのルートを表示
   create      新しいリポジトリを作成
   help, h     コマンドの一覧または特定のコマンドのヘルプを表示

GLOBAL OPTIONS:
   --help, -h     ヘルプを表示
   --version, -v  バージョンを表示

```

:::

今いるディレクトリを意識せずに設定したパスにクローンできるのは認知不可が低くて快適ですね。
✌️✌️✌️✌️解決✌️✌️✌️✌️

> - [x] あれ？ディレクトリどこにおいたっけ？？

---

### プロジェクトディレクトリにサクッと移動(ghq, fzf)

クローン先のパスが長いな〜と感じるかもしれませんが、
aliasを設定して`^G`を押すとサクッと移動できるようにしておけば負担になることもありません。

こんな感じでリポジトリ一覧からfzfで曖昧検索して指定したリポジトリに移動できるようになります。
![demo ghq fzf](/images/lazy-git/ghq_fzf.png)

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

> - [x] プロジェクトのディレクトリに移動するために長いパスを打つ苦行

---

## コミットをスマートに

続いてのお題はこちら。

> - [ ] プレフィックス多すぎておぼえられな〜い
> - [ ] プロジェクトごとにコミットメッセージのプレフィックスが違う..だと..？
> - [ ] 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭

[Lazygit]()でTUI操作によるGitコマンドの入力の手間を省き、[git-cz](https://github.com/streamich/git-cz)でプレフィックスとコミットメッセージのフォーマットを行います。
Pushして該当のリポジトリをブラウザで開いています。
![demo lazygit git-cz](/images/lazy-git/demo_lazygit_git-cz.gif)

### コミットメッセージを美しく (git-cz)

git-czは[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)というコミットメッセージの標準規格に従ったコミットメッセージを作成することができます。
@[card](https://github.com/streamich/git-cz)
以下のように対話形式でコミットメッセージを作成することができるため、プレフィックスが覚えられない&絵文字つけ忘れ問題もgit-czが解決してくれます。
![git-cz](/images/lazy-git/git_cz.gif =700x)

#### git-czの導入

```sh
npm install -g git-cz
```

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

> - [x] プレフィックス多すぎておぼえられな〜い
> - [x] プロジェクトごとにコミットメッセージのプレフィックスが違う..だと..？

### Git管理を簡単に (Lazygit)

Git管理を簡単にするツール`lazygit`を使用します。
コミットを手軽に分けたり、修正したい！みたいな時に重宝します。
ターミナルでもNeovimでも使用することができます。
下記のように簡単にファイルをステージング&コミットし、Pushすることができます。
![lazygit](/images/lazy-git/lazygit.gif =700x)

コミットメッセージを英語にしたい場合はNeovimを使ってサクッと翻訳してコミットしましょう。

LazyGitでよくやる操作を紹介します。

#### コミット前のファイルを一時退避 (Stash)

差分を全てStash

- `s`

ステージングだけStash

- `スペースキー`でファイルをステージング
- ステージングしたファイルを`S` → `s`でStash

Stashをステージに反映

- Stashウィンドウを選択し、反映させたいStashをスペースで選択
- Stashした内容が反映される

以下のgifではステージングのStashとStashの反映をしています。

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

## おわりに

[アドベントカレンダー](https://qiita.com/advent-calendar/2024/miraito-inc)5日目は[ucan](https://qiita.com/ucan-lab)さんの「JavaScriptビルドツールの歴史と進化」という記事です。
ツールオタクとしては目が離せない内容ですね。
明日もぜひお楽しみに🎄

## 参照

[ghqでリポジトリ管理を簡単にする](https://zenn.dev/oreo2990/articles/13c80cf34a95af)
