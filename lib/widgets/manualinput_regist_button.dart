import 'package:app/importer.dart';
import 'package:app/screens/manualinput_screen.dart';
import 'package:app/screens/dialog.dart';

class ManualInputRegistButton extends StatelessWidget {
  const ManualInputRegistButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          CustomDialog(context).showCustomDialog(totalcal);
        },
        child: Image.asset(
          'assets/manualinput_regist.png',
        ),
      ),
    );
  }
}
