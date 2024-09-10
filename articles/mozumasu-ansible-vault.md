---
title: "Ansible Vaultの使い方"
emoji: "🛵"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [ansible]
published: false
---

## Ansible Vaultとは

Ansible Vaultとはパスワードを用いてYAMLファイルを暗号化するためのツールです。
[Ansible](https://docs.ansible.com/ansible/latest/getting_started/introduction.html)でインフラの構成管理をする際に、playbookを実行するのに必要だけどGitHub上で公開したくない機密情報を暗号化するのに使用します。

コマンドは`ansible-vault`を使用します。

> 公式ドキュメント: [Ansible Vault — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/vault.html#)

:::details ansible-vaultのヘルプ

```bash
$ ansible-vault -h

usage: ansible-vault [-h] [--version] [-v]
                     {create,decrypt,edit,view,encrypt,encrypt_string,rekey}
                     ...

encryption/decryption utility for Ansible data files

positional arguments:
  {create,decrypt,edit,view,encrypt,encrypt_string,rekey}
    create              Create new vault encrypted file
    decrypt             Decrypt vault encrypted file
    edit                Edit vault encrypted file
    view                View vault encrypted file
    encrypt             Encrypt YAML file
    encrypt_string      Encrypt a string
    rekey               Re-key a vault encrypted file

options:
  --version             show program's version number, config file location,
                        configured module search path, module location,
                        executable location and exit
  -h, --help            show this help message and exit
  -v, --verbose         Causes Ansible to print more debug messages. Adding
                        multiple -v will increase the verbosity, the builtin
                        plugins currently evaluate up to -vvvvvv. A reasonable
                        level to start is -vvv, connection debugging might
                        require -vvvv. This argument may be specified multiple
                        times.

See 'ansible-vault <command> --help' for more information on a specific
command.
```

:::

## 使い方

### ファイルの内容を暗号化する: encrypt

ファイルの暗号化は以下の手順で行います。

1. 暗号化したいファイルを用意
2. `ansible-vault encrypt`を実行
3. 暗号化や複合化を行うためのパスワードを入力

実際にvaultを試してみましょう。
以下のようなパスワードを定義したファイルを用意します。

```yaml:mysql.yml
mysql_root_password: "バレたら困るパスワード"
```

`ansible-vault encrypt`コマンドで暗号化します。
encryptは暗号化するという意味です。

```bash
ansible-vault encrypt mysql.yml
```

実行するとパスワード入力を求められます。
このパスワードは複合化する際に必要なので忘れないようにしましょう。

パスワードの入力が完了すると以下のようにファイルの内容が暗号化されます。

```yaml:mysql.yml
$ANSIBLE_VAULT;1.1;AES256
65326165333331383032646638323164316232376663303034333533663964356361363133333936
3733623030636533386430343039396161386330336166380a303066613135656430396263383236
33643765653562373364313236646339616262626161663437613932356561363231386137643233
3930326336353235300a396261303161376466613235333030663132346535356332653239663231
34373637363732393865636636353234303734623162323537666137663235633837316437613730
35366566383238383862306237386531316637636430376166323639343265306430363261336135
376665663431663137306531633736663639
```

### 暗号化したファイルの内容を確認する: view

暗号化したファイルの内容を確認するには`ansible-vault view`を使用します。
サクッと中身を確認したい時に使用します。

```bash
ansible-vault view mysql.yml
```

実行すると、下記のようにCLI上にファイルの内容が表示されます。

```bash
$ ansible-vault view mysql.yml
Vault password:
mysql_root_passoword: "バレたら困るパスワード"
```

### 暗号化したファイルの内容を編集する: edit

暗号化したファイルの内容を編集するには`ansible-vault edit`を使用します。
新たに変数を追加したり、変更を加えたい時に使用します。

```bash
ansible-vault edit mysql.yml
```

実行してパスワードを入力するとエディタが起動し、ファイルを編集できるようになります。
保存して終了すると追記した分も自動で暗号化されます。

### ファイルの暗号化をやめる: decrypt

ファイルの暗号化をやめたい場合は `ansible-vault decrypt`を使用します。
decryptは複合化するという意味です。

```bash
ansible-vault decrypt mysql.yml
```

暗号化した際に設定したパスワードを入力すると、以下のようにファイルの内容が複合化されます。

```yaml:mysql.yml
mysql_root_passoword: "バレたら困るパスワード"
```

再度暗号化する場合は`encrypt`でできますが、暗号化された際の値が変更されるため、値を確認する場合は`view` を使用するようにしましょう。

## playbookでの利用

playbookで暗号化したファイルを使用する場合は、`ansible-playbook`コマンドを実行する際に`--ask-vault-pass`オプションを付けて実行します。

```bash
ansible-playbook -i inventory playbook.yml --ask-vault-pass
```

## ansible-vaultのパスワードを自動入力する

検証などで毎回パスワードを入力するのが面倒な場合は、`ansible.cfg`に`vault_password_file`でパスワードを記載したファイルを指定をしておくと自動でパスワードを入力することができます。
Vaultのパスワードを記載したファイル自体を暗号化してplaybookを実行することはできないため、Vaultパスワードを記載したファイルは必ず`.gitignore`に追加してGitの管理対象外にしておきましょう。

### 設定手順

1. ルートディレクトリに`.ansible_vault_password`ファイルを作成

```ini:./.ansible_vault_password
hogehogePassword
```

2. `ansible.cfg`に`vault_password_file`を追記

```diff ini:./ansible.cfg
[defaults]
+ vault_password_file=./.ansible_vault_password
```

3. パスワードを記載したファイルを`.gitignore`に追記

```diff ini:./.gitignore
+ .ansible_vault_password
```

:::message alert
パスワードを記載したファイルを.gitignoreに追加することを忘れないようにしましょう。
誤コミットするとパスワードが漏洩してしまうので注意してください。
:::

### 誤コミット対策

誤コミット対策として、Vaultパスワードを記載したファイルをプロジェクトディレクトリに配置せずに別のディレクトリで管理する方法が有効です。
また、設定ファイルにパスワードファイルのパスを記載したくない場合は以下のように環境変数に設定する方法もあります。

```bash
export ANSIBLE_VAULT_PASSWORD_FILE=/path/to/.ansible_vault_password
```

### Push時にパスワード設定ファイルを検知する

万が一コミットしてしまった場合にPush時に検知する仕組みを導入することも有効です。

```bash
git-sercrets --install
```

実行すると.git/hooks/pre-commitにpre-commitファイルが作成されます。

```bash
#!/usr/bin/env bash
git secrets --pre_commit_hook -- "$@"
```
