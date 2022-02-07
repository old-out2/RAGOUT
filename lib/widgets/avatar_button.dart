import 'package:app/importer.dart';
import 'package:app/screens/status_screen.dart';

class AvatarButton extends StatelessWidget {
  const AvatarButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StatusScreen()),
        );
      },
      child: Image.asset(
        'assets/avatar.png',
        height: 240,
      ),
    );
  }
}
