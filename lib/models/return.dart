import 'package:app/importer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class calorie {
  double homecal = 0;
  callist() async {
    double totalcal = 0;
    var callist =
        await Eat.getcal(DateFormat('yyyy/MM/dd').format(DateTime.now()));
    for (var element in callist) {
      totalcal += element["cal"];
    }

    // final pref = await SharedPreferences.getInstance();

    // if (pref.getDouble('kcal') == null || pref.getDouble('kcal')! < totalcal) {
    //   pref.setDouble('kcal', totalcal);

    // }
    homecal = totalcal;
  }
}
