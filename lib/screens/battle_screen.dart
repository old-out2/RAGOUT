import 'package:app/importer.dart';

class BattleScreen extends StatefulWidget {
  BattleScreen({Key? key}) : super(key: key);

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EnemyTwo(),
    );
  }
}

class EnemyOne extends StatelessWidget {
  const EnemyOne({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bgimage_battle1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.deviceHeight * 0.15,
                child: Image.asset("assets/battle_enemy1.png"),
              ),
              SizedBox(width: size.deviceWidth * 0.2),
              SizedBox(
                height: size.deviceHeight * 0.2,
                child: Image.asset("assets/battle_avatar.png"),
              ),
            ],
          ),
          SizedBox(height: size.deviceHeight * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_attack.png"),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_masic.png"),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_item.png"),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_escape.png"),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class EnemyTwo extends StatelessWidget {
  const EnemyTwo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bgimage_battle2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        width: size.deviceHeight * 0.15,
                        height: 18,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: size.deviceHeight * 0.15,
                        child: Image.asset("assets/battle_lifepoint.png"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.deviceHeight * 0.3,
                    child: Image.asset("assets/battle_enemy2.png"),
                  ),
                ],
              ),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        width: size.deviceHeight * 0.1,
                        height: 12,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: size.deviceHeight * 0.1,
                        child: Image.asset("assets/battle_lifepoint.png"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.deviceHeight * 0.15,
                    child: Image.asset("assets/battle_avatar.png"),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: size.deviceHeight * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_attack.png"),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_masic.png"),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_item.png"),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: size.deviceWidth * 0.4,
                child: Image.asset("assets/battle_escape.png"),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
