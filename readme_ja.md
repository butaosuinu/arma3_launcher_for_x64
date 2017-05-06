# Arma3 game launcher for x64 client

Arma3 64bitクライアント対応ランチャーです。  
このアプリはelectron、Riot.js、Uikit CSS フレームワークを用いて開発されています。  

[App download](https://github.com/butaosuinu/arma3_launcher_for_x64/releases)

## 機能

- x64 クライアントサポート
- アドオンマネージャ
- 起動オプション

## 利用者向け

上記リンクからZIPファイルを任意のフォルダにダウンロードして解凍してください。  
解凍したフォルダの中の「arma3launcher64.exe」をダブルクリックして起動してください。  

## 開発者向け

electronを使用しているので、グローバルにelectronをインストールしてください。  

### 必要環境

- Node.js v6.0+
- electron v1.6.2
- electron-packager
- (Mac上でビルドする際にのみ必要) wine

### インストール

```
$ npm i -g electron electron-packager
$ git clone https://github.com/butaosuinu/arma3_launcher_for_x64.git
$ cd arma3_launcher_for_x64/
$ npm i
$ bower install
$ npm run total-build-win # when your machine is unix/linux, you can use "npm run total-build-unix"

or

$ npm build-dev
$ electron ./app
```

enjoy!

## credit

- butaosuinu : planning, coding and etc
- raika siray : icon image
