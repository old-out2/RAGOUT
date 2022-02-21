import 'package:app/importer.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/return.dart';

class BarcodeRegistButton extends StatelessWidget {
  final String code;
  const BarcodeRegistButton({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = SizeConfig();
    size.init(context);

    Map<String, dynamic> map = {
      'date': DateFormat('yyyy/MM/dd').format(DateTime.now()),
      'foodid': null,
      'barcode': code
    };

    return SizedBox(
        width: size.deviceWidth * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              await Eat.Insertbarcode(map);
              Calorie().totalcal();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(title: "RAGOUT")),
                  (_) => false);
            },
            child: Image.asset('assets/dialog_regist.png'),
          ),
        ));
  }
}
