---
title: "aws cliの設定方法"
emoji: "🐙"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [aws,cli,awscli]
published: false
---
## aws cliとは
CLIからAWSのリソースを操作したい時に使用するもの
これによりawsのコマンドを使用することができる

awsコマンド例
```bash
aws s3 ls
```
使用するにはAWSのアクセスキーID、シークレットアクセスキーを設定する必要がある


## aws cliのインストール

インストール
```bash
$ curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
$ sudo installer -pkg ./AWSCLIV2.pkg -target /
```

インストールされているか確認

```bash
$ aws --version

# 実行結果
aws-cli/2.7.2 Python/3.9.11 Darwin/21.6.0 exe/x86_64 prompt/off
```

[AWS CLI の最新バージョンを使用してインストールまたは更新を行う - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html)

---

## 接続情報の設定

### デフォルトで使用する情報の場合

```bash
aws configure
```

### デフォルトで使用しあているものとは別で設定する場合

```bash
aws configure --profile プロファイル名
```

上記を実行すると、`~/.aws/config`と`~/.aws/credentials`にその内容が追加される

- `~/.aws/config`の内容
    
    リージョンが書き込まれる
    
    ```bash
    $ cat ~/.aws/config
    
    [default] #プロファイル名
    region = ap-northeast-1
    [test] #プロファイル名
    region = ap-northeast-1
    ```
    
- `~/.aws/credentials`の内容
    
    アクセスキーIDとシークレットアクセスキーが書き込まれる
    
    ```bash
    $ cat ~/.aws/credentials 
    
    [default] #プロファイル名
    aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
    aws_secret_access_key = BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
    
    [test] #プロファイル名
    aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
    aws_secret_access_key = BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
    ```
    

## 設定の切替

### 使用中の設定確認

```bash
aws configure list
```

![alt aws configure list](/images/aws-cli-aws-configure-list.png)

### プロファイルの切替

環境変数`AWS_DEFAULT_PROFILE`にエクスポートするとプロファイルを切り替えることができる

```bash
export AWS_DEFAULT_PROFILE=プロファイル名
```

- 例
    
    ```bash
    export AWS_DEFAULT_PROFILE=prod
    ```
    
    ![alt プロファイルの切替](/images/aws-cli-aws-default-profile.png)
    

### コマンド実行時のみプロファイルを切替

```bash
aws s3 ls --profile プロファイル名
```

## AWS_DEFAULT_PROFILEとAWS_PROFILEの違い

使用するプロファイルの管理は下記の環境変数で行われる

- **AWS_DEFAULT_PROFILE**
- **AWS_PROFILE**

両方の環境変数にプロファイルを設定した場合、`AWS_DEFAULT_PROFILE`が優先される

📌 プロファイルは**AWS_DEFAULT_PROFILE**に設定するのがおすすめ
