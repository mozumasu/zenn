---
title: "CLIでもコミットメッセージはAIに書いてもらえる (cz-git,czg)"
emoji: "⚡️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [git, czgit, czg]
published: false
---

## はじめに

[モテるGit管理 (gh, ghq, git-cz, lazygit)](https://zenn.dev/mozumasu/articles/mozumasu-lazy-git)のコメントにて **cz-git** を紹介していただいたので試しに使ってみました。

## cz-git とは？

cz-gitとは、対話形式でコミットメッセージをフォーマットに沿って作成することができるツールです。
英語であれば、コミットメッセージをAIに生成してもらうこともできちゃいます。

![czg demo](/images/cz-git/demo.gif =700x)
_AIでコミットメッセージを作成している様子_

@[card](https://cz-git.qbb.sh/)
@[card](https://github.com/Zhengqbbb/cz-git)

コミットメッセージのフォーマットは、[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) の元である [Angular のコミットメッセージ標準](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit) に準拠しています。

似たツールとして [git-cz](https://github.com/streamich/git-cz) や [Commitizen](https://github.com/commitizen/cz-cli) がありますが、cz-git は複雑な依存関係を解決し、さらに軽量化しています。

> 148 MB node_modules/git-cz
> 1.9 MB node_modules/cz-git

### cz-gitの推しポイント

以前はgit-czを使っていたのですが、cz-gitの場合は以下のようなメリットがあったため移行しました。

- 絵文字あり/なし を簡単に切り替え
- AIによるコミットメッセージ生成
- package.jsonを元にscopeを自動設定

## czg とは？

公式のページを見にいくと、どうやらcz-gitの他にczgというものがあるようです。

@[card](https://cz-git.qbb.sh/cli/)

czgとは、cz-gitをCLIツールとして利用できるようにしたものです。

プロジェクトごとに導入する場合は cz-git、CLIツールとして手軽に使用したい場合は czg を利用すると良いでしょう。
cz-gitの場合は `cz` または `git cz` で実行するのに対し、czg の場合は `czg` または `git czg` で実行できます。

この記事ではCLIツールとして使用するため czg の導入方法を紹介します。

## インストール

```sh
# npmの場合
npm install -g czg cz-git
```

> 参照: [czg | Interactive Commitizen CLI that generate standardized git commit message](https://cz-git.qbb.sh/cli/install)

## cz-git の導入

### git-cz のアンインストール

自分の環境には [git-cz](https://github.com/streamich/git-cz) が入っているため、アンインストールします。

```sh
npm uninstall -g git-cz
```

### cz-git のインストール

cz-gitには `cz-git` と `commitizen` が必要なので両方インストールします。

```sh
npm install -g cz-git commitizen
```

続いて、グローバル設定ファイルを配置します。
commitizen がデフォルトで cz-git を使うように設定され、`cz` を実行するとンタラクティブにコミットメッセージを作成できるようになります。

```sh
echo '{ "path": "cz-git", "$schema": "https://cdn.jsdelivr.net/gh/Zhengqbbb/cz-git@1.11.0/docs/public/schema/cz-git.json" }' > ~/.czrc
```

---

私はホームディレクトリ直下に設定ファイルを置くよりも、`~/.config/` 配下で管理するのが好きです。
以下のように設定ファイルのパスを設定します。

### cz-git のフォーマット設定

設定ファイルは

```js:~/commitlint.config.js
const { defineConfig } = require('cz-git')

module.exports = defineConfig({
    rules: {
        // @see: https://commitlint.js.org/#/reference-rules
    },
    prompt: {
        alias: { fd: 'docs: fix typos' },
        messages: {
            type: 'Select the type of change that you\'re committing:',
            scope: 'Denote the SCOPE of this change (optional):',
            customScope: 'Denote the SCOPE of this change:',
            subject: 'Write a SHORT, IMPERATIVE tense description of the change:\n',
            body: 'Provide a LONGER description of the change (optional). Use "|" to break new line:\n',
            breaking: 'List any BREAKING CHANGES (optional). Use "|" to break new line:\n',
            footerPrefixesSelect: 'Select the ISSUES type of changeList by this change (optional):',
            customFooterPrefix: 'Input ISSUES prefix:',
            footer: 'List any ISSUES by this change. E.g.: #31, #34:\n',
            generatingByAI: 'Generating your AI commit subject...',
            generatedSelectByAI: 'Select suitable subject by AI generated:',
            confirmCommit: 'Are you sure you want to proceed with the commit above?',
        },
        types: [
            { value: 'feat', name: 'feat:     ✨  A new feature', emoji: ':sparkles:' },
            { value: 'fix', name: 'fix:      🐛  A bug fix', emoji: ':bug:' },
            { value: 'docs', name: 'docs:     📝  Documentation only changes', emoji: ':memo:' },
            { value: 'style', name: 'style:    💄  Changes that do not affect the meaning of the code', emoji: ':lipstick:' },
            { value: 'refactor', name: 'refactor: ♻️   A code change that neither fixes a bug nor adds a feature', emoji: ':recycle:' },
            { value: 'perf', name: 'perf:     ⚡️  A code change that improves performance', emoji: ':zap:' },
            { value: 'test', name: 'test:     ✅  Adding missing tests or correcting existing tests', emoji: ':white_check_mark:' },
            { value: 'build', name: 'build:    📦️   Changes that affect the build system or external dependencies', emoji: ':package:' },
            { value: 'ci', name: 'ci:       🎡  Changes to our CI configuration files and scripts', emoji: ':ferris_wheel:' },
            { value: 'chore', name: 'chore:    🔨  Other changes that don\'t modify src or test files', emoji: ':hammer:' },
            { value: 'revert', name: 'revert:   ⏪️  Reverts a previous commit', emoji: ':rewind:' },
        ],
        useEmoji: true,
        emojiAlign: 'center',
        useAI: false,
        aiNumber: 1,
        themeColorCode: '',
        scopes: [],
        allowCustomScopes: true,
        allowEmptyScopes: true,
        customScopesAlign: 'bottom',
        customScopesAlias: 'custom',
        emptyScopesAlias: 'empty',
        upperCaseSubject: false,
        markBreakingChangeMode: false,
        allowBreakingChanges: ['feat', 'fix'],
        breaklineNumber: 100,
        breaklineChar: '|',
        skipQuestions: [],
        issuePrefixes: [{ value: 'closed', name: 'closed:   ISSUES has been processed' }],
        customIssuePrefixAlign: 'top',
        emptyIssuePrefixAlias: 'skip',
        customIssuePrefixAlias: 'custom',
        allowCustomIssuePrefix: true,
        allowEmptyIssuePrefix: true,
        confirmColorize: true,
        scopeOverrides: undefined,
        defaultBody: '',
        defaultIssues: '',
        defaultScope: '',
        defaultSubject: '',
    },
})
```

しかし、初期設定のままだと絵文字ではなく文字として表示されてしまいます。
(✨が `:sparkles:`になっている)

![cz-git emoji](/images/cz-git/cz-git-emoji1.png)

以下のように`emoji`の部分を変更すると、コミットメッセージにも絵文字が反映されます。

```diff js:~/commitlint.config.js
const { defineConfig } = require("cz-git");

module.exports = defineConfig({
  rules: {
    // @see: https://commitlint.js.org/#/reference-rules
  },
  prompt: {
    alias: { fd: "docs: fix typos" },
    messages: {
      type: "Select the type of change that you're committing:",
      scope: "Denote the SCOPE of this change (optional):",
      customScope: "Denote the SCOPE of this change:",
      subject: "Write a SHORT, IMPERATIVE tense description of the change:\n",
      body: 'Provide a LONGER description of the change (optional). Use "|" to break new line:\n',
      breaking:
        'List any BREAKING CHANGES (optional). Use "|" to break new line:\n',
      footerPrefixesSelect:
        "Select the ISSUES type of changeList by this change (optional):",
      customFooterPrefix: "Input ISSUES prefix:",
      footer: "List any ISSUES by this change. E.g.: #31, #34:\n",
      generatingByAI: "Generating your AI commit subject...",
      generatedSelectByAI: "Select suitable subject by AI generated:",
      confirmCommit: "Are you sure you want to proceed with the commit above?",
    },
    types: [
      {
        value: "feat",
        name: "feat:     ✨  A new feature",
        emoji: "✨",
      },
      { value: "fix", name: "fix:      🐛  A bug fix", emoji: "🐛" },
      {
        value: "docs",
        name: "docs:     📝  Documentation only changes",
        emoji: "📝",
      },
      {
        value: "style",
        name: "style:    💄  Changes that do not affect the meaning of the code",
        emoji: "💄",
      },
      {
        value: "refactor",
        name: "refactor: ♻️   A code change that neither fixes a bug nor adds a feature",
        emoji: "♻️",
      },
      {
        value: "perf",
        name: "perf:     ⚡️  A code change that improves performance",
        emoji: "⚡️",
      },
      {
        value: "test",
        name: "test:     ✅  Adding missing tests or correcting existing tests",
        emoji: "✅",
      },
      {
        value: "build",
        name: "build:    📦️   Changes that affect the build system or external dependencies",
        emoji: "📦️",
      },
      {
        value: "ci",
        name: "ci:       🎡  Changes to our CI configuration files and scripts",
        emoji: "🎡",
      },
      {
        value: "chore",
        name: "chore:    🔨  Other changes that don't modify src or test files",
        emoji: "🔨",
      },
      {
        value: "revert",
        name: "revert:   ⏪️  Reverts a previous commit",
        emoji: "⏪️",
      },
    ],
    useEmoji: true,
    emojiAlign: "center",
    useAI: false,
    aiNumber: 1,
    themeColorCode: "",
    scopes: [],
    allowCustomScopes: true,
    allowEmptyScopes: true,
    customScopesAlign: "bottom",
    customScopesAlias: "custom",
    emptyScopesAlias: "empty",
    upperCaseSubject: false,
    markBreakingChangeMode: false,
    allowBreakingChanges: ["feat", "fix"],
    breaklineNumber: 100,
    breaklineChar: "|",
    skipQuestions: [],
    issuePrefixes: [
      { value: "closed", name: "closed:   ISSUES has been processed" },
    ],
    customIssuePrefixAlign: "top",
    emptyIssuePrefixAlias: "skip",
    customIssuePrefixAlias: "custom",
    allowCustomIssuePrefix: true,
    allowEmptyIssuePrefix: true,
    confirmColorize: true,
    scopeOverrides: undefined,
    defaultBody: "",
    defaultIssues: "",
    defaultScope: "",
    defaultSubject: "",
  },
});
```

![cz-git emoji](/images/cz-git/cz-git-emoji2.png)

---

## AIにコミットメッセージを書いてもらう

AIにコミットメッセージを書いてもらいたい場合は、以下のコマンドでトークン情報を設定することができます。

> 対応しているモデル: <https://cz-git.qbb.sh/recipes/openai>

[GitHub Models](https://docs.github.com/ja/github-models)を使用する場合は以下のコマンドで設定できます。

```sh
czg --api-key="ghp_xxxxxx" --api-endpoint="https://models.inference.ai.azure.com" --api-model="gpt-4o-mini"
```

api-keyは以下のページから作成できます。

<https://github.com/settings/tokens>

コマンドを実行すると、`~/.config/.czrc`というファイルが作成されます。

```json:~/.config/.czrc
{
  "openAIToken": "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "apiEndpoint": "https://models.inference.ai.azure.com",
  "apiModel": "gpt-4o-mini"
}
```

このファイルはトークン情報を含んでいるため、dotfiles を育てている方は必ず`.gitignore`に追加しましょう。

```diff text:.gitignore
+ diff .config/.czrc
```

## Lazygitから実行できるように設定する

[Lazygit](https://github.com/jesseduffield/lazygit)から実行できるように設定しておくと幸せになれます。

```config:~/.config/lazygit/config.yml
# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md

customCommands:
  - command: czg
    context: files
    subprocess: true
    key: c
  - command: czg ai
    context: files
    subprocess: true
    key: C
```

設定するとこんな感じでNeovimから出ることなくコミットできるので楽ちんですね🙌

![czg lazygit](/images/cz-git/czg-lazygit.gif)

---

## おわりに

**cz-git** はいいぞ
