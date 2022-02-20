import 'dart:ui';

import 'package:app/importer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calorie {
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
  // consume() async{
  //    final pref = await SharedPreferences.getInstance();
  //   var height = pref.getString('height');
  //   var weight = pref.getString('weight');

  //   //歩幅(cm) = 身長 × 0.45
  //   var stride = int.parse(height!);

  //   //１日の歩数合計 = 歩行距離 ÷ 歩幅(m)
  //   var steps = 4400 / stride;

  //   //標準の消費カロリー
  //   var defaultcal = 1.05 * 3 * 1.1 * int.parse(weight!);

  //   //一歩に対するカロリー
  //   var onestep = defaultcal / steps;

  // }

  //歩いた歩数から消費カロリーを差し引いた残り
  calculateKcal(int nofSteps) async {
    final pref = await SharedPreferences.getInstance();
    var height = pref.getString('height');
    var weight = pref.getString('weight');

    //歩幅(cm) = 身長 × 0.45
    var stride = int.parse(height!);

    //１日の歩数合計 = 歩行距離 ÷ 歩幅(m)
    var steps = 4400 / stride;

    //標準の消費カロリー
    var defaultcal = 1.05 * 3 * 1.1 * int.parse(weight!);

    //一歩に対するカロリー
    var onestep = defaultcal / steps;

    //歩いた分の消費カロリー
    var calculate = onestep * nofSteps;
    print("onestep: " + onestep.toString());
    //一日の消費カロリーから引いて残った分を返す
    int residue = (defaultcal - calculate).toInt();

    return residue;
  }

  //標準消費カロリー
  calculateDefaultKcal() async {
    final pref = await SharedPreferences.getInstance();
    var weight = pref.getString('weight');

    //標準の消費カロリー
    int defaultcal = (1.05 * 3 * 1.1 * int.parse(weight!)).toInt();

    return defaultcal;
  }

  //１日の歩数合計 = 歩行距離 ÷ 歩幅(m)
  calculateTargetSteps() async {
    final pref = await SharedPreferences.getInstance();
    var height = pref.getString('height');

    //歩幅(cm) = 身長 × 0.45
    var stride = int.parse(height!) * 0.45;

    //１日の歩数合計 = 歩行距離 ÷ 歩幅(m)
    var steps = 4400 ~/ (stride / 100);

    return steps;
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

  requiredAmount() async {
    String now = DateFormat('yyyyMMdd').format(DateTime.now());

    final pref = await SharedPreferences.getInstance();
    int height = int.parse(pref.getString('height')!);
    int weight = int.parse(pref.getString('weight')!);
    int birthday = int.parse(pref.getString('birthday')!.replaceAll("/", ""));
    int gendar = pref.getInt('gender')!;
    double activeLevel = double.parse(pref.getInt('ActiveLevel').toString());
    if (activeLevel == 0) {
      activeLevel = 1.5;
    } else if (activeLevel == 1) {
      activeLevel = 1.75;
    }

    int age = ((int.parse(now) - birthday) / 10000).floor();

    double A = 0.0481 * weight;
    double B = 0.0234 * height;
    double C = 0.0138 * age;
    double D = 0.5473 * (gendar + 1);
    double E = 0.1238 + A + B - C - D;
    double basis = E * 1000 / 4.186;

    //一日の活動に必要なエネルギー量
    double Amount = basis * activeLevel;

    return [Amount.round(), gendar];
  }
}

//戦闘に使う関数
class battle {
  damege() {
    //アステリオス方式を採用する予定
  }
}
