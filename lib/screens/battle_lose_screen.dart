import '../importer.dart';
import '../main.dart';

class BattleLoseScreen extends StatefulWidget {
  BattleLoseScreen({Key? key}) : super(key: key);

  @override
  State<BattleLoseScreen> createState() => _BattleLoseScreenState();
}

class _BattleLoseScreenState extends State<BattleLoseScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                width: size.deviceWidth,
              ),
              SizedBox(
                width: size.deviceWidth * 0.8,
                child: Image.asset('assets/battle_lose.png'),
              ),
              SizedBox(
                width: size.deviceWidth * 0.5,
                child: Image.asset('assets/avatar_lose.png'),
              ),
              SizedBox(
                width: size.deviceWidth * 0.8,
                child: Image.asset('assets/battle_lose_text.png'),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(title: "RAGOUT")),
                (_) => false,
              );
            },
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: size.deviceWidth * 0.3,
                child: Image.asset('assets/back_to_top.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
