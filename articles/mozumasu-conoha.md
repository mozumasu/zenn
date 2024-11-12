---
title: "ConoHaレンタルサーバーにデプロイするまで"
emoji: "🐥"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [conoha]
published: false
---

## はじめに

ConoHa レンタルサーバーが結構安いので、使ってみることにしました。
ConoHaのサービスにはいろいろありますがその中でも安いVPSサーバーを使ってみることにしました。
ドメインの取得は初年度無料のお名前.comを使って、ドメインを取得しました。

### VPS (Virtual Private Server)

VPSとは、Virtual Private Serverの略で、仮想専用サーバーのことです。
1台の物理サーバーを仮想化技術で分割して、専用サーバーのように使えるサービスです。
共有サーバーより自由度が高く、ルート権限を持つためOSやソフトウェアを自由にカスタマイズ可能ですが、専用サーバーほどリソースは豊富ではありません。
小規模なWebサービスやアプリの運用に適しています。

## ConoHa VPSを設定する

## 初期設定

### SSH接続

作成したVPSにSSH接続できるようにします。

続いて22番ポートが開いているか確認します。

```sh
nc -zv [IPアドレス] 22
```

空いていない場合はセキュリティグループ設定します。

### セキュリティーグループを設定

コントロールパネル > セキュリティ > セキュリティグループ > +セキュリティグループ からセキュリティグループを作成します。

1. 管理用のセキュリティグループを作成

![alt セキュリティグループを作成](/images/conoha/security-group.png)

2. Webサーバー用のセキュリティグループを作成

一般ユーザがアプリケーションにアクセスするためのセキュリティグループを作成します。
80 TCP 0.0.0.0/0 HTTP（ウェブサーバー）
443 TCP 0.0.0.0/0 HTTPS（SSL/TLS暗号化通信）

3. VPCにセキュリティグループを適用

サーバー > VPC > VPCの詳細 > ネットワーク情報 > セキュリティグループ からセキュリティグループを適用します。

### ディストリビューションの確認

ディストリビューションによって使用するコマンドや、サービス名が異なるため、ディストリビューションを確認します。

```sh
cat /etc/os-release
```

実行すると、以下のような情報が表示されます。

```sh
NAME="CentOS Stream"
VERSION="9"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="9"
PLATFORM_ID="platform:el9"
PRETTY_NAME="CentOS Stream 9"
ANSI_COLOR="0;31"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:centos:centos:9"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 9"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
```

使用しているディストリビューションがCentOS Stream 9であることがわかります。

## HTTPSでアクセスできるようにする

HTTP接続だとセキュリティ上問題があるので、HTTPS接続に変更します。
HTTPS接続を行うためにはSSL証明書が必要ですが、Let's Encryptを使用することで無料で取得することができます。

HTTPS接続するためには、以下の手順を実行します。

1. Certbotをインストールする
2. 証明書を取得する
3. 証明書を設定する
4. 自動更新を設定する

### 証明書を自動更新できるようにする

証明書の有効期限は90日で、90日経過する前に都度更新する必要があります。
これを手動で行うのは面倒なので、自動更新するように設定します。
ConoHaのVPSはcronを使って定期的な処理を実行することができます。

TXTレコードを追加する必要があるため、DNSサーバーをConoHaのものに変更します。

### APIユーザーを作成

コントロールパネル > API > APIユーザー > +ユーザー からAPIユーザーを作成します。

APIユーザー作成後、以下の情報を確認します。

- テナントID
- テナント名
- APIユーザー名
- APIユーザーパスワード

> 参照: <https://support.conoha.jp/v/startupscript_letsencrypt/?btn_id=vps-startupscript--guide_support-v-startupscript_letsencrypt#01>

```

```
