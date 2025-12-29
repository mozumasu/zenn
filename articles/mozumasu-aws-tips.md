---
title: "ターミナルで攻略するAWS Tips集"
emoji: "🌩️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [aws, awscli]
published: true
---

:::message

この記事は[ミライトデザイン Advent Calendar 2025](https://qiita.com/advent-calendar/2025/miraito-inc)の17日目です。

:::

## はじめに

AWSを使う上で知っておくと便利なTipsを紹介します。
知っておくと日頃の業務がちょっと楽になる...かも?

## AWS CLI の補完

AWS CLIはコンソールでの作業を自動化するのに便利です。
コンソールよりもターミナルでの入力の方が[vimやemacsなどのキーバインドを使える](https://zenn.dev/mozumasu/articles/mozumasu-cli-beginner)ため設定値の入力に疲弊することもありません。

しかし、コマンドが多く使うハードルが高いという問題があります。
そこでコマンドやオプション、引数などをfzfで補完する方法を紹介します。

### 公式のAWS CLI補完

まずは公式の補完を使ってみましょう。
`~/.aws/config`ファイル に `cli_auto_prompt` を設定すると、コマンド実行時に対話的に補完を行うことができます。

```diff config:~/.aws/config
[profile Sandbox]
sso_session=Sandbox
sso_account_id=123456789012
sso_role_name=HogeRole
region=ap-northeast-1
+ cli_auto_prompt=on-partial
```

| 設定値 | 説明 |
| --- | --- |
| `on` | 常に対話形式の補完を有効にする |
| `on-partial` | 不完全なコマンド（サブコマンドが未指定など）の場合のみ補完を有効にする |

`aws`コマンドを入力した後に、Enterを押すと対話形式の補完が始まります。

![AWS公式の対話形式の補完](/images/aws-tips/aws-comp.gif)

@[card](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-usage-parameters-prompting.html)

一件落着! と思われますがこの方法には課題があります。

- [edit-command-line](https://dev.classmethod.jp/articles/eetann-zle-edit-command-line/) や [autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) が使えない
- コマンドが履歴に残らない (↑↓で履歴を辿れない)
- オプションの入力の途中で補完が欲しくなる
  (`cli_auto_prompt=on`で途中から補完することもできるが、毎回Enterを+1回押す必要があり面倒)
- すべてのリソースの補完がでるわけではない
- リソース一覧は環境変数`AWS_PROFILE` が設定されているか、カーソル位置より前に `--profile` オプションがある場合にのみ
  --profileが一番後ろにある場合は補完されない
- すべてのプロファイルの設定に`cli_auto_prompt`を追加する必要がある

これらの課題を解決するために、zeno.zshを使った補完方法を紹介します。

### zeno.zshでAWS CLI補完

zeno.zshというzsh/fishのプラグインであれば、スニペット + fzf補完で快適に操作できます。
動作イメージは以下の通りです。

![zeno.zsh AWSのスニペットとfzf補完](/images/aws-tips/zeno-demo.gif)

1. `ssm;<スペース>`で `aws ssm start-session --target {{InstanceId}} --profile {{aws-profile}}` のスニペットが展開される
2. `Control + X → Control + F` で2つ目のプレースホルダ `{{aws-profile}}` に移動する
3. --profile の後にTabを押してプロファイル名をfzf補完する
4. --target の後にTabを押してインスタンスIDをfzf補完する
   ※ ここではプロファイルに応じたインスタンスIDが表示される

詳しい使い方は以下の記事が参考になります。
@[card](https://eiji.page/blog/zeno-zsh-intro/)

`~/.config/zeno/aws.yml` で以下の内容の設定ファイルを作成します。
zenoの設定ファイルは`snippets`と`completions`の2つのセクションで構成されます。

- snippetsセクション: スニペット定義
- completionsセクション: 補完を定義

```yaml:~/.config/zeno/aws.yml
snippets:
  - keyword: ssm;
    snippet: aws ssm start-session --target {{InstanceId}} --profile {{aws-profile}}

completions:
  - name: aws cli completer
    patterns:
      - '^\s*aws(?:$|\s.*)$'
    sourceCommand: 'COMP_LINE="${LBUFFER}${RBUFFER}" COMP_POINT=${#LBUFFER} aws_completer 2>/dev/null'
    options:
      --prompt: "'aws > '"
```

snippets で定義されている `{{...}}` はプレースホルダーと呼ばれ、スニペット展開後のカーソル位置になります。
次のプレースホルダーへ移動するキーバインドは明示的に設定する必要があります。

```diff sh:~/.zshrc
+ # zeno.zshで次のプレースホルダーへ移動するキーバインド
+ bindkey '^x^f' zeno-snippet-next-placeholder
```

:::message

zeno.zshの設定が反映されない場合

新しいセッションを開くと設定が反映されます。
新しいタブを開いて確認しましょう。

:::

completionsセクションでは、`patterns` で補完を有効にする条件を指定し、`sourceCommand` で補完候補を生成するコマンドを設定します。

`sourceCommand` では、カーソル位置とコマンドライン全体を AWS CLI の補完プログラム [aws_completer](https://docs.aws.amazon.com/ja_jp/cli/v1/userguide/cli-configure-completion.html) に渡して、補完候補を取得するように設定します。

```bash:sourceCommandの中身
COMP_LINE="${LBUFFER}${RBUFFER}"  # 現在のコマンドライン全体を設定
COMP_POINT=${#LBUFFER}            # カーソル位置（左側の文字数）を設定
aws_completer 2>/dev/null         # AWS公式の補完コマンドを実行
```

:::details LBUFFERとRBUFFERについて

`LBUFFER` と `RBUFFER` は zsh の ZLE（Zsh Line Editor）で使用できる特殊変数です。

| 変数 | 説明 |
| --- | --- |
| `LBUFFER` | カーソルより**左側**の文字列 |
| `RBUFFER` | カーソルより**右側**の文字列 |

これらを連結することで、現在のコマンドライン全文を取得できます。

```bash
# 例: "aws s3 ls" と入力し、カーソルが "s3" の後ろにある場合
#     aws s3| ls
#          ↑カーソル位置
LBUFFER="aws s3"  # カーソル左側
RBUFFER=" ls"     # カーソル右側
```

以下のカスタムウィジェットを `~/.zshrc` に追加すると、`Control + x → Control + x` で現在の `LBUFFER` と `RBUFFER` の値を確認できます。

```zsh:~/.zshrc
# Debug: Show LBUFFER and RBUFFER
function show-buffer() {
  echo "\nLBUFFER: '$LBUFFER'"
  echo "RBUFFER: '$RBUFFER'"
  zle reset-prompt
}
zle -N show-buffer
bindkey '^X^X' show-buffer
```

![LBUFFERとRBUFFERの確認](/images/aws-tips/lbuffer-rbuffer.png =700x)
_show-bufferウィジェットの実行_

@[card](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html)

:::

### オプションが未入力の状態でもprofile補完を有効にする

オプションが未入力の状態だと `--profile` の補完が表示されません。
例: `aws ssm start-session --target --profile[Tab]`

以下のように、`--profile` の補完を追加するとオプションの値が未入力の状態でも補完が表示されるようになります。

```diff yaml:~/.config/zeno/aws.yml
snippets:
  - keyword: ssm;
    snippet: aws ssm start-session --target {{InstanceId}} --profile {{aws-profile}}

completions:
  - name: aws cli completer
    patterns:
      - '^\s*aws(?:$|\s.*)$'
    sourceCommand: 'COMP_LINE="${LBUFFER}${RBUFFER}" COMP_POINT=${#LBUFFER} aws_completer 2>/dev/null'
    options:
      --prompt: "'aws > '"

+ - name: aws profile
+   patterns:
+     - "aws-vault login( .*)? $"
+     - '^aws\b.*--profile(?:(?:=|\s+)([A-Za-z0-9._-]*))?\s*$'
+     - '^\s*AWS_PROFILE=[A-Za-z0-9._-]*$'
+   sourceCommand: "aws configure list-profiles"
```

## シェルのプロンプト部分にAWSプロファイル名を表示する

プロジェクトによっては、環境変数 `AWS_PROFILE` を設定して作業をすることがあったりします。
その場合は現在使用しているプロファイルが分かるように、プロンプト部分に現在の `AWS_PROFILE` の値を表示しておくと便利です。

ここでは [Starship](https://starship.rs/) を使った設定例を紹介します。

AWSモジュールを有効にして、プロンプトにプロファイル名を表示するには以下のように設定します。

```diff toml:~/.config/starship.toml
+ # AWS module
+ [aws]
+ format = '[$symbol $profile ]($style)'
+ symbol = "💭"
+ style = "bold fg:#ffcb6b"
```

formatに `$aws` を追加してプロンプトに表示します。

```diff toml:~/.config/starship.toml
# formatに$awsを追加してプロンプトに表示
format = """
$directory\
$git_branch\
$git_status\
+ $aws\
\n$character\
"""
```

全体の設定ファイルは以下にあります。
<!-- markdownlint-disable-next-line MD034 -->
https://github.com/mozumasu/dotfiles/blob/wezterm/.config/starship.toml

`AWS_PROFILE` が設定されている場合、プロンプトにプロファイル名が表示されます。

```sh
# プロファイルを設定
export AWS_PROFILE=Sandbox

# プロンプトに「💭 Sandbox」と表示される
```

![プロンプトにAWSプロファイル名を表示](/images/aws-tips/starship-aws-profile.png =700x)

@[card](https://starship.rs/config/#aws)

## プロファイル指定でコンソールを開く: aws-vault

AWSのコンソールのURLをブックマークで管理してアクセスするのは面倒です。
そこでオススメなのが `aws-vault` コマンドを使ってプロファイル指定でコンソールを開く方法です。

```sh
# 指定したプロファイルでAWSコンソールを開く
aws-vault login <プロファイル名>
```

@[card](https://github.com/99designs/aws-vault)

```sh
# aws-vaultのインストール
brew install --cask aws-vault
```

aws-vault addでプロファイルの認証情報をキーチェーンに保存して使用します。

```sh
# aws-vault addでプロファイルの認証情報をキーチェーンに保存
# これでaws-vault login コマンドが使用可能になる
aws-vault add プロファイル名
```

### セッション期限の調整

#### キーチェーンの期限

キーチェーンはデフォルトで5分に1回パスワード入力を求められます。
以下の手順でキーチェーンの期限を変更できます。

```sh
# カスタムキーチェーンを開く
open ~/Library/Keychains/aws-vault.keychain-db
  ```

サイドバーの aws-vault を右クリックして 「キーチェン"aws-vault"の設定を変更…」 をクリックして時間を変更する

![aws-vaultのキーチェーンの期限変更](/images/aws-tips/aws-vault-keychain-duration.png =700x)

#### aws-vaultのセッション期限

`~/.aws/config` の `duration_seconds` でセッション期限を設定できます。

```diff sh:~/.aws/config
# assume role先のアカウント
[profile hoge-app-dev-user]
source_profile=hoge-app-vault
role_arn=arn:aws:iam::123456788990:role/hoge-app-dev-user
region=ap-northeast-1
output=json
+ duration_seconds = 10800  # 3時間
```

##### セッション期限の上限

| ケース | 最大値 |
| --- | --- |
| 通常 | 43200秒（12時間） |
| ロール連鎖（Role Chaining） | 3600秒（1時間） |

ロール連鎖とは、あるロールを引き受けた状態から別のロールを引き受けることです。この場合、`DurationSeconds` に1時間を超える値を指定するとエラーになります。

@[card](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles.html#id_roles_terms-and-concepts)

##### ロール側の制限を確認する

ロール自体に `MaxSessionDuration` が設定されている場合、それを超えるセッション期限は指定できません。

```sh
# ロールの最大セッション期限を確認
aws iam get-role --role-name hoge-app-dev-user --query "Role.MaxSessionDuration"
3600  # 1時間に制限されている
```

制限を超えた値を指定すると、以下のエラーが発生します。

```sh
aws-vault: error: login: operation error STS: AssumeRole, https response error StatusCode: 400, RequestID: 12345678-90ab-cdef-1234-567890abcdef, api error ValidationError: The requested DurationSeconds exceeds the MaxSessionDuration set for this role.
```

> 参考記事
>
> @[card](https://qiita.com/kangaechu/items/cb8f68e3866ee5af71c8)
> @[card](https://blog.microcms.io/aws-vault-introduction/)

## 2FAコードをキーボードで入力する

スマートフォンの認証アプリを開いてコードを確認し、手入力するのは面倒です。

[Raycast](https://www.raycast.com/) の拡張機能「2FA Code Generator」を使うと、キーボードだけで2FAコードを取得・入力できます。

1. Raycastで「2FA」と検索してコードを表示
2. Enterでコードをクリップボードにコピー

スマートフォンを取り出す必要がなくなり、ログインが快適になります。

@[card](https://www.raycast.com/cjdenio/two-factor-authentication-code-generator)

## ARNでリソースページを開く

ARNからリソースページを開きたくなる場面は多くあります。
以下の記事ではブラウザのサイト内検索を使ってARNからリソースページを開く方法が紹介されています。
@[card](https://zenn.dev/thinaticsystem/articles/2e15210d3be34c)

ここでは、ターミナルやNeovimからARNのリソースページを開く方法を紹介します。

### Neovimで選択したARNのページを開く

Neovimにはデフォルトで `gx` というキーマップがあり、カーソル下のURLやファイルパスをOSのデフォルトアプリケーションで開くことができます。

以下の設定では、この `gx` を拡張してARNにも対応させています。ARN上で `gx` を押すと、AWSコンソールの該当リソースページをブラウザで開くことができます。

```lua:~/.config/nvim/lua/keymaps.lua
-- gx: URLまたはAWS ARNをブラウザで開く
keymap("n", "gx", function()
  local cword = vim.fn.expand("<cWORD>")
  local cfile = vim.fn.expand("<cfile>")
  -- 引用符で囲まれたARNを抽出 (e.g., "arn:...", `arn:...`)
  local arn = cword:match("[\"`']?(arn:aws[a-z%-]*:[^\"`'%s]+)[\"`']?")
  if arn then
    vim.ui.open("https://console.aws.amazon.com/go/view?arn=" .. arn)
  else
    vim.ui.open(cfile)
  end
end, { desc = "Open URL or AWS ARN" })
```

`vim.fn.expand("<cWORD>")` でカーソル位置の空白区切りの単語を取得し、Luaのパターンマッチ `cword:match()` でARNを抽出しています。
ARNが見つかった場合は `vim.ui.open()` でブラウザを開きます。
この関数はOSに応じて適切なコマンド（macOSなら `open`、Linuxなら `xdg-open`）を使用するため、クロスプラットフォームで動作します。

### WezTermで選択したARNのページを開く

`Leader + a` を押すと、画面内のARNがハイライトされ、選択するとAWSコンソール開く設定は以下のようになります。

```lua:~/.config/wezterm/keymaps.lua
keys = {
  -- AWS ARN を Quick Select してブラウザで開く
  {
    key = "a",
    mods = "LEADER",
    action = wezterm.action.QuickSelectArgs({
      label = "open aws console",
      patterns = {
        -- ARNパターン: arn:partition:service:region:account-id:resource
        "\\barn:[\\w\\-]+:[\\w\\-]+:[\\w\\-]*:[0-9]*:[\\w\\-/:=.]+",
      },
      action = wezterm.action_callback(function(window, pane)
        local arn = window:get_selection_text_for_pane(pane)
        wezterm.log_info("opening AWS console for: " .. arn)
        wezterm.open_with("https://console.aws.amazon.com/go/view?arn=" .. arn)
      end),
    }),
  },
}
```

[QuickSelectArgs](https://wezterm.org/config/lua/keyassignment/QuickSelectArgs.html) は画面内のテキストから指定したパターンにマッチする文字列をハイライト表示し、選択できるアクションです。
`patterns` にARNの正規表現を指定し、`action_callback` で選択後の処理を定義しています。
選択されたARNは `window:get_selection_text_for_pane()` で取得し、`wezterm.open_with()` でブラウザを開くことができます。

## おわりに

本記事では、AWS CLIをより快適に使うためのTipsを紹介しました。

- **zeno.zsh** によるfzf補完でコマンド入力を効率化
- **Starship** でプロンプトにAWSプロファイルを表示
- **aws-vault** でセキュアにプロファイルを管理
- **Raycast** で2FAコードをキーボードから入力
- **Neovim / WezTerm** からARNのリソースページを直接開く

これらの設定を組み合わせることで、AWS CLIでの作業が格段に快適になります。
ぜひ試してみてください。
