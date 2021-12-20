import 'package:app/importer.dart';

class DressupButton extends StatelessWidget {
  const DressupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: TextButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => BattleScreen()),
          // );
        },
        child: Image.asset(
          'assets/dressup.png',
        ),
      ),
    );
  }
}
