import 'package:app/importer.dart';
import 'package:app/screens/manualinput_screen.dart';

class ManualInputRegistButton extends StatelessWidget {
  const ManualInputRegistButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () async {
          await Eat.insertEat(eatfood);
        },
        child: Image.asset(
          'assets/manualinput_regist.png',
        ),
      ),
    );
  }
}
