import 'package:app/importer.dart';
import 'package:app/screens/manualinput_screen.dart';

class GrowthButton extends StatelessWidget {
  const GrowthButton({
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
          'assets/growth.png',
        ),
      ),
    );
  }
}
