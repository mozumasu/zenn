---
title: "コミットメッセージはAIに書いてもらう (cz-git)"
emoji: "🐙"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [git, czgit, czg]
published: false
---

## はじめに

[モテるGit管理 (gh, ghq, git-cz, lazygit)](https://zenn.dev/mozumasu/articles/mozumasu-lazy-git)のコメントで **cz-git** を紹介していただいたので試しに使ってみました。
元々はgit-czを使っていたのですが、 AI でコミットメッセージを自動生成できるのが便利でもう手放せません。

cz-gitはこんな感じのことができます。

> - [ ] プレフィックスを選んでコミットメッセージを生成
> - [ ] 絵文字あり/なし を簡単に切り替え
> - [ ] コミットメッセージをAIに生成してもらう

## cz-git とは？

cz-gitとは、対話形式でコミットメッセージをフォーマットに沿って作成することができるツールです。
コミットメッセージのフォーマットは、[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) の元である [Angular のコミットメッセージ標準](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit) に準拠しています。

似たツールとして git-cz や Commitizen がありますが、cz-git はそれらの複雑な依存関係を解決し、より軽量化したものです。

## czg とは？

公式のページを見にいくと、cz-gitの他にczgとやらについて記載があります。
cz-gitは単体では、

### cz-git

コマンドは `cz` または `git cz` で起動する

### czg

cz-git の機能を直接利用できる

コマンドは `czg` または `git czg` で起動する

グローバルでCLIツールとして利用したい場合はこちらを使用する

インストール

```sh
# npmの場合
npm install -g czg cz-git
```

> 参照: [czg | Interactive Commitizen CLI that generate standardized git commit message](https://cz-git.qbb.sh/cli/install)

### cz-git と czg の違い

If you using cz or git cz command will start commitizen CLI + cz-git adapter
If you using czg or git czg command will only start czg CLI

cz: がgit cz起動しますcommitizen+ cz-gitアダプタ
czgまたはコマンドを使用する場合はCLIgit czgのみを起動しますczg

## git-cz との違い

git-czをより軽量化し、パフォーマンスが上げたものです。

サイズの差は以下の通りです

> 148 MB node_modules/git-cz
> 1.9 MB node_modules/cz-git

@[card](https://cz-git.qbb.sh/guide/why)

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

## おわりに

**cz-git** はいいぞ
