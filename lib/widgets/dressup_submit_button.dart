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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            //
          },
          child: Image.asset(
            'assets/dressup_submit.png',
          ),
        ),
      ),
    );
  }
}
