import 'package:flutter/cupertino.dart';

class ManualInputSearchModel extends ChangeNotifier {
  String text = ''; // TextFieldの値を受け取る

  List<String> searchList = [
    "ハンバーグ",
    "ハンバーガー",
    "キムチ鍋",
    "うどん",
    "すき焼き",
    "カレー",
    "寿司",
    "ラーメン",
    "パスタ",
    "シュークリーム",
    "チョコケーキ",
  ];

  List<String> searchResultList = []; // 検索結果用の配列

  // 検索の中身
  search() {
    if (this.text.isNotEmpty) {
      // 何か文字が入力された実行する
      searchResultList.clear(); // .add で増やしているので毎回clearしているらしい
      // 検索処理
      this.searchList.forEach(
        (element) {
          if (element.contains(this.text)) {
            // .contains で文字列の部分一致を判定できる
            searchResultList.add(element); // 一致している要素があれば追加する
          }
        },
      );
      notifyListeners(); // これを実行すると再描画される
    }
  }
}
