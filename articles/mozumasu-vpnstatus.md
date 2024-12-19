---
title: "CLIでVPN接続する (for Mac)"
emoji: "🛜"
type: "tech"
topics: [vpn, cli, vpnstatus]
published: true
---

:::message
この記事は[めぐろLT Advent Calendar 2024](https://qiita.com/advent-calendar/2024/meguro-lt)の18日目の記事です。
:::

## はじめに

どんな時も人はターミナルから離れたくないものです。
VPN接続の時も例外ではありません。

というわけで、ターミナルからVPNを接続できるようにしてみましょう。

![vpnutilとfzf](/images/vpnstatus/vpnstatus.gif)

gif画像は以下の操作を行なっています。

1. vpnc (vpn connect)でVPN接続
2. vpns (vpn status)でステータス確認
3. vpnd (vpn disconnect) でVPN接続を停止

## Macのデフォルトコマンド: scutil

MACには`scutil`というコマンドがあります。

:::details scutil --help (日本語ver)

```text
usage: scutil
	動的ストアへのインタラクティブアクセス

   scutil --prefs [preference-file]
    [raw]保存された設定へのインタラクティブアクセス

   scutil [-W] -r nodename
   scutil [-W] -r address
   scutil [-W] -r local-address remote-address
    ノード、アドレス、またはアドレスペアの到達可能性を確認 ( -Wで監視 )

   scutil -w dynamic-store-key [ -t timeout ]
    -w	動的ストアキーの存在を待つ
    -t	キーを待つ時間

   scutil --get pref
   scutil --set pref [newval]
   scutil --get filename path key
    pref	指定された設定を表示または設定。有効な設定には以下が含まれる：
			ComputerName, LocalHostName, HostName
    newval	設定する新しい設定値。指定されていない場合、新しい値は標準入力から読み取られる

    scutil --dns
      DNS設定を表示

    scutil --proxy
      プロキシ設定を表示

    scutil --nwi
      ネットワーク情報を表示

    scutil --nc
      VPNネットワーク設定情報を表示。完全なコマンドリストについては --nc help を参照

    scutil --renew [interface-name]
      インターフェースのネットワーク設定を再評価

    scutil --allow-new-interfaces [off|on]
      画面がロックされているときの新しいインターフェースの作成を管理

    scutil --error err#
      指定されたエラーコードの説明メッセージを表示
```

余談
`scutil`: scはSystem Configurationの略
`pref`: preferenceの略で「設定」や「好み」という意味

:::

VPNの管理は`scutil --nc [command]`で行えます。

::: details scutil --nc help (日本語ver)

```text
使用法: scutil --nc [command]

	list
		現在のセットで利用可能なネットワーク接続サービスを一覧表示

	status <サービス>
		指定されたサービスが接続されているかどうかを示し、サービスの拡張ステータス情報を表示

	show <サービス>
		指定されたサービスの構成情報を表示

	statistics <サービス>
		指定されたサービスのバイト、パケット、およびエラーに関する統計情報を提供

	select <サービス>
		現在のセットで指定されたサービスをアクティブにする。これにより、サービスを開始できる

	start <サービス> [--user ユーザー] [--password パスワード] [--secret シークレット]
		指定されたサービスを開始する。ユーザー、パスワード、およびシークレットのオプション引数を取ることができる

	stop <サービス>
		指定されたサービスを停止

	suspend <サービス>
		指定されたサービスを一時停止 (PPP、モデムオンホールド)

	resume <サービス>
		指定されたサービスを再開 (PPP、モデムオンホールド)

	ondemand [-W] [ホスト名]
	ondemand -- --refresh
		オンデマンドVPN情報を表示

	trigger <ホスト名> [バックグラウンド] [ポート]
		指定されたホスト名でオンデマンドVPNをトリガーし、オプションでポートとバックグラウンドフラグを指定

	enablevpn <サービスまたはVPNタイプ> [パス]
		指定されたVPNアプリケーションタイプを有効。サービスまたはVPNタイプのいずれかを取る。ApplicationURLを設定するためのパスを渡す

	disablevpn <サービスまたはVPNタイプ>
		指定されたVPNアプリケーションタイプを無効化。サービスまたはVPNタイプのいずれかを取る

	help
		--ncの利用可能なコマンドを表示
```

:::

サービス名がわかればいける！となるわけですが、
`networksetup -listallnetworkservices`コマンドで確認してもIKEv2は表示されません。

```sh
# IKEv2は表示されない😢
$ networksetup -listallnetworkservices

An asterisk (*) denotes that a network service is disabled.
AX88179A
Thunderbolt Bridge
Wi-Fi
```

:::details IKEv2とは

IKEv2（Internet Key Exchange version 2）

- VPN（仮想プライベートネットワーク）プロトコルの一つ
- 特徴
  - 高いセキュリティと安定性
  - 高速な接続
  - モバイルデバイスに最適

:::

つまり、IKEv2はMacのデフォルトコマンド`scutil`では管理ができないのです。

そこで、IKEv2も管理できるOSSを紹介します。

## VPNStatus

VPNStatusとは、macOSのVPNを管理するツールです。
@[card](https://github.com/Timac/VPNStatus)

`vpnutil`コマンドで、VPNの開始と停止、状態の確認ができます。

```text
$ vpnutil --help

vpnutil [start|stop|list|status] [VPN名]
例:
	 'MyVPN'という名前のVPNを開始:
	 vpnutil start MyVPN

	 'MyVPN'という名前のVPNを停止:
	 vpnutil stop MyVPN

	 利用可能なすべてのVPNとその状態を一覧表示:
	 vpnutil list

	 'MyVPN'という名前のVPNの状態を取得:
	 vpnutil status MyVPN
```

### VPNStatusのインストール

homebrewをお使いの場合は以下のコマンドでインストールができます。

```sh
brew tap timac/vpnstatus
brew install timac/vpnstatus/vpnutil
brew install --cask timac/vpnstatus/vpnstatus
```

### VPNStatusのおすすめ設定

`vpnutil`コマンドを使いやすくするために以下のような設定をしています。
fzfで使用したいVPNを選択できるようにしています。

```sh:~/.zshrc
# vpnutil ( for Mac )
abbr -S -qq vpn='vpnutil'
alias vpns='check_vpn_status'
alias vpnc='vpn_connect_with_fzf'
alias vpnd='vpn_disconnect_if_connected'

# vpnutil ( for Mac )
check_vpn_status() {
  # Extract the output of vpnutil list as json.
  vpn_data=$(vpnutil list)

  # Extract connected vpn.
  connected_vpns=$(echo "$vpn_data" | jq -r '.VPNs[] | select(.status == "Connected") | "\(.name) (\(.status))"')

  if [[ -z "$connected_vpns" ]]; then
    echo "No Connected"
  else
    echo "Connected VPN:"
    echo "$connected_vpns"
  fi
}

vpn_connect_with_fzf() {
  # Extract the output of vpnutil list as json.
  vpn_data=$(vpnutil list)

  # Get the name and status of the VPN and select it with fzf.
  selected_vpn=$(echo "$vpn_data" | jq -r '.VPNs[] | "\(.name) (\(.status))"' | fzf --prompt="choose a vpn: ")

  # If there is no selected VPN, exit
  if [[ -z "$selected_vpn" ]]; then
    echo "VPN selection canceled."
    return
  fi

  # Extract the vpn name
  vpn_name=$(echo "$selected_vpn" | sed 's/ (.*)//')

  # Connection place
  echo "connection: $vpn_name"
  vpnutil start "$vpn_name"
}

vpn_disconnect_if_connected() {
  # Extract the output of vpnutil list as json.
  vpn_data=$(vpnutil list)

  # Extract connected VPN
  connected_vpns=$(echo "$vpn_data" | jq -r '.VPNs[] | select(.status == "Connected") | .name')

  if [[ -z "$connected_vpns" ]]; then
    echo "No vpn connected."
  else
    echo "Disconnect the following VPN connections:"
    echo "$connected_vpns"

    # Turn off each connected VPN.
    for vpn in $connected_vpns; do
      echo "cutting: $vpn"
      vpnutil stop "$vpn"
    done
    echo "Disconnected all vpn connections."
  fi
}
```

`source`コマンドで設定を反映すると、使用できるようになります。

```sh
source ~/.zshrc
```

### fzfのインストール

上記の設定を行う場合は、fzfのインストールが必要です。

```sh
brew install fzf
```

> 参照: https://formulae.brew.sh/formula/fzf

## おわりに

めぐろLTでCUIはいいぞという発表をしたので、CUIに関係するTips共有をしてみました。
明日 (12/19) の[めぐろLTアドカレ](https://qiita.com/advent-calendar/2024/meguro-lt)は[K1mu21](https://zenn.dev/aeon_mall)さんのBiomeに関する記事の予定です！お楽しみに🎅
