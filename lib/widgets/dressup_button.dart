import 'package:app/importer.dart';
import 'package:app/screens/dressup_screen.dart';

class DressupButton extends StatelessWidget {
  const DressupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DressupScreen()),
            );
          },
          child: Image.asset(
            'assets/dressup.png',
          ),
        ),
      ),
    );
  }
}
