import 'package:app/importer.dart';
import 'package:app/models/return.dart';
import 'package:app/screens/battle_win_screen.dart';

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
  late final AnimationController enemyDamageController;
  AvatarStatus avatarStatus = AvatarStatus.forwadable;
  AvatarAttackStatus avatarAttackStatus = AvatarAttackStatus.forwadable;
  EnemyStatus enemyStatus = EnemyStatus.forwadable;
  EnemyAttackStatus enemyAttackStatus = EnemyAttackStatus.forwadable;
  AvatarDamageStatus avatarDamageStatus = AvatarDamageStatus.forwadable;
  EnemyDamageStatus enemyDamageStatus = EnemyDamageStatus.forwadable;
  double avatarLp = 200;
  double avatarLpWidth = 80;
  double avatarWidthRatio = 0;
  double enemyLp = 100;
  double enemyLpWidth = 80;
  double enemyWidthRatio = 0;
  double avatarOpacity = 1.0;
  double enemyOpacity = 1.0;
  double updateAvatarLp = 0;
  double updateAvatarLpWidth = 0;
  double updateAvatarOpacity = 0.0;
  double updateEnemyLp = 0;
  double updateEnemyLpWidth = 0;
  double updateEnemyOpacity = 0.0;
  bool enemyAttackFlag = false;
  bool avatarAttackFlag = true;
  bool buttonFlag = true;

  void calcDamage(double width, double lp, double widthRatio, String target) {
    print("run calcDamage");
    // ダメージ計算関数
    lp = lp - 100;
    if (lp < 0) {
      lp = 0;
    }
    width = lp * widthRatio < 1 ? 0 : lp * widthRatio;

    if (target == "avatar") {
      // setState(() {
      updateAvatarLpWidth = width;
      updateAvatarLp = lp;
      if (lp == 0) {
        updateAvatarOpacity = 0.0;
      }
      // });
    } else if (target == "enemy") {
      // setState(() {
      updateEnemyLpWidth = width;
      updateEnemyLp = lp;
      if (lp == 0) {
        updateEnemyOpacity = 0.0;
      }
      // });
    }
  }

  @override
  void initState() {
    super.initState();
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

    enemyDamageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener(enemyDamageStatusListener);

    // 1ダメージに対して減らす体力ゲージの比率計算
    enemyWidthRatio = enemyLpWidth / enemyLp;
    avatarWidthRatio = avatarLpWidth / avatarLp;
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
    if (status == AnimationStatus.completed) {
      setState(() {
        enemyStatus = EnemyStatus.reversible;
        // 攻撃したら攻撃不可能にする
        avatarAttackFlag = false;
      });
      avatarAttackController.reset();
    } else if (status == AnimationStatus.dismissed) {
      setState(() => enemyStatus = EnemyStatus.forwadable);
    } else {
      setState(() => enemyStatus = EnemyStatus.animating);
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
        enemyAttackFlag = true;
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
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  child: BattleWinScreen(),
                );
              },
            );
          });
        }
      });
      enemyController.reset();
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
      avatarController.forward();
    }
    print("---> $avatarStatus");
  }

  void avatarDamageStatusListener(AnimationStatus status) {
    print("avatarDamageStatusListener: $status");
    if (status == AnimationStatus.completed) {
      setState(() => avatarDamageStatus = AvatarDamageStatus.reversible);
      avatarDamageController.reset();
    } else if (status == AnimationStatus.dismissed) {
      setState(() => avatarDamageStatus = AvatarDamageStatus.forwadable);
    } else {
      setState(() => avatarDamageStatus = AvatarDamageStatus.animating);
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
    calcDamage(enemyLpWidth, enemyLp, enemyWidthRatio, "enemy");
    avatarAttackController.forward();
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

    return Scaffold(
      body: Container(
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
                Column(
                  children: [
                    Center(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: 100,
                        height: 100,
                        // color: Colors.blueAccent,
                        child: FadeTransition(
                          opacity: damageTween.animate(enemyDamageController),
                          child: Text(
                            "-100",
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
                      "${enemyLp.toInt()}",
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
                    SizedBox(height: 20),
                    AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: enemyOpacity,
                      child: Container(
                        // color: Colors.red,
                        width: 170,
                        height: 200,
                        child: AlignTransition(
                          // ↓ Animation<AlignmentGeometry>をセット
                          alignment: enemyAttackFlag
                              ? enemyAttackTween.animate(enemyAttackController)
                              : enemyTween.animate(enemyController),
                          child: SizedBox(
                              height: size.deviceHeight * 0.15,
                              child: Image.asset("assets/battle_enemy1.png")),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: size.deviceWidth * 0.08),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: 100,
                      height: 100,
                      // color: Colors.blueAccent,
                      child: FadeTransition(
                        opacity: damageTween.animate(avatarDamageController),
                        child: Text(
                          "-100",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${avatarLp.toInt()}",
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
                    SizedBox(height: 20),
                    AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: avatarOpacity,
                      child: Container(
                        // color: Colors.red,
                        width: 170,
                        height: 200,
                        child: AlignTransition(
                          // ↓ Animation<AlignmentGeometry>をセット
                          alignment: avatarAttackFlag
                              ? avatarAttackTween
                                  .animate(avatarAttackController)
                              : avatarTween.animate(avatarController),
                          child: SizedBox(
                              height: size.deviceHeight * 0.2,
                              child: Image.asset("assets/battle_avatar.png")),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // SizedBox(height: size.deviceHeight * 0.05),
            Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                border: Border.all(
                  color: Colors.black,
                  width: 3,
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
                      TextButton(
                        onPressed: () {
                          print("Attack! : $avatarStatus");
                          if (avatarStatus != AvatarStatus.animating) {
                            onPressed();
                          }
                        },
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: SizedBox(
                          width: size.deviceWidth * 0.32,
                          child: Image.asset("assets/battle_attack.png"),
                        ),
                      ),
                      // const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {
                          print("Masic!");
                        },
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: SizedBox(
                          width: size.deviceWidth * 0.32,
                          child: Image.asset("assets/battle_masic.png"),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          print("Use the item!");
                        },
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: SizedBox(
                          width: size.deviceWidth * 0.32,
                          child: Image.asset("assets/battle_item.png"),
                        ),
                      ),
                      // const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {
                          print("Escape...");
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                child: EscapeDialog(),
                              );
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: SizedBox(
                          width: size.deviceWidth * 0.32,
                          child: Image.asset("assets/battle_escape.png"),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 40),
                ],
              ),
            ),
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
                  "本当に逃げますか？\n(この冒険で使用したアイテムは元に戻りません。)",
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
                        height: size.deviceHeight * 0.03,
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
                        height: size.deviceHeight * 0.03,
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
