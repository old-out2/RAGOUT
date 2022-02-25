import 'package:app/importer.dart';
import 'package:app/models/return.dart';
import 'package:app/screens/battle_win_screen.dart';
import 'dart:math' as math;
import '../main.dart';
import 'battle_lose_screen.dart';

enum AvatarStatus {
  reversible,
  animating,
  forwadable,
}

enum AvatarAttackStatus {
  reversible,
  animating,
  forwadable,
}

enum EnemyStatus {
  reversible,
  animating,
  forwadable,
}

enum EnemyAttackStatus {
  reversible,
  animating,
  forwadable,
}

enum AvatarDamageStatus {
  reversible,
  animating,
  forwadable,
}

enum AvatarHealingStatus {
  reversible,
  animating,
  forwadable,
}

enum EnemyDamageStatus {
  reversible,
  animating,
  forwadable,
}

class BattleScreen extends StatefulWidget {
  BattleScreen({Key? key}) : super(key: key);

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with TickerProviderStateMixin {
  late final AnimationController avatarController;
  late final AnimationController avatarAttackController;
  late final AnimationController enemyController;
  late final AnimationController enemyAttackController;
  late final AnimationController avatarDamageController;
  late final AnimationController avatarHealingController;
  late final AnimationController enemyDamageController;
  AvatarStatus avatarStatus = AvatarStatus.forwadable;
  AvatarAttackStatus avatarAttackStatus = AvatarAttackStatus.forwadable;
  EnemyStatus enemyStatus = EnemyStatus.forwadable;
  EnemyAttackStatus enemyAttackStatus = EnemyAttackStatus.forwadable;
  AvatarDamageStatus avatarDamageStatus = AvatarDamageStatus.forwadable;
  AvatarHealingStatus avatarHealingStatus = AvatarHealingStatus.forwadable;
  EnemyDamageStatus enemyDamageStatus = EnemyDamageStatus.forwadable;

  // 道具セクション
  var selectedIndex = -1;
  int itemCount = 0;
  final itemList = [
    {"index": 0, "imageName": "item_healing_s.png"},
    {"index": 1, "imageName": "item_healing_m.png"},
    {"index": 2, "imageName": "item_healing_l.png"},
    // {"index": 3, "imageName": "item_antidote.png"},
  ];

  //キャラのHP、幅、1ダメに対しての減少量
  double avatarLp = 0;
  double avatarMaxLp = 0;
  double avatarLpWidth = 80;
  double avatarWidthRatio = 0;
  double avatarpower = 0;
  double avatarspeed = 0;
  double avatarwisdom = 0;

  //敵のHP、幅、1ダメに対しての減少量
  double enemyLp = 0;
  double enemyMaxLp = 0;
  double enemyLpWidth = 80;
  double enemyWidthRatio = 0;
  int enemyId = 0;
  double enemypower = 0;
  double enemyspeed = 0;
  double enemydefense = 0;
  int enemyNumber = 0;

  String damage = "";
  int healing = 0;

  //透過
  double avatarOpacity = 1.0;
  double enemyOpacity = 1.0;

  //攻撃後の変更
  double updateAvatarLp = 0;
  double updateAvatarLpWidth = 0;
  double updateAvatarOpacity = 0.0;
  double updateEnemyLp = 0;
  double updateEnemyLpWidth = 0;
  double updateEnemyOpacity = 0.0;

  //各行動に対してのフラグ
  bool enemyAttackFlag = false;
  bool avatarAttackFlag = true;
  bool buttonFlag = true;
  bool itemCanUseFlag = true;
  bool itemFlag = false;
  int attackCount = 0;

  void calcDamage(double width, double lp, double widthRatio, String target) {
    print("run calcDamage");
    // ダメージ計算関数

    // updateLpWidth = width;
    // updateLp = lp;
    // if (lp == 0) {
    //   updateOpacity = 0.0;
    // }

    // if (lp != 0) {
    if (target == "avatar") {
      damage = "-" + (enemypower.toInt()).toString();
      lp = lp - enemypower;
      if (lp < 0) {
        lp = 0;
      }
      width = lp * widthRatio < 1 ? 0 : lp * widthRatio;
      // setState(() {
      updateAvatarLpWidth = width;
      updateAvatarLp = lp;
      if (lp == 0) {
        updateAvatarOpacity = 0.0;
      }
      // });
    } else if (target == "enemy") {
      int dp = (avatarpower - enemydefense).toInt();
      damage = "-" + dp.toString();
      lp = lp - dp.toDouble();
      if (lp < 0) {
        lp = 0;
      }
      width = lp * widthRatio < 1 ? 0 : lp * widthRatio;
      // setState(() {
      updateEnemyLpWidth = width;
      updateEnemyLp = lp;
      if (lp == 0) {
        updateEnemyOpacity = 0.0;
      }
      // }
      // });
    }
  }

  void calcHealing(double width, double lp, double widthRatio, String target) {
    if (target == "avatar") {
      switch (itemList[selectedIndex]["index"]) {
        case 0:
          healing = 10;
          print(avatarLp);
          healing = avatarMaxLp < healing + avatarLp.toInt()
              ? avatarMaxLp.toInt() - avatarLp.toInt()
              : healing;
          setState(() {});
          break;
        case 1:
          healing = 50;
          healing = avatarMaxLp < healing + avatarLp.toInt()
              ? avatarMaxLp.toInt() - avatarLp.toInt()
              : healing;
          break;
        case 2:
          healing = 100;
          healing = avatarMaxLp < healing + avatarLp.toInt()
              ? avatarMaxLp.toInt() - avatarLp.toInt()
              : healing;
          break;
        default:
      }
      lp += healing;
      width = lp * widthRatio;
      updateAvatarLpWidth = width;
      updateAvatarLp = lp;
    }
  }

  Future enemyinfo() async {
    Map<String, dynamic> enemy = await Enemy.getEnemy();

    return enemy;
  }

  Future avatarinfo() async {
    Status avatar = await Status.getStatus();

    return avatar;
  }

  @override
  void initState() {
    super.initState();
    enemyinfo().then((value) {
      setState(() {
        enemyLp = value["HP"].toDouble();
        enemyMaxLp = enemyLp;
      });
      enemyId = value["id"];
      // 1ダメージに対して減らす体力ゲージの比率計算
      enemyWidthRatio = enemyLpWidth / enemyLp;
      enemypower = value["power"].toDouble();
      enemyspeed = value["speed"].toDouble();
      enemydefense = value["defense"].toDouble();
      enemyNumber = value["id"].toInt();
    });

    avatarinfo().then((value) {
      setState(() {
        avatarLp = value.physical.toDouble();
        avatarMaxLp = avatarLp;
      });
      avatarWidthRatio = avatarLpWidth / avatarLp;
      avatarpower = value.power.toDouble();
      avatarspeed = value.speed.toDouble();
      avatarwisdom = value.wisdom.toDouble();
    });

    //同速の場合
    if (enemyspeed == avatarspeed) {
      var rand = math.Random();
      int avatarDice = rand.nextInt(100);
      int enemyDice = rand.nextInt(100);

      enemyspeed = avatarDice < enemyDice ? enemyspeed + 1.0 : enemyspeed - 1.0;
    }

    avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..addStatusListener(avatarStatusListener);

    avatarAttackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..addStatusListener(avatarAttackStatusListener);

    enemyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..addStatusListener(enemyStatusListener);

    enemyAttackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..addStatusListener(enemyAttackStatusListener);

    avatarDamageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener(avatarDamageStatusListener);

    avatarHealingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener(avatarHealingStatusListener);

    enemyDamageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener(enemyDamageStatusListener);
  }

  void avatarStatusListener(AnimationStatus status) {
    print("avatarStatusListener: $status");
    if (status == AnimationStatus.completed) {
      setState(() {
        enemyStatus = EnemyStatus.reversible;
        // 攻撃されたら攻撃可能にする
        avatarAttackFlag = true;
        avatarLp = updateAvatarLp;
        avatarLpWidth = updateAvatarLpWidth;
        // 負け処理
        if (updateAvatarLp <= 0) {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              avatarOpacity = updateAvatarOpacity;
            });
          });
          Future.delayed(const Duration(seconds: 5), () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  child: BattleLoseScreen(),
                );
              },
            );
          });
        }
      });
      avatarController.reset();
      calcDamage(avatarLpWidth, avatarLp, avatarWidthRatio, "avatar");
    } else if (status == AnimationStatus.dismissed) {
      setState(() => enemyStatus = EnemyStatus.forwadable);
    } else {
      setState(() => enemyStatus = EnemyStatus.animating);
      avatarDamageController.forward();
    }
    print("---> $enemyStatus");
  }

  void avatarAttackStatusListener(AnimationStatus status) {
    print("avatarStatusListener: $status");
    if (status == AnimationStatus.completed && updateEnemyLp != 0) {
      setState(() {
        enemyStatus = EnemyStatus.reversible;
        // 攻撃したら攻撃不可能にする
        //if (avatarspeed < enemyspeed) {
        avatarAttackFlag = false;
        //} else {
        //avatarAttackFlag = true;
        // }
      });
      avatarAttackController.reset();
    } else if (status == AnimationStatus.dismissed) {
      setState(() => enemyStatus = EnemyStatus.forwadable);
    } else {
      setState(() => enemyStatus = EnemyStatus.animating);
      attackCount++;
      enemyController.forward();
    }
    print("---> $enemyStatus");
  }

  void enemyStatusListener(AnimationStatus status) {
    print("enemyStatusListener: $status");
    if (status == AnimationStatus.completed) {
      setState(() {
        avatarStatus = AvatarStatus.reversible;
        // 攻撃されたら攻撃可能にする
        // if (avatarspeed > enemyspeed) {
        enemyAttackFlag = true;
        // } else {
        // enemyAttackFlag = false;
        // }
        enemyLp = updateEnemyLp;
        enemyLpWidth = updateEnemyLpWidth;
        // 勝ち処理
        if (updateEnemyLp <= 0) {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              enemyOpacity = updateEnemyOpacity;
            });
          });
          Future.delayed(const Duration(seconds: 5), () {
            Enemy.updateEnemy(enemyNumber);
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  child: BattleWinScreen(enemyId: enemyNumber),
                );
              },
            );
          });
        }
      });
      enemyController.reset();
      // calcDamage(enemyLpWidth, enemyLp, enemyWidthRatio, "enemy");
    } else if (status == AnimationStatus.dismissed) {
      setState(() => avatarStatus = AvatarStatus.forwadable);
    } else {
      setState(() {
        avatarStatus = AvatarStatus.animating;
      });
      enemyDamageController.forward();
    }
    print("---> $avatarStatus");
  }

  void enemyAttackStatusListener(AnimationStatus status) {
    print("enemyAttackStatusListener: $status");
    if (status == AnimationStatus.completed) {
      setState(() {
        avatarStatus = AvatarStatus.reversible;
        // 攻撃したら攻撃不可能にする
        enemyAttackFlag = false;
      });
      enemyAttackController.reset();
    } else if (status == AnimationStatus.dismissed) {
      setState(() => avatarStatus = AvatarStatus.forwadable);
    } else {
      setState(() => avatarStatus = AvatarStatus.animating);
      attackCount++;
      avatarController.forward();
    }
    print("---> $avatarStatus");
  }

  void avatarDamageStatusListener(AnimationStatus status) {
    print("avatarDamageStatusListener: $status");
    if (status == AnimationStatus.completed) {
      setState(() => avatarDamageStatus = AvatarDamageStatus.reversible);
      avatarDamageController.reset();
      if (attackCount == 2) {
        setState(() {
          buttonFlag = true;
          attackCount = 0;
        });
      }
      // if (updateAvatarLp > 0) {
      // calcDamage(enemyLpWidth, enemyLp, enemyWidthRatio, "enemy");
      // avatarAttackController.forward();
      // }
    } else if (status == AnimationStatus.dismissed) {
      setState(() => avatarDamageStatus = AvatarDamageStatus.forwadable);
    } else {
      setState(() => avatarDamageStatus = AvatarDamageStatus.animating);
    }
    print("---> $enemyDamageStatus");
  }

  void avatarHealingStatusListener(AnimationStatus status) {
    print("avatarHealingStatusListener: $status");
    if (status == AnimationStatus.completed) {
      setState(() => avatarHealingStatus = AvatarHealingStatus.reversible);
      avatarHealingController.reset();
      avatarLp = updateAvatarLp;
      avatarLpWidth = updateAvatarLpWidth;
    } else if (status == AnimationStatus.dismissed) {
      setState(() => avatarHealingStatus = AvatarHealingStatus.forwadable);
    } else {
      setState(() => avatarHealingStatus = AvatarHealingStatus.animating);
    }
    print("---> $enemyDamageStatus");
  }

  void enemyDamageStatusListener(AnimationStatus status) async {
    print("enemyDamageStatusListener: $status");
    if (status == AnimationStatus.completed) {
      setState(() {
        enemyDamageStatus = EnemyDamageStatus.reversible;
      });
      enemyDamageController.reset();
      if (attackCount == 2) {
        setState(() {
          buttonFlag = true;
          attackCount = 0;
        });
      }
      if (updateEnemyLp > 0) {
        calcDamage(avatarLpWidth, avatarLp, avatarWidthRatio, "avatar");
        enemyAttackController.forward();
      }
    } else if (status == AnimationStatus.dismissed) {
      setState(() => enemyDamageStatus = EnemyDamageStatus.forwadable);
    } else {
      setState(() => enemyDamageStatus = EnemyDamageStatus.animating);
    }
    print("---> $enemyDamageStatus");
  }

  void onPressed() async {
    print("run onPressed");
    // controller.forward();
    // if (avatarspeed > enemyspeed) {
    calcDamage(enemyLpWidth, enemyLp, enemyWidthRatio, "enemy");
    avatarAttackController.forward();
    // } else {
    // enemyAttackFlag = true;
    // avatarAttackFlag = false;
    // calcDamage(avatarLpWidth, avatarLp, avatarWidthRatio, "avatar");
    // enemyAttackController.forward();
    // }
    // if (avatarStatus == AvatarStatus.reversible) {
    //   print("reverse!");
    //   avatarController.reverse();
    //   enemyController.reverse();
    //   damageController.reverse();
    // } else {
    //   print("forward!");
    //   avatarController.forward();
    //   enemyController.forward();
    //   damageController.forward();
    // }
  }

  @override
  void dispose() {
    print("run dispose");
    avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var avatarTween = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.center, end: Alignment.centerRight),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.centerRight, end: Alignment.center),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 4,
      ),
    ]);

    var avatarAttackTween = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 4,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.center, end: Alignment.centerRight),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.centerRight, end: Alignment.centerLeft),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.centerLeft, end: Alignment.center),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 4,
      ),
    ]);

    var enemyTween = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.center, end: Alignment.centerLeft),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.centerLeft, end: Alignment.center),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 4,
      ),
    ]);

    var enemyAttackTween = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 4,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.center, end: Alignment.centerLeft),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.centerLeft, end: Alignment.centerRight),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.centerRight, end: Alignment.center),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: ConstantTween(Alignment.center),
        weight: 4,
      ),
    ]);

    var damageTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 2,
      ),
    ]);

    var healingTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 2,
      ),
    ]);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: enemyId == 1
                ? AssetImage('assets/bgimage_battle1.png')
                : AssetImage('assets/bgimage_battle2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            width: 100,
                            height: 100,
                            // color: Colors.blueAccent,
                            child: FadeTransition(
                              opacity:
                                  damageTween.animate(enemyDamageController),
                              child: Text(
                                damage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "${enemyLp.toInt()}/${enemyMaxLp.toInt()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 13),
                              color: Colors.black,
                              width: 80,
                              height: 10,
                            ),
                            AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              margin: EdgeInsets.only(left: 13),
                              color: Colors.orange,
                              width: enemyLpWidth,
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 105,
                              child: Image.asset("assets/battle_lifepoint.png"),
                            ),
                          ],
                        ),
                        // SizedBox(height: 20),
                        AnimatedOpacity(
                          duration: const Duration(seconds: 2),
                          opacity: enemyOpacity,
                          child: Container(
                            // color: Colors.red,
                            width: enemyId == 1 ? 170 : 250,
                            height: enemyId == 1 ? 200 : 270,
                            child: AlignTransition(
                              // ↓ Animation<AlignmentGeometry>をセット
                              alignment: enemyAttackFlag
                                  ? enemyAttackTween
                                      .animate(enemyAttackController)
                                  : enemyTween.animate(enemyController),
                              child: SizedBox(
                                height: enemyId == 1
                                    ? size.deviceHeight * 0.15
                                    : size.deviceHeight * 0.2,
                                child: enemyId == 1
                                    ? Image.asset("assets/battle_enemy1.png")
                                    : Image.asset("assets/battle_enemy2.png"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: size.deviceWidth * 0.08),
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: 100,
                              height: 100,
                              // color: Colors.blueAccent,
                              child: FadeTransition(
                                opacity:
                                    damageTween.animate(avatarDamageController),
                                child: Text(
                                  damage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: 100,
                              height: 100,
                              // color: Colors.blueAccent,
                              child: FadeTransition(
                                opacity: healingTween
                                    .animate(avatarHealingController),
                                child: Text(
                                  '+$healing',
                                  style: TextStyle(
                                    color: Colors.greenAccent[400],
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${avatarLp.toInt()}/${avatarMaxLp.toInt()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 13),
                              color: Colors.black,
                              width: 80,
                              height: 10,
                            ),
                            AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              margin: EdgeInsets.only(left: 13),
                              color: Colors.orange,
                              width: avatarLpWidth,
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 105,
                              child: Image.asset("assets/battle_lifepoint.png"),
                            ),
                          ],
                        ),
                        // SizedBox(height: 20),
                        AnimatedOpacity(
                          duration: const Duration(seconds: 2),
                          opacity: avatarOpacity,
                          child: Container(
                            // color: Colors.red,
                            width: enemyId == 1 ? 170 : 120,
                            height: 200,
                            child: AlignTransition(
                              // ↓ Animation<AlignmentGeometry>をセット
                              alignment: avatarAttackFlag
                                  ? avatarAttackTween
                                      .animate(avatarAttackController)
                                  : avatarTween.animate(avatarController),
                              child: SizedBox(
                                  height: enemyId == 1
                                      ? size.deviceHeight * 0.2
                                      : size.deviceHeight * 0.15,
                                  child:
                                      Image.asset("assets/battle_avatar.png")),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // SizedBox(height: size.deviceHeight * 0.05),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 229, 229, 229),
                        border: Border.all(
                          color: Color.fromARGB(255, 77, 77, 77),
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(
                          top: 20, left: 30, bottom: 80, right: 30),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  TextButton(
                                    onPressed: buttonFlag
                                        ? () {
                                            print("Attack! : $avatarStatus");
                                            buttonFlag = false;
                                            if (avatarStatus !=
                                                AvatarStatus.animating) {
                                              onPressed();
                                            }
                                          }
                                        : null,
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    child: SizedBox(
                                      width: size.deviceWidth * 0.32,
                                      child: Image.asset(
                                          "assets/battle_attack.png"),
                                    ),
                                  ),
                                  buttonFlag
                                      ? Container()
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          width: size.deviceWidth * 0.32,
                                          height: 50,
                                        ),
                                ],
                              ),
                              // const SizedBox(width: 15),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  TextButton(
                                    onPressed: null,
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    child: SizedBox(
                                      width: size.deviceWidth * 0.32,
                                      child: Image.asset(
                                          "assets/battle_masic.png"),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    width: size.deviceWidth * 0.32,
                                    height: 50,
                                  ),
                                  const Text(
                                    "Coming soon...",
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  TextButton(
                                    onPressed: buttonFlag
                                        ? () {
                                            print("Use the item!");
                                            setState(() {
                                              itemFlag = true;
                                            });
                                          }
                                        : null,
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    child: SizedBox(
                                      width: size.deviceWidth * 0.32,
                                      child:
                                          Image.asset("assets/battle_item.png"),
                                    ),
                                  ),
                                  buttonFlag
                                      ? Container()
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          width: size.deviceWidth * 0.32,
                                          height: 50,
                                        ),
                                ],
                              ),
                              // const SizedBox(width: 15),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  TextButton(
                                    onPressed: buttonFlag
                                        ? () {
                                            print("Escape...");
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  insetPadding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: EscapeDialog(),
                                                );
                                              },
                                            );
                                          }
                                        : null,
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    child: SizedBox(
                                      width: size.deviceWidth * 0.32,
                                      child: Image.asset(
                                          "assets/battle_escape.png"),
                                    ),
                                  ),
                                  buttonFlag
                                      ? Container()
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          width: size.deviceWidth * 0.32,
                                          height: 50,
                                        ),
                                ],
                              ),
                            ],
                          ),
                          // const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // 道具使用時
            itemFlag
                ? Container(
                    height: size.deviceHeight * 0.35,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 229, 229, 229),
                      border: Border.all(
                        color: Color.fromARGB(255, 77, 77, 77),
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20, left: 30, bottom: 80, right: 30),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: size.deviceHeight * 0.35,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 229, 229, 229),
                            border: Border.all(
                              color: Color.fromARGB(255, 77, 77, 77),
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var item in itemList)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = item['index'] as int;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(boxShadow: [
                                            BoxShadow(
                                                color: selectedIndex ==
                                                        item['index']
                                                    ? Colors.yellow
                                                        .withOpacity(0.8)
                                                    : Colors.transparent,
                                                blurRadius: 1.0,
                                                offset: Offset(0.0, 0.5)),
                                          ]),
                                          margin: EdgeInsets.only(
                                              top: 3, bottom: 3),
                                          padding: EdgeInsets.all(5),
                                          width: size.deviceWidth * 0.35,
                                          child: Image.asset(
                                              'assets/${item['imageName']}'),
                                        ),
                                        itemCanUseFlag
                                            ? Container()
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                width: size.deviceWidth * 0.32,
                                                height: 50,
                                              ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: size.deviceWidth * 0.29,
                              child:
                                  Image.asset('assets/battle_itemicon_bag.png'),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                if (itemCanUseFlag) {
                                  print("使う");
                                  print(itemList[selectedIndex]);
                                  itemFlag = false;
                                  itemCanUseFlag = false;
                                  calcHealing(avatarLpWidth, avatarLp,
                                      avatarWidthRatio, "avatar");
                                  avatarHealingController.forward();
                                  // if (itemList[selectedIndex]) {}
                                }
                              },
                              style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: size.deviceWidth * 0.25,
                                    child: Image.asset(
                                        "assets/battle_itembutton_use.png"),
                                  ),
                                  itemCanUseFlag
                                      ? Container()
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          width: size.deviceWidth * 0.25,
                                          height: 50,
                                        ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                print("戻る");
                                setState(() {
                                  itemFlag = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                              ),
                              child: SizedBox(
                                width: size.deviceWidth * 0.25,
                                child: Image.asset(
                                    "assets/battle_itembutton_back.png"),
                              ),
                            ),
                            // const SizedBox(height: 40),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

// Widget getSurface(Surface surface) {
//   if (logoStatus == LogoStatus.reversible) {
//     return surface == Surface.icon
//         ? const Icon(Icons.arrow_downward)
//         : const Text('Reverse');
//   } else if (logoStatus == LogoStatus.forwadable) {
//     return surface == Surface.icon
//         ? const Icon(Icons.arrow_upward)
//         : const Text('Forward');
//   } else {
//     return surface == Surface.icon
//         ? const Icon(Icons.stop)
//         : const Text('Please wait');
//   }
// }

// class EnemyTwo extends StatelessWidget {
//   const EnemyTwo({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/bgimage_battle2.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.orange,
//                         ),
//                         width: size.deviceHeight * 0.15,
//                         height: 18,
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         width: size.deviceHeight * 0.15,
//                         child: Image.asset("assets/battle_lifepoint.png"),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: size.deviceHeight * 0.3,
//                     child: Image.asset("assets/battle_enemy2.png"),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.orange,
//                         ),
//                         width: size.deviceHeight * 0.1,
//                         height: 12,
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         width: size.deviceHeight * 0.1,
//                         child: Image.asset("assets/battle_lifepoint.png"),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: size.deviceHeight * 0.15,
//                     child: Image.asset("assets/battle_avatar.png"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: size.deviceHeight * 0.1),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: size.deviceWidth * 0.4,
//                 child: Image.asset("assets/battle_attack.png"),
//               ),
//               const SizedBox(width: 15),
//               SizedBox(
//                 width: size.deviceWidth * 0.4,
//                 child: Image.asset("assets/battle_masic.png"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: size.deviceWidth * 0.4,
//                 child: Image.asset("assets/battle_item.png"),
//               ),
//               const SizedBox(width: 15),
//               SizedBox(
//                 width: size.deviceWidth * 0.4,
//                 child: Image.asset("assets/battle_escape.png"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

class EscapeDialog extends StatefulWidget {
  EscapeDialog({Key? key}) : super(key: key);

  @override
  State<EscapeDialog> createState() => _EscapeDialogState();
}

class _EscapeDialogState extends State<EscapeDialog> {
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
                  "本当に逃げますか？",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        // ホーム画面の変数に反映する
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: size.deviceHeight * 0.025,
                        child: Image.asset('assets/battle_dialog_cancel.png')),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        // ホーム画面の変数に反映する
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HomeScreen(title: "RAGOUT")),
                          (_) => false);
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: size.deviceHeight * 0.025,
                        child: Image.asset('assets/battle_dialog_escape.png')),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
