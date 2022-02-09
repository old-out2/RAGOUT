import 'package:app/importer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class calorie {
  double homecal = 0;

  //ホーム画面のカロリー表示
  callist() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isFirstLaunch') == true) {
      double totalcal = 0;
      var callist =
          await Eat.getcal(DateFormat('yyyy/MM/dd').format(DateTime.now()));
      for (var element in callist) {
        totalcal += element["cal"];
      }
      homecal = totalcal;
    }
  }

  //標準の消費カロリー
  consume() async {
    final pref = await SharedPreferences.getInstance();
    var height = pref.getString('height');
    var weight = pref.getString('weight');

    //歩幅(cm) = 身長 × 0.45
    var stride = int.parse(height!);

    //１日の歩数合計 = 歩行距離 ÷ 歩幅(m)
    var steps = 4400 / stride;

    //標準の消費カロリー
    var consume = 1.05 * 3 * 1.1 * int.parse(weight!);

    //一歩に対するカロリー
    var onestep = consume / steps;
  }

  //一日の合計カロリーと栄養をを算出する
  totalcal() async {
    Map<String, String> maps = {};
    double cal = 0;
    double protein = 0;
    double lipids = 0;
    double carb = 0;
    double mineral = 0;
    double bitamin = 0;

    String now = DateFormat('yyyy/MM/dd').format(DateTime.now());

    var callist = await Eat.getEat(now);

    replace(String value) {
      return value.replaceAll(RegExp("[()]"), "");
    }

    for (var element in callist) {
      cal += element["cal"];
      protein += double.parse(replace(element["protein"]));
      lipids += double.parse(replace(element["lipids"]));
      carb += double.parse(replace(element["carb"]));
      mineral += double.parse(replace(element["mineral"]));
      bitamin += double.parse(replace(element["bitamin"]));
    }
    maps.addAll({
      'cal': cal.toString(),
      'protein': protein.toString(),
      'lipids': lipids.toString(),
      'carb': carb.toString(),
      'mineral': mineral.toString(),
      'bitamin': bitamin.toString()
    });

    var get = await total.getTotal(now);
    if (get.isNotEmpty) {
      await total.updateTotal(maps);
    } else {
      maps["date"] = now;
      await total.insertTotal(maps);
    }
  }
}
