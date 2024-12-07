---
title: "楽しいインフラエンジニア入門"
emoji: "🍣"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: [tips]
published: true
---

:::message
この記事は[ミライトデザイン Advent Calendar 2024](https://qiita.com/advent-calendar/2024/miraito-inc)の7日目です。
6日目は[yuki](https://zenn.dev/yyykms123)さんの「キュメント作成で意識しているポイントとフレームワークの活用」という記事でした。
:::

@[card](https://zenn.dev/yyykms123/articles/2024-12-06-documentation-tips)
[Diátaxis](https://diataxis.fr/) ( ディアタクシス ) フレームワークのカテゴリ分けは、新しくJoinした人がどのドキュメントから読めばいいか？の悩みを解消する上で有効だなと思いました。
早速取り入れてプロジェクトのドキュメントに秩序をもたらしたいところ...。

## はじめに

インフラエンジニア (enjoy勢) になって4ヶ月くらい経ちました。
振り返りもかねて、知っておいて良かったものを紹介していきます。
インフラ興味あるけどなにからしようかな〜って人向けです。

## キャッチアップ方法

学ぶことが最初はとにかく多いので、無難にキャッチアップする方法を紹介します。

### Mapify

インフラエンジニアになって公式ドキュメントを読むことが増えました。
特にAWSは公式ドキュメントが情報が過不足なく記載されている点で最強の情報源だと思います。

ただ、いきなり読みこむのは大変なので、まずは[Mapify](https://mapify.so/ja)で概要を掴むようにしています。
Mapifyとは、与えられた情報を元にマインドマップを作成してくれるツールです。

![Mapify](/images/infra-beginner/mapify.png)

Mapifyのメリット

- 別言語のコンテンツも日本語にして作成するため、キャッチアップが楽になる
- 全体像を把握できる

オススメの使い方

- 海外エンジニアの環境構築の動画
- 公式ドキュメント

最初に知識全体の骨組みを用意すると情報も頭に入ってきやすくてオススメです。

また、項目ごとに動画のリンクも貼ってくれるので、気になる項目があればすぐに動画を見ることができます。

![maindmap](/images/infra-beginner/maindmap.png)

見た目もかなりカスタマイズできます。タイムライン表示は可愛いですね。
![timeline](/images/infra-beginner/timeline.png)
:::message

ブラックフライデー中で、年契約だと50%オフになります。
最初の3日間は無料で使えるのでぜひ試していただきたいです。

:::

### ChatGPTとFeloの二刀流

概要を掴んだらあとは詳細を知りたいですよね。
そんな時はFeloとChatGPTの二刀流がオススメです。

### Felo

Feloは日本のスタートアップ会社によって開発されたAI検索エンジンです。
2024年1月にリリースされ、現在は無料枠も利用できます。

一番感動したのは、やり取りを元にアウトラインの作成からスライド作成までを自動で作成する機能です。
もちろんアウトラインとレイアウトの調整は自分で行うこともできます。
![make_slide](/images/infra-beginner/make_slides.gif)

簡単なマインドマップも作成できます。
![felo_mindmap](/images/infra-beginner/felo_mindmap.png)

回答に次の質問の提案までしてくれるため、簡単に知識の幅を広げることができます。
![felo_question](/images/infra-beginner/felo_question.png)

メリット

- 回答の元になった情報源を提示してくれる
- 簡単なマインドマップを作成できる
- 回答とその情報源をNotionに保存できる
- Canvaと連携しているため、アウトラインを元にスライドを作成できる
- 質問の提案もしてくれる
- UIが綺麗

デメリット

- 画像の質問ができない
- ChatGPTほど前後の質問を考慮した回答ができない

これらのデメリット部分を解決するためにChatGPTを使用しています。

要把握ならFelo、詳細な質問ならChatGPT
みたいな使い方が好きですね。

あとはVPN使用時にChatGPTのレスポンスが遅い時にFeloを使うこともあります。

### 英語が苦手な人向けブラウザ拡張機能

英語が苦手な人は以下のツールで翻訳できるようにすると捗ります。

選択行を翻訳するなら
@[card](https://chromewebstore.google.com/detail/mouse-tooltip-translator/hmigninkgibhdckiaphhmbgcghochdjc)
カーソル位置の単語の意味を調べるなら
@[card](https://chromewebstore.google.com/detail/mouse-dictionary/dnclbikcihnpjohihfcmmldgkjnebgnj)

## dotfiles育成

学習のためのモチベーションを高めるために作業環境のカスタマイズがオススメです。
最初は真っ黒なターミナルの画面が怖かったのですが、カスタマイズを始めてからというものCUIがないと生きられない体になりました。
カスタマイズするにあたり、気軽に設定ができるようにdotfilesを始めましょう。

dotfileとは、.zshrcや.vimrcなどの設定ファイルのことです。
これらを管理するGitHubリポジトリをdotfilesリポジトリと呼びます。
@[card](https://github.com/mozumasu/dotfiles)

設定ファイルをコード管理しておくことで、別の端末で作業する時も環境構築がすぐにできるようになります。
また、設定の切り戻しも用意なため、カスタマイズへのハードルを下げることができます。

### Brewfileを管理しよう

Brewfileとは、Homebrewでインストールしたパッケージのリストを記述したファイルです。
新しいPCに移行する際にはBrewfileを元にパッケージをインストールすることができます。

以下のコマンドで、現在インストールしているパッケージをBrewfileに書き出すことができます。

```sh
brew bundle dump
```

すでに現在いるディレクトリにBrewfileが作成されている場合は`--force`オプションをつけると上書きすることができます。

```sh
brew bundle dump --force
```

### 設定 = 呼吸

dotfilesを育てるコツは、設定ファイルを爆速に開けるようにすることです。
設定ファイルは10秒以内で開けるようにしましょう。

以下の例では`z`コマンドでdotfilesディレクトリに移動した後、`fzf`で設定ファイル指定して開いています。
![open_dotfiles](/images/infra-beginner/open_dotfiles.gif)

- fzf (ファジーファインダー)
  ファジーファインダーとは、入力した文字列に対して部分一致で検索を行う機能です。
  ファイルの指定やhistoryの検索などで便利です。
  @[card](https://github.com/junegunn/fzf)

- zoxide
  zoxideはディレクトリの移動を履歴を元に瞬時に行うことができるツールです。
  `z [ディレクトリ名の一部]`で一度移動したディレクトリに瞬時に移動することができます。
  @[card](https://github.com/ajeetdsouza/zoxide)

インストール方法は以下の通りです。

```sh
brew install fzf     # ファジーファインダー: 曖昧検索して選択
brew install zoxide  # ディレクトリ移動の履歴を保存・移動
```

### ターミナルのカスタマイズ

ターミナルがかっこいいと勉強がはかどります。
モチベーションは下がることを知りません。ソースは私です。(n=1)

実はターミナルのカスタマイズはそこまで難しくないのでぜひ試してみて欲しいです。
以下の記事ではマルチプラットフォームで使えるWeztermのカスタマイズ方法を紹介しています。
@[card](https://zenn.dev/mozumasu/articles/mozumasu-wezterm-customization)

Macユーザーであれば、デフォルトで便利機能があるWarpもオススメです。
@[card](https://www.warp.dev/)

### シェルのカスタマイズ

shellは特にこだわりがないのであれば多機能で情報も豊富なzshがオススメです。
zshはCIやサーバー環境で使われるbashの拡張版なので、bashでできることはzshでもできます。

zshは以下の書籍がオススメです。試しに最初の章だけでも読んでいただきたいです。
沼が待っている。

> [zshの本 (エッセンシャルソフトウェアガイドブック)](https://amzn.asia/d/cTc1nEm)

### zshの設定ファイル

zshの設定は以下の2つのディレクトリで管理されています。

- /etc
- ~(ホームディレクトリ)

/etc配下のディレクトリはシステム全体の設定ファイルを管理するディレクトリです。
ユーザーの設定はホームディレクトリにあるファイルで行います。
そのため、基本的には~にある設定ファイルを編集します。

管理するファイル以下の3つで行います。

- ~/.zshenv
- ~/.zshrc
- ~/.zshprofile

#### ~/.zshenv

~/.zshenvは、Zshが起動するたびに必ず読み込まれる設定ファイルです。
ログインシェル、インタラクティブシェル、シェルスクリプトのいずれの場合でも適用されます。

以下のものを設定する時に使用します。

- 環境変数(例: `$PATH`、`$EDITOR`、`$LANG`)
- リモートホストから直接する起動する可能性があるコマンド関連の設定
- 上記の設定が参照する環境変数など(例: `cvs`, `rsync`のための変数)

#### ~/.zshrc

~/.zshrcは、インタラクティブシェルが起動するたびに読み込まれる設定ファイルです。
新しいターミナルセッションを開始するたびに実行されます。

以下のものを設定する時に使用します。

- エイリアスの設定
- コマンドの履歴管理
- シェルのオプション
- 補完機能の設定

このファイルは肥大化しがちなので、このファイルをさらに分割して管理する人が多い印象があります。

#### ~/.zlogin

~/.zprofileは、ログインシェルが起動したときに読み込まれる設定ファイルです。

以下のものを設定する時に使用します。

- 特定のプログラムを起動するための設定
- ユーザー固有の環境変数

#### 設定の反映

設定が終わったら反映も忘れずに😉

```sh
exec $SHELL -l
```

特定のファイルのみ反映したい場合は`source`コマンドを使用します。

```sh
source ~/.zshrc
```

### エイリアスの設定

とにかくいろんなコマンドを打ちまくるのでエイリアス登録は必須です。
自分はこんな感じで設定しています。

```sh: ~/.zshrc
abbr -S -qq ll='ls -l'
abbr -S -qq la='ls -A'
abbr -S -qq f='open .'
```

エイリアスの設定ですが自分は以下の2通りで設定しています。

```sh: ~/.zshrc
# 入力後にスペースを入力したり、コマンド実行すると元のコマンドが表示される (Zshの独自機能)
abbr -S -qq ll='ls -l'
# 元のコマンドを表示しない
alias ggrks='google'
```

関数のエイリアスを設定する場合はalias、コマンドのエイリアスを設定する場合はabbrを使います。
ggrksは元のコマンドを表示したいくないのでaliasを使っています。

@[card](https://qiita.com/ucan-lab/items/1794940a64882021dcb1)

## Linuxの知識

Linuxの知識があると、CLI生活が豊かになります。
CLIなにそれ？な方は以下の本がオススメです。
コマンドを試す環境はmultipassで用意するのがオススメです。

[1週間でLPICの基礎が学べる本 第3版 (1週間シリーズ)](https://amzn.asia/d/7N67HUa)

![1週間でLPICの基礎が学べる本 第3版 (1週間シリーズ)](https://m.media-amazon.com/images/I/813OJFwYWOL._SY522_.jpg)

さらに知識を深めたい方は以下の書籍を手元においておくことをお勧めします。

[Linux教科書 LPICレベル1 Version5.0対応](https://amzn.asia/d/5XlIceF)
![Linux教科書 LPICレベル1 Version5.0対応](https://m.media-amazon.com/images/I/51jRzpjTFZL._SY445_SX342_.jpg)

情報量に圧倒されてしまいそうですが、大切なことは自分が何を知らないのかを知っておくことです。
課題に直面した時にどの情報を参照すればいいかがわかるようになります。

## サーバーの接続情報管理 ~/.ssh/config

案件を掛け持ちしている関係で、環境変数やらssh接続先の情報やらの管理が煩雑です。
ホスト名とか使用している鍵とかとにかく覚えられない、というかもう覚えてない。

そんなあなたにお勧めしたいのが`~/.ssh/config`です。

通常の方法でssh接続するときには以下のようなコマンドを入力します。

```sh
ssh -i ~/.ssh/秘密鍵 -p 22 user@hostname
```

毎回これを打つのは面倒です。そこで`~/.ssh/config`の出番です。
フォーマットは以下の通りです。

```config
HOST エイリアス
  HOSTNAME 接続先のIPアドレス
  User 接続するユーザー名
  Port 22
  IdentityFile 秘密鍵のパス(例: ~/.ssh/hoge_key)
```

例えば以下のように設定すると、`ssh HOSTの文字列`で接続することができます。

```config: ~/.ssh/config
HOST __hoge_prod
  HOSTNAME 192.168.64.7
  User ec2-user
  Port 22
  IdentityFile ~/.ssh/id_ed25519
```

```sh
# エイリアスのみで接続できる
ssh __hoge_prod
```

どのホストがどの鍵で接続できるのか、対応するユーザー名はどれかを覚えていなくてもエイリアス指定で接続できるため楽です。

### ~/.ssh/configを分割して管理する

接続先の数が増えていくと一つのファイルで管理するのが辛くなります。
そのため、案件やプロダクトごとにファイルを分割して管理するといいです。
以下のようにファイルを分割するとします。

この場合、`~/.ssh/config.d/hosts`ディレクトリを作成して、その中にホストごとのファイルを作成します。
~/.ssh/configには以下のように記述します。

```config
Include conf.d/hosts/*
```

## AWS profileの管理

AWSのリソースをCLIやIaCで操作する場合、AWS profileを使うことが多いです。
誤って別のAWS profileを使ってしまってterraform applyしちゃった！なんて悲劇を起こさないためにも、AWS profileの管理は重要です。

上記のような悲劇を防ぐ方法として自分は以下のようにしています。

- aws profileのdefaultは使わない
- terraformを実行する前に `aws configure list` で使うprofileを確認する

また、AWS profileの切り替えはfzfで選択できるように設定しておくと便利です。

:::details AWS profileの切り替えの設定

```sh: ~/.zshrc
# fzfでawsプロファイル変更
alias awsp=set_aws_profile

function set_aws_profile() {
  local selected_profile=$(aws configure list-profiles |
    grep -v "default" |
    sort |
    fzf --prompt "Select PROFILE. If press Ctrl-C, unset PROFILE. > " \
        --height 50% --layout=reverse --border --preview-window 'right:50%' \
        --preview "grep {} -A5 ~/.aws/config")

  # プロファイルが選択されていない時は設定を解除する
  if [ -z "$selected_profile" ]; then
    echo "Unset aws profile!"
    unset AWS_PROFILE
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    return
  fi

  # 選択されたプロファイルに設定
  echo "Set the environment variable 'AWS_PROFILE' to '${selected_profile}'!"
  export AWS_PROFILE="$selected_profile"
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY

  # ssoのセッションを確認し、期限切れの場合は再度ログイン
  local AWS_SSO_SESSION_NAME="mozumasu"

  check_sso_session=$(aws sts get-caller-identity 2>&1)
  if [[ "$check_sso_session" == *"Token has expired"* ]]; then
    echo -e "\n----------------------------\nYour Session has expired! Please login...\n----------------------------\n"
    aws sso login --sso-session "${AWS_SSO_SESSION_NAME}"
    aws sts get-caller-identity
  else
    echo ${check_sso_session}
  fi
}
```

:::

関数は以下の記事のものを使用させていただいています。

@[card](https://tech.innovator.jp.net/entry/2023/06/07/150346)

### セキュリティへの理解

AWSのリソースを操作するにあたり、権限エラーが発生することがあります。
どの権限が必要なのか？どのポリシーで引っかかっているのか？を理解して必要な権限を先方に依頼する必要があります。

セキュリティはこちらが参考になります。
@[card](https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/security-pillar/permissions-management.html)

ぜひMapifyを使ってマインドマップを作成して権限を理解してみてください。

## VM

VMを用意する方法としてよくみるのは以下の2つです。

- Vagrant + VirtualBox (Apple Siliconでは使えない)
- multipass

VirtualBoxは最新バージョンでApple Siliconに対応したものの、Vagrantは最新のVirtualBoxに対応していないため、Apple SiliconでのVM構築は難しいです。
multipassでは、Ubuntuのみにはなりますが、Apple SiliconでもVMを構築することができます。

## IaC

IaC（Infrastructure as Code）とは、インフラをコードで管理することです。
何となくでTerraformを触っていたのですが、実務で使う時がきました。

Terraformの学習は以下の本がオススメです。

[実践Terraform　AWSにおけるシステム設計とベストプラクティス](https://amzn.asia/d/dfg5FiU)
![実践Terraform　AWSにおけるシステム設計とベストプラクティス](https://m.media-amazon.com/images/I/81qkEHKXdyL._SY522_.jpg)

人生何があるかわからないので、色々触っておくもんですね。

自分は以下の場面で使うことがありました。

- Apple SiliconでのVM構築に制限がある
- 働いている時だけサーバーを立てて検証したい

実際にIaCを使ってみて感じたメリットは以下の通りです。

- 必要な時にコマンドで作成/削除ができるため、検証にかかる費用を抑えられる
- 自分が万が一何かやらかしたとしても、すぐに再構築できるため心理的ハードルが下がる
- コード化されているため、grepしてすぐに設定内容を確認できる
- 一行帰るだけでサーバーで使用するLinuxのディストリビューションを変更できる

自分の試したいディストリビューションのサーバーを用意できるのは感動ものです。

IaCといえばTerraform, CDK, Ansibleなど色々あります。
自分はTerraformでクラウドのリソースを管理し、アプリケーションの管理をAnsibleで行なっています。

## Vim / Neovim

カスタマイズが面白すぎて沼なのでお勧めしたい気持ちとやめた方がいいじゃないかという葛藤があります。
とはいえ自分はやって良かったなと思っているので共有します。
サーバー内で一時的に設定ファイルを書き換えて動作検証を行うことがあるのでvimの基本操作を知っておくと便利です。

Vimの操作を覚えるためにやったことは以下の通りです。

- vimtutorをやる
  vimtutorって打てばできます。実際に操作しながらできるのでおすすめです。
- ブラウザをVim風にする
  @[card](https://zenn.dev/mkobayashime/articles/vimium-vim-browser)
- youtubeでVimの動画を見る
  どのキーバインドから覚えていくか悩むと思うのでこの動画から覚えていくといいと思います。
  @[card](https://youtu.be/UP0oV_1Q0Q8?si=XvjPim24D2uHaDWj)

基本的な操作が網羅されており、動画をみながら真似をしたら慣れました。

vimのカスタマイズをするとエディタそのものに詳しくなるため、エディタの機能をフル活用してコーディングを快適にすることができるようになります。
リンターを設定しておけば、間違って指定している値なんかに気づくことができます。
LSPを設定しておけば補完候補でどんな機能があるかを教えてくれます。

知らないことはエディタが助けてくれるため、学習効率をあげることができます。

## トラブルシューティングで使うコマンド

初めのうちはとにかくトラブル続きでトラブルシューティングを行う機会が多くあります。
以下のようなコマンドを覚えておくと原因を特定するのに役立ちます。

- less: ログファイルの確認
- traceroute: ネットワークの経路確認
- dig: DNSの確認
- nc: ポートの確認
- top: リソース使用状況の確認
- free: メモリの確認

@[card](https://qiita.com/takaesu_ug/items/b5cc2a706be8c031043e)

## Docker

要件によってアーキテクチャを見直す機会があるのですが、その際に選択肢の一つとしてコンテナが上がったりすることがあるため、Dockerの知識も必要です。

Dockerについてはインフラ初心者でも読みやすい以下の書籍がオススメです。

> [開発系エンジニアのためのDocker絵とき入門](開発系エンジニアのためのDocker絵とき入門)

### Dockerの起動

Dockerの起動を行うためにDockerデスクトップを使用すると思いますが、じつはCLIでもColimaというツールを使ってDockerを起動することができます。
@[card](https://github.com/abiosoft/colima)

```sh
# Dockerの起動
colima start
# Dockerの停止
colima stop
```

### Dockerの管理や操作

コンテナのプロセスやログの確認にはlazydockerを使用しています。コマンドを都度入力する手間が省けて便利です。
@[card](https://github.com/jesseduffield/lazydocker)
他の選択肢としては[docui](https://github.com/skanehira/docui)や[Oxker](https://github.com/mrjackwills/oxker)などがあります。

```sh
lazydokcer
```

## 終わりに

最初はインフラ向いていないかも！と思っていたのですが、気づいたらインフラが好きになっていました。

明日の[ミライトデザイン Advent Calendar 2024](https://qiita.com/advent-calendar/2024/miraito-inc)の8日目は[tkek321)](https://qiita.com/tkek321)さんの「ギャップロックについて」です。

お楽しみに！🦌
