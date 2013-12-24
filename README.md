﻿サウンドファイルを読み込んで連結します
===================

SUMMARY
----------
GUIにより選択された複数のサウンドファイル(SE・BGM用)を１つのファイルに連結し、wav形式で出力します。
それぞれのサウンドの合間には0.5秒の無音領域と、音声ファイルの先頭に1.0秒の無音領域が差し込まれます。
スマホ用のゲーム作成時などにお使いください。
サウンドファイルの構造データもJSONの形で出力されます。

INSTALL
----------
Mac/Windows上で動くAIRで作られたアプリです。インストール時に最新のAIRランタイムを要求される事があります。

USAGE
----------
アプリ起動後、ファイル選択ボタンを押して、mp3,wav,aiffなど取り込みたいサウンドファイルを複数選択します。

選択されたサウンドファイルはリスト化されます。

リスト上では

* サウンドのID名を変更する(ID名のデフォルトはファイル名です)
* BGM扱いするかSE扱いするかの切り替え(音声の長さによってデフォルトが切り替わります)
* テスト再生
* テスト停止
* リストの上側へ移動
* リストの下側へ移動
* 選択音声ファイルをリストから削除する

これらの操作が行えます。

書き出しボタンを押すと、保存するファイル名の選択になります。
wavファイル名を指定してOKしてください。wavファイルの合成が開始されます。
(この処理は時間がかかる事があります。)

ファイル保存後、ファイルの内容を表すJSONが画面に表示されるので、必要な場合はコピー＆ペースとして使ってください。
JSONテキストを表示しているテキストボックスはマウスのフォーカスがはずれると、自動で閉じられます。

左上のチェックボックスは、出力音声ファイルに１秒の無音を挿入するかどうかの指定に使います。

音声の合成順序はリストの上からの並び順となります。


HISTORY
----------

Version 1.0.0
* とりあえずwavファイルで保存できるように。

Version 1.0.1
* 書き出しパラメータを調整

Version 1.0.2
* 書き出しパラメータ形状を変更、ミリ秒数を秒数へ変更
* 音素材の合間にすきまをもうける

Version 1.0.3
* 無音データ部分作成にテンポラリ作業用のmp3ファイルを用意しない
* 書き出し音声ファイルの先頭に１秒の無音を挿入できる

Version 1.0.4(a)
* JSONの各項目の並びを、編集画面の通りにする
* 音長データが必要以上に小数点以下のデータがあり長かったので適当にカットした

Version 1.0.5
* 使用しているライブラリをAIR3.9,starling1.4.1,feathers1.2.0にそれぞれアップデート
* lost context エラーの回避
* デフォルトの画面拡大率を大きく変更

既存の不具合など
----------

* 日本語がでない/文字が小さい(仕様しているUIライブラリ＆スキンの仕様です。)
* 正しく書き出せない音声ファイルがある(テスト再生して音が聞こえない音声ファイルには対応していません。)
* Macのマルチモニタ環境でアプリをモニタをこえてアプリのwinndowを移動すると、エラー画面になる(Starlingライブラリを使っている事による仕様です。)

