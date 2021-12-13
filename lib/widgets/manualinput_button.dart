import 'package:app/importer.dart';
import 'package:app/screens/manualinput_screen.dart';

class ManualInputButton extends StatelessWidget {
  const ManualInputButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManualInputScreen()),
          );
        },
        child: Image.asset(
          'assets/manualinput.png',
        ),
      ),
    );
  }
}
