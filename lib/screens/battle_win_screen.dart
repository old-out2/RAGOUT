import '../importer.dart';
import '../main.dart';

class BattleWinScreen extends StatefulWidget {
  BattleWinScreen({
    Key? key,
    required this.enemyId,
  }) : super(key: key);

  int enemyId;

  @override
  State<BattleWinScreen> createState() => _BattleWinScreenState();
}

class _BattleWinScreenState extends State<BattleWinScreen> {
  var newtitle = "";
  init() async {
    await trophy.updateTrophy(widget.enemyId);
    newtitle = await trophy.getNewTrophy(widget.enemyId);
    print(newtitle);
  }

  bool rewardFlag = false;
  @override
  Widget build(BuildContext context) {
    init();

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
              if (newtitle.isNotEmpty) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        child: GetTitleDialog(newTitle: newtitle),
                      );
                    });
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(title: "RAGOUT")),
                  (_) => false,
                );
              }
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

class GetTitleDialog extends StatefulWidget {
  GetTitleDialog({
    Key? key,
    required this.newTitle,
  }) : super(key: key);

  String newTitle;

  @override
  State<GetTitleDialog> createState() => _GetTitleDialogState();
}

class _GetTitleDialogState extends State<GetTitleDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.deviceWidth * 0.7,
      height: size.deviceHeight * 0.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/check_cal_dialog.png"),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.deviceWidth * 0.6,
                child: Text(
                  "新しい称号\n「${widget.newTitle}」\nを手に入れました！",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen(title: "RAGOUT")),
                    (_) => false,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: size.deviceWidth * 0.12,
                  child: Image.asset("assets/checkcal_ok_button.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
