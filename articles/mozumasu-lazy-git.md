---
title: "モテるGit管理 (gh, ghq, git-cz, lazygit)"
emoji: "💪"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [lazygit, gh, ghq, git, contest2024]
published: true
published_at: 2024-12-04 07:00
---

:::message
この記事は[ミライトデザイン Advent Calendar 2024](https://qiita.com/advent-calendar/2024/miraito-inc)の4日目です。
3日目は[ブッチ](https://zenn.dev/t_kitamura)さんの「2024年 お世話になったAIサービス」という記事でした。
:::

@[card](https://zenn.dev/t_kitamura/articles/dd2161bb4d3038)

この頃海外のエンジニアの環境構築動画を見るのにハマっているため、Mapifyから試してみようと思います。
「[ドキュメント読み込み機能が便利だった](https://zenn.dev/t_kitamura/articles/dd2161bb4d3038#%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%81%BF%E6%A9%9F%E8%83%BD%E3%81%8C%E4%BE%BF%E5%88%A9%E3%81%A0%E3%81%A3%E3%81%9F)」にある公式ドキュメントベースで回答を生成してくれるのも便利ですね！

## はじめに

コード管理スマートにしたい！カッコつけたい！😎

⭐️愉快なつらみたち⭐️

- [ ] GitHubリポジトリを用意するためにターミナルから離れるの...？
- [ ] あれ？ディレクトリどこにおいたっけ？？
- [ ] プロジェクトのディレクトリに移動するために長いパスを打つ苦行
- [ ] プレフィックス多すぎておぼえられな〜い
- [ ] プロジェクトごとにコミットメッセージのプレフィックスが違う..だと..？
- [ ] 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭
- [ ] プロジェクトルートに戻るために`cd ../`を繰り返し続ける人生...

こいつらを！全部！解決してやるぜぇ〜〜！！！💪

## 学習の初めをスマートに

手始めにこれらを解決しましょう。

> - [ ] GitHubリポジトリを用意するためにターミナルから離れるの...？
> - [ ] あれ？ディレクトリどこにおいたっけ？？
> - [ ] プロジェクトのディレクトリに移動するために長いパスを打つ苦行

こんな感じでCLIでGitHubリポジトリとローカルのリポジトリを用意することができるようになります。

![demo gh ghq](/images/lazy-git/demo_gh_ghq.gif)

具体的には以下の手順を行なっています。

1. [gh](https://github.com/cli/cli)コマンドでGitHubリポジトリを作成し
2. [ghq](https://github.com/x-motemen/ghq)コマンドでローカルに clone & git init
3. ghqでgit管理しているプロジェクト一覧を取得し、[fzf](https://github.com/junegunn/fzf)で選択してプロジェクトディレクトリへ移動

```sh
# GitHubリポジトリを作成
gh repo create [プロジェクト名] --private

# ローカルにクローン & git init
ghq get [プロジェクト名]

# ^Gでghqで管理しているリポジトリ一覧を取得し、fzfで選択して移動 (^Gはあらかじめ.zshrcに設定)
# 設定していない場合は以下のコマンドで同じことができる
ghq list | fzf | xargs -I{} cd $(ghq root)/{}
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

### ローカルにあるリポジトリを管理 (ghq)

#### ghqとは

ghqはローカルにあるリポジトリを管理するためのツールです。
@[card](https://github.com/x-motemen/ghq)
クローンするパスをghqで管理するため、自分が今いるディレクトリを意識せずクローンすることができます。
クローンするためにいちいちディレクトリ移動する必要がなくなるのがいいですね。
以下のコマンドで管理しているリポジトリの一覧を取得できるのも便利です。

```sh
# ghqで管理しているリポジトリ一覧
ghq list
```

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

#### fzfとは

fuzzy finderの一つで、リストから曖昧検索して選択することができるツールです。
使えばわかります。使いましょう。
![demo ghq fzf](/images/lazy-git/ghq_fzf.png)
@[card](https://github.com/junegunn/fzf)

#### fzfの導入

インストールは以下のコマンドで行います。

```sh
brew install fzf
```

ghqのパスが長いな〜と感じるかもしれませんが、
aliasを設定して`^G`を押すとサクッと移動できるようにしておけば負担になることもありません。

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

![demo lazygit git-cz](/images/lazy-git/demo_lazygit_git-cz.gif)
画像は以下の手順を行なっている様子です。

1. [Lazygit](https://github.com/jesseduffield/lazygit)でファイルをステージング
2. Lazygit経由で[git-cz](https://github.com/streamich/git-cz)を実行してコミット
3. LazygitでPush
4. `ghq browse`で今いるディレクトリのGitHubリポジトリをブラウザで開く

### コミットメッセージを美しく (git-cz)

git-czは[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)というコミットメッセージの標準規格に従ったコミットメッセージを作成することができます。
要はプレフィックスとフォーマットを強制してコミットメッセージを美しくしてくれるツールです。
@[card](https://github.com/streamich/git-cz)
以下のように対話形式でプレフィックスを選んでコミットメッセージを作成することができるため、プレフィックスが覚えられない&絵文字つけ忘れ問題もgit-czが解決してくれます。
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

もちろんグローバル設定も用意可能です。
グローバル設定は`~chanlog.config.js`に配置します。

:::details ~/.chanlog.config.js (グローバル設定)

```js:~/.chanlog.config.js
module.exports = {
  disableEmoji: false,
  format: "{type}{scope}: {emoji}{subject}",
  list: [
    "feat",
    "test",
    "fix",
    "chore",
    "docs",
    "refactor",
    "style",
    "ci",
    "perf",
    "package",
    "config",
    "WIP",
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
  scopes: [],
  types: {
    feat: {
      description: "新機能",
      emoji: "🎸",
      value: "feat",
    },
    chore: {
      description: "ビルド関連やライブラリの変更",
      emoji: "🤖",
      value: "chore",
    },
    ci: {
      description: "CI関連の変更",
      emoji: "🎡",
      value: "ci",
    },
    docs: {
      description: "ドキュメントの更新",
      emoji: "✏️",
      value: "docs",
    },
    fix: {
      description: "不具合の修正",
      emoji: "🐛",
      value: "fix",
    },
    perf: {
      description: "パフォーマンス改善",
      emoji: "⚡️",
      value: "perf",
    },
    refactor: {
      description: "リファクタリング",
      emoji: "💡",
      value: "refactor",
    },
    style: {
      description: "コードの処理に影響しない変更（スペースや書式設定など)",
      emoji: "💄",
      value: "style",
    },
    test: {
      description: "テストコード",
      emoji: "💍",
      value: "test",
    },
    //自分用に追加
    package: {
      description: "パッケージ",
      emoji: "📦",
      value: "package",
    },
    config: {
      description: "設定ファイル",
      emoji: "⚙",
      value: "config",
    },
    WIP: {
      description: "作業途中",
      emoji: "🚧",
      value: "WIP",
    },
  },
  messages: {
    type: "プレフィックスを選択:",
    subject: "コミットのタイトル（概要）を入力(option):\n",
    body: "変更内容の詳細を入力(option):\n",
    breaking: "重大な変更を入力(option):\n",
    issues: "関連するisuueを入力(option), 例 #123:",
  },
};
```

:::

### Git管理を簡単に (Lazygit)

Git管理を簡単にするTUIツール`lazygit`を使用します。
![lazygit](/images/lazy-git/lazygit.jpg =700x)

@[card](https://github.com/jesseduffield/lazygit)

コミットを手軽に分けたり、修正したい！みたいな時に重宝します。
`?`でキーバインド一覧を表示できます。gitのコマンドはおろか、lazygitの操作なんて覚えられない！って人でも安心ですね。
![lazygit help](/images/lazy-git/lazygit_help.jpg =700x)
ターミナルでもNeovimでも使用することができます。
下記のように簡単にファイルをステージング&コミットし、Pushすることができます。
![lazygit](/images/lazy-git/lazygit.gif =700x)

#### Lazygitの導入

```sh
brew install jesseduffield/lazygit/lazygit
```

lazygitって入力するのが大変なのでaliasを設定しておくと便利です。

```sh:~/.zshrc
abbr -S lg='lazygit' >>/dev/null
```

:::message

12/6追記:

[さいぬ](https://zenn.dev/sainu)さんからコメントいただきましたので共有させていただきます！

こちらの書き方の方が設定ファイルで`>>/dev/null`まみれにならず、記述がシンプルになるため視認性が上がりますね！

```sh:~/.zshrc
abbr -S --quieter lg='lazygit'
or
abbr -S -qq lg='lazygit'
```

:::

### LazyGitでよくやる操作

#### コミット前のファイルを一時退避 (Stash)

- 差分を全てStash

  - `s`

- ステージングだけStash

  - `スペースキー`でファイルをステージング
  - ステージングしたファイルを`S` → `s`でStash

- Stashをステージに反映

  - Stashウィンドウを選択し、反映させたいStashをスペースで選択
  - Stashした内容が反映される

以下のgifではステージングのStashとStashの反映をしている様子です。

![Stash](/images/lazy-git/stash.gif =700x)

#### コミット漏れを修正 (git commit --amend)

ファイルをステージングした状態で`A`で直前のコミットに加えることができます。
![lazygit_amend](/images/lazy-git/lazygit_amend.gif =700x)

#### コミットメッセージを修正

修正したいコミットメッセージにカーソルを合わせて`r`を押すとコミットメッセージを編集することができます。
![lazygit_rename](/images/lazy-git/lazygit_rename.gif =700x)

#### コミットの内容を変更したい (fixup)

特定のコミットを修正したい場合は、以下の手順で行います。

- コミットに加えたい内容をステージング
- 修正したい対象のコミットにカーソルを合わせて`F`を押す (fixupコミットが作成される)
- 修正したい対象のコミットに再度カーソルを合わて`S`を押す (auto squash)

fixupよくわからんって人は以下の記事を参考にしてください。
@[card](https://qiita.com/inukai-masanori/items/82eb0626fd75f3eb0922)

コミットメッセージの修正もできるようになりました🙌

> - [x] 絵文字つけ忘れ&コミットメッセージ間違えちゃった😭

#### ステージングした後の変更をなかったことにしたい (restore --staged)

ステージングした後の変更を取り消すこともできます。

- ステージング時の状態にしたいファイルにカーソルを合わせる
- `d`→`u`

![ステージングした時の状態にする](/images/lazy-git/lazygit_restore_staged.gif =700x)

#### コミットを別ブランチに持っていく (cherry-pick)

私はよくブランチを間違えてコミットしてしまいます😭
別ブランチにコミットしてしまった場合は以下の手順で別ブランチにコミットを持っていくことができます。

- 間違ってコミットしたブランチに`スペースキー`で移動
- 移動したいコミットにカーソルを合わせて`C`
- コミットを持っていきたいブランチに`スペースキー`で移動
- `V`でコミットを貼り付ける

![cherry-pick](/images/lazy-git/lazygit_cherry_pick.gif =700x)

### Lazygitからgit-czを使う

lazygitの設定ファイルは`~/.config/lazygit/config.yml`にあります。
自分は以下のように設定して、`C`でgit-czを実行できるようにしています。

```yaml:~/.config/lazygit/config.yml
# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md

customCommands:
  - command: git cz
    context: files
    subprocess: true
    key: C

gui:
  language: "ja"
  showIcons: true

# log customize
git:
  branchLogCmd: "git log --graph --color=always --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' {{branchName}} --"
  allBranchesLogCmd: "git log --graph --color=always --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
  paging:
    colorArg: always
    pager: delta --dark --paging=never
```

## プロジェクトルートに戻る時もスマートに

最後にこれを解決しましょう。

> - [ ] プロジェクトルートに戻るために`cd ../`を繰り返し続ける人生...

### プロジェクトルートに戻る

実はgitコマンドには`git rev-parse --show-toplevel`という便利コマンドがあります。
これを以下のようにaliasに設定しておくと`proot`でプロジェクトルートに移動することができます。

```shell:~/.zshrc
abbr -S proot='cd $(git rev-parse --show-toplevel)' >>/dev/null
```

または

```shell:~/.zshrc
alias proot='cd $(git rev-parse --show-toplevel)'
```

### 直前のディレクトリに戻る

`cd -`で直前のディレクトリに戻ることができます。
プロジェクトルートから移動した場合は`cd -`でもプロジェクトルートに戻ることができます。

通常は`cd -`で戻って、`cd -`で戻れなかったら`proot`にして使い分けてもいいかもしれません。

追加でzshの設定ファイルに以下のオプションを追加しておくと`cd`無しでディレクトリ移動ができるようになります。
`-`だけで戻れるので楽ですね。

```sh:~/.zshrc
setopt auto_cd
```

これでもう`../`を繰り返す必要はありませんね🎵

> - [x] プロジェクトルートに戻るために`cd ../`を繰り返し続ける人生...

## git-czとcz-git (12/6追記)

:::message

[unvalley](https://zenn.dev/kirohi)さんよりコメントいただきましたので共有させていただきます！

git-czよりも軽量化されパフォーマンスが上がったcz-git (czg) というツールがあるようです。

@[card](https://github.com/Zhengqbbb/cz-git)

> 148 MB node_modules/git-cz
> 1.9 MB node_modules/cz-git

確かにかなり軽量化されていますね...！

git-czとcz-gitの差分は以下にまとまっているようです。

@[card](https://cz-git.qbb.sh/guide/why)

AI にGit コミット メッセージの件名を生成させる設定もあります。
![alt](https://user-images.githubusercontent.com/40693636/219867044-3ca9823d-9294-4e02-9a5b-624578844168.gif)

> 参照: [OpenAI | cz-git](https://cz-git.qbb.sh/recipes/openai)

よく書くメッセージをエイリアス設定することもできるため、より快適にコミットメッセージを作成できるようになりそうですね😄。

:::

---

## .gitignoreの用意だってスマートに (gibo)

giboは.gitignoreのテンプレートを作成するCLIツールです。
名前の由来はgitignore boilerplates (定型文) からきているようです。
@[card](https://github.com/simonwhitaker/gibo)

利用できるテンプレート一覧は`gibo list`で確認できます。
`gibo dump [利用したいテンプレート]`で.gitignoreに作成できます。

自分は以下のような関数を用意して利用しています。

```sh:~/.zshrc
alias gia='create_gitignore'

# giboで.gitignoreを作成
create_gitignore() {
    local input_file="$1"

    # 引数がない場合は.gitignoreに追加
    if [[ -z "$input_file" ]]; then
        input_file=".gitignore"
    fi

    # テンプレートを選択
    local selected=$(gibo list | fzf \
        --multi \
        --preview "gibo dump {} | bat --style=numbers --color=always --paging=never")

    # 未選択の場合は終了
    if [[ -z "$selected" ]]; then
        echo "No templates selected. Exiting."
        return
    fi

    # 選択したテンプレートを指定したファイルに追加
    echo "$selected" | xargs gibo dump >> "$input_file"

    # 結果のファイルをbatで表示
    bat "$input_file"
}
```

以下のように`Tab`で複数のテンプレートを指定して.gitignoreを作成することができます。

![create .gitignore](/images/lazy-git/create_gitignore.gif =700x)

## おわりに

少しでも皆様のCLI生活が快適になれば幸いです。

[アドベントカレンダー](https://qiita.com/advent-calendar/2024/miraito-inc)5日目は[ucan](https://qiita.com/ucan-lab)さんの「JavaScriptビルドツールの歴史と進化」という記事です。
ツールオタクとしては目が離せない内容ですね。
明日もぜひお楽しみに🎄

また、コメントやTwitterにてコメントいただきありがとうございました！自身の知識のアップデートできて嬉しい限りです。
