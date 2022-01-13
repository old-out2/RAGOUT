import 'package:app/importer.dart';

class ManualInputRegistButton extends StatelessWidget {
  const ManualInputRegistButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        child: Image.asset(
          'assets/manualinput_regist.png',
        ),
      ),
    );
  }
}
