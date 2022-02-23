import 'package:app/importer.dart';

class BattleButton extends StatelessWidget {
  const BattleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.deviceWidth * 0.33,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => BattleScreen()),
            // );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BattleScreen(),
                ),
                (_) => false);
          },
          child: Image.asset(
            'assets/battle.png',
          ),
        ),
      ),
    );
  }
}
