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
}
