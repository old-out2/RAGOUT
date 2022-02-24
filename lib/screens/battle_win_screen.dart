import '../importer.dart';
import '../main.dart';

class BattleWinScreen extends StatefulWidget {
  BattleWinScreen({Key? key}) : super(key: key);

  @override
  State<BattleWinScreen> createState() => _BattleWinScreenState();
}

class _BattleWinScreenState extends State<BattleWinScreen> {
  bool rewardFlag = false;
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.black.withOpacity(0.5),
    // );
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            height: size.deviceHeight * 0.35,
            // width: size.deviceWidth * 0.8,
            child: Image.asset('assets/battle_win.png'),
          ),
          SizedBox(
            height: size.deviceHeight * 0.35,
            // width: size.deviceWidth * 0.5,
            child: Image.asset('assets/avatar_win.png'),
          ),
          SizedBox(
            // height: size.deviceHeight * 0.2,
            width: size.deviceWidth * 0.8,
            child: Image.asset('assets/battle_win_text.png'),
          ),
          TextButton(
            onPressed: () {
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
                height: size.deviceHeight * 0.05,
                child: Image.asset('assets/back_to_top.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
