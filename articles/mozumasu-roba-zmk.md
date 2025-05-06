---
title: "初めての自作キーボードとZMK"
emoji: "📌"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: [zmk]
published: false
---

## はじめに

初の自作キーボードを作成しました。
以外にもはんだ付けはそこまで難しくはなく、その後のファームウェアの書き込みや設定に手間取ったので、記録として残しておきます。

環境

- キーボード roBa
- ファームウェア ZMK
- OS: MacOS
- 配列: 日本配列

## カスタマイズ紹介

### ロータリーエンコーダーの設定

デフォルトだとスクロール量が多いのと、向きが逆だったので、以下のように設定しました。

スクロール量の調整

```diff config/roBa.keymap
#include <behaviors.dtsi>
#include <dt-bindings/zmk/bt.h>
#include <dt-bindings/zmk/keys.h>
#include <dt-bindings/zmk/pointing.h>

#define MOUSE 4
#define SCROLL 5
#define NUM 6
+ #undef ZMK_POINTING_DEFAULT_SCRL_VAL
+ #define ZMK_POINTING_DEFAULT_SCRL_VAL 80
```

向きを逆にする

```diff config/roBa.keymap
    behaviors {
+       encoder_msc_down_up: encoder_msc_down_up {
+           compatible = "zmk,behavior-sensor-rotate";
+           label = "ENCODER_MSC_DOWN_UP";
+           #sensor-binding-cells = <0>;
+           bindings = <&msc SCRL_UP>, <&msc SCRL_DOWN>;
+
+           tap-ms = <20>;
+       };
    };
```

値を変更

```diff config/boardds/shields/Test/roBa.dtsi
    left_encoder: encoder_left {
        compatible = "alps,ec11";
        a-gpios = <&xiao_d 5 (GPIO_ACTIVE_HIGH | GPIO_PULL_UP)>;
        b-gpios = <&xiao_d 0 (GPIO_ACTIVE_HIGH | GPIO_PULL_UP)>;
-       steps = <12>;
+       steps = <24>;
        status = "disabled";
    };
```

@[card](https://qiita.com/Reotech/items/e048073b3c5831d3e1c2)

## トラックボールの調整

トラックボールの縦の動きに違和感があるため、感度を変更しています。

```diff config
- CONFIG_PMW3610_CPI=400
+ CONFIG_PMW3610_CPI=600
```

## karabinerの設定

初期の状態だと、キーボードにkarabinerの設定が反映されていないため有効にする必要があります。
![karabinerの設定](/images/roba-zmk/karabiner.png)

## 左クリックと右クリックの設定

クリックの操作は `Mouse Key Press ($mkp)`で設定できます。
combosという同時押しに操作を割り当てる機能を使って設定しています。
以下の設定だとjkで左クリック、klで右クリックになります。
トラックボールを操作しながら片手で入力できる位置に設定するのがオススメです。

```diff config:roBa.keymap
    combos {
        compatible = "zmk,combos";
        timeout-ms = <20>; // default is 30ms

+       Left_Click {
+           bindings = <&mkp LCLK>;
+           key-positions = <18 19>;
+       };
+
+       Right_Click {
+           bindings = <&mkp RCLK>;
+           key-positions = <19 20>;
+       };
    };
```

## 使わないキーを消す

まずは使わないキーを消します。
私は karabiner で以下のように割りあてているためEnterとBackspaceは使いません。

:::details karabinerの設定

Enterを^mに割り当て

```json
{
    "description": "^M to Enter",
    "manipulators": [
        {
            "from": {
                "key_code": "m",
                "modifiers": {
                    "mandatory": ["left_control"],
                    "optional": ["any"]
                }
            },
            "to": [{ "key_code": "return_or_enter" }],
            "type": "basic"
        }
    ]
}
```

Deleteを^hに割り当て

```json
{
    "description": "^H to delete",
    "manipulators": [
        {
            "from": {
                "key_code": "h",
                "modifiers": {
                    "mandatory": ["left_control"],
                    "optional": ["any"]
                }
            },
            "to": [{ "key_code": "delete_or_backspace" }],
            "type": "basic"
        }
    ]
}
```

たまに emacsのキーバインドでカーソル移動できないけしからんものがあるので明示しておく

```json
{
    "description": "Left ctrl + f/b to arrow keys",
    "manipulators": [
        {
            "from": {
                "key_code": "f",
                "modifiers": {
                    "mandatory": ["left_control"],
                    "optional": ["any"]
                }
            },
            "to": [{ "key_code": "right_arrow" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "b",
                "modifiers": {
                    "mandatory": ["left_control"],
                    "optional": ["any"]
                }
            },
            "to": [{ "key_code": "left_arrow" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "com.github.wez.wezterm"
                    ],
                    "type": "frontmost_application_unless"
                }
            ],
            "from": {
                "key_code": "n",
                "modifiers": {
                    "mandatory": ["left_control"],
                    "optional": ["any"]
                }
            },
            "to": [{ "key_code": "down_arrow" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "com.github.wez.wezterm"
                    ],
                    "type": "frontmost_application_unless"
                }
            ],
            "from": {
                "key_code": "p",
                "modifiers": {
                    "mandatory": ["left_control"],
                    "optional": ["any"]
                }
            },
            "to": [{ "key_code": "up_arrow" }],
            "type": "basic"
        }
    ]
}
```

:::

- Enter → ^M
- Backspace → ^H

また、deleteも^kで代用できるため消します。

他にも指の動きが辛いものを変更しています。
デフォルト設定に対して変更した部分を書き込んでみました。

![roBa settings](/images/roba-zmk/roBa-default-settings.png)

設定後がこちら

![roBa settings after](/images/roba-zmk/roba-default-settings-after.png)

:とCMDキーがダブってない?とお気づきの方もいらっしゃることでしょう。
単に持て余しているだけです。私に42キーは多いのかもしれません。

MacOSの英数キーはLANG2、かなキーはLANG1に割り当てられています。

## 日本語配列とZMK

ここで問題があります。
いざ入力してみると、 `:` を押すと `+` が入力され `"` を押すと `*` が入力されます。
これはOS側では日本語配列を使用しているのに対し、キーボード側でUS配列を使用しているためです。
ZMKは日本語配列に対応していないため、以下のような対応表を見ながら設定するか、日本語用のキーを別途定義して設定する必要があります。

@[card](https://www.aandd.co.jp/pdf_storage/tech_doc/balance/t_gc_jis_us_keybord.pdf)

自分は設定ファイルからどのキーが割り当てられているかを確認したいため、日本語用のキーを用意することにしました。

まずは、以下のように日本語用のキーを定義します。

```config:config/keymap_jp.h
#define JP_EISU  LANGUAGE_2   // 英数
#define JP_KANA  LANG1        // かな
#define JP_MINUS MINUS        // -
#define JP_CARET EQUAL        // ^
#define JP_YEN   INT3         // ¥
#define JP_AT    LBKT         // @
#define JP_LBKT  RBKT         // [
#define JP_SEMI  SEMI         // ;
#define JP_COLON SQT          // :
#define JP_RBKT  NUHS         // ]
#define JP_COMMA COMMA        // ,
#define JP_DOT   DOT          // .
#define JP_SLASH SLASH        // /
#define JP_BSLH  INT1         // (backslash)
#define JP_MHEN  INT5         // Muhenkan (無変換)
#define JP_HENK  INT4         // Henkan (変換)
#define JP_EXCL  LS(N1)       // !
#define JP_DQT   LS(N2)       // "
#define JP_HASH  LS(N3)       // #
#define JP_DLLR  LS(N4)       // $
#define JP_PRCNT LS(N5)       // %
#define JP_AMPS  LS(N6)       // &
#define JP_SQT   LS(N7)       // '
#define JP_LPAR  LS(N8)       // (
#define JP_RPAR  LS(N9)       // )
#define JP_EQUAL LS(JP_MINUS) // =
#define JP_TILDE LS(JP_CARET) // ~
#define JP_PIPE  LS(JP_YEN)   // |
#define JP_GRAVE LS(JP_AT)    // `
#define JP_LBRC  LS(JP_LBKT)  // {
#define JP_PLUS  LS(JP_SEMI)  // +
#define JP_ASTRK LS(JP_COLON) // *
#define JP_RBRC  LS(JP_RBKT)  // }
#define JP_LT    LS(JP_COMMA) // <
#define JP_RT    LS(JP_DOT)   // >
#define JP_QMARK LS(JP_SLASH) // ?
#define JP_UNDER LS(JP_BSLH)  // _
```

定義したファイルをkeymapファイルで読み込みます。
このファイルは`<>`ではなく`"`で囲む必要があるため注意です。

```diff config:config/roBa.keymap
#include <behaviors.dtsi>
#include <dt-bindings/zmk/bt.h>
#include <dt-bindings/zmk/keys.h>
#include <dt-bindings/zmk/pointing.h>
+ #include "keymap_jp.h"
```

あとは、定義したキーをkeymapファイルに反映すてばOKです。
自分で定義したキーは Keymap Editor で表示されません。
![JIS ZMK](/images/roba-zmk/jis-zmk.png)

---

## トラブルシューティング

ここからはハマったポイントを紹介していきます。

### レイヤーが勝手に切り替わってしまう

タイピング中にレイヤーが勝手に切り替わってしまう現象が頻発していました。
自分の場合は以下の2つが原因でした

1. トラックボールの揺れでオートマスレイヤー (AML) が有効になっていた
2. combosが作動していた

#### 1. トラックボールの揺れでオートマスレイヤーが有効になっていた

トラックボールやトラックボールの揺れでオートマスレイヤー (AML) が有効になってしまうことがあるようです。
以下のように変更して改善しました。

```diff yaml:config/west.yml
manifest:
  remotes:
    - name: zmkfirmware
      url-base: https://github.com/zmkfirmware
    - name: kumamuk-git
      url-base: https://github.com/kumamuk-git
  projects:
    - name: zmk
      remote: zmkfirmware
      revision: main
      import: app/west.yml
+   - name: zmk-pmw3610-driver
+     remote: kumamuk-git
+     revision: main
  self:
    path: config
```

zmk-pmw3610-driverを指定することで、`CONFIG_PMW3610_MOVEMENT_THRESHOLD`というオプションでAMLの閾値を設定できるようになります。
1~20くらいに設定している人がいる印象です。自分は20に設定しています。

```diff config:config/boards/shields/Test/roBa_R.conf

- CONFIG_PMW3610_MOVEMENT_THRESHOLD=0
+ CONFIG_PMW3610_MOVEMENT_THRESHOLD=20
```

### 2. combosが作動していた

タイピング速度が早かったり同時押しで入力する癖があったりすると、combosが作動してしまい意図しない挙動になることがあります。
自分はデフォルトで設定されていた以下のcombosが作動し、別のレイヤーに切り替わってしまうことがありました。

```diff
    combos {
-       muhennkann {
-           bindings = <&to_layer_0 INT_MUHENKAN>;
-           key-positions = <11 10>;
-       };
    };
```

ついでにcombosの時間をも調整するとよいでしょう。

```diff roBa.keymap
    combos {
        compatible = "zmk,combos";
+       timeout-ms = <20>; // default is 30ms
    };
```

## おわりに

自作キーボードめっちゃたのしいよ
首と肩が楽で良い
