import 'package:app/importer.dart';

class BattleButton extends StatelessWidget {
  const BattleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BattleScreen()),
          );
        },
        child: Image.asset(
          'assets/battle.png',
        ),
      ),
    );
  }
}
