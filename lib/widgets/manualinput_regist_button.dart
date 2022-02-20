import 'package:app/importer.dart';
import 'package:app/screens/dialog.dart';

class ManualInputRegistButton extends StatelessWidget {
  final double totalcal;
  final List<Map<String, String>> eatfood;
  const ManualInputRegistButton(
      {Key? key, required this.totalcal, required this.eatfood})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            CustomDialog(context: context, eatfood: eatfood)
                .showCustomDialog(totalcal);
          },
          child: Image.asset(
            'assets/manualinput_regist.png',
          ),
        ),
      ),
    );
  }
}
