import 'package:app/importer.dart';
import 'package:app/screens/dressup_screen.dart';

class DressupSubmitButton extends StatelessWidget {
  const DressupSubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: TextButton(
        onPressed: () {
          //
        },
        child: Image.asset(
          'assets/dressup_submit.png',
        ),
      ),
    );
  }
}
