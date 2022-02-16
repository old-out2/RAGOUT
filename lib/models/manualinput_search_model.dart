import 'package:flutter/cupertino.dart';
import 'package:app/importer.dart';

class ManualInputSearchModel extends ChangeNotifier {
  String text = ''; // TextFieldの値を受け取る

  // List<String> searchList = [
  //   "ハンバーグ",
  //   "ハンバーガー",
  //   "キムチ鍋",
  //   "うどん",
  //   "すき焼き",
  //   "カレー",
  //   "寿司",
  //   "ラーメン",
  //   "パスタ",
  //   "シュークリーム",
  //   "チョコケーキ",
  // ];

  List<Map<String, String>> searchResultList = []; // 検索結果用の配列

  // 検索の中身
  search() async {
    if (text.isNotEmpty) {
      // 何か文字が入力された実行する
      searchResultList.clear(); // .add で増やしているので毎回clearしているらしい
      // 検索処理
      var SearchList = await Food.getFoods(text);
      SearchList.forEach((element) {
        searchResultList.add({
          "id": element.id.toString(),
          "name": element.name
              .replaceAll(RegExp("＜.*＞|（.*）|［.*］|" r'\s'), "")
              .trim(),
          "cal": element.cal.toString(),
          // "protein": element.protein,
          // "lipids": element.lipids,
          // "carb": element.carb,
          // "mineral": element.mineral,
          // "bitamin": element.bitamin
        });
      });
      // this.searchList.forEach(
      //   (element) {
      //     if (element.contains(this.text)) {
      //       // .contains で文字列の部分一致を判定できる
      //       searchResultList.add(element); // 一致している要素があれば追加する
      //     }
      //   },
      // );
      notifyListeners(); // これを実行すると再描画される
    }
  }
}
