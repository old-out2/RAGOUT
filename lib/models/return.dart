import 'package:app/importer.dart';
import 'package:intl/intl.dart';

class calorie {
  double totalcal = 0;
  callist() async {
    var callist =
        await Eat.getcal(DateFormat('yyyy/MM/dd').format(DateTime.now()));
    for (var element in callist) {
      totalcal += element["cal"];
    }
    debugPrint(totalcal.toString());
  }
}
