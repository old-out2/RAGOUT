import 'dart:ffi';

import 'package:app/importer.dart';
import 'package:app/models/return.dart';
import 'package:app/screens/tutorial/tutorial_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:health/health.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAGOUT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Hiragino Maru Gothic ProN',
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const HomeScreen(title: 'RAGOUT'),
        '/tutorial': (BuildContext context) => const TutorialScreen(),
      },
      // ここを追加する。
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // ここを追加する。
      supportedLocales: const [
        Locale("en"),
        Locale("ja"),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int widgetIndex = 1;
  bool _consumeCalVisible = false;
  bool _bornCalVisible = true;
  var list = Calorie();
  int showSection = 1;
  int _nofSteps = 0;
  int defaultKcal = 0;
  double expPoint = 120;
  // DBから取ってくるようにする
  int level = 1;
  String title = "新人戦士";
  // 歩数取得用
  HealthFactory health = HealthFactory();

  Future checkBurnCalories() async {}

  Future fetchStepData() async {
    int? steps;
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      return steps;
    } else {
      print("Authorization not granted");
    }
  }

  void init() async {
    defaultKcal = await list.calculateDefaultKcal();
    _nofSteps = await fetchStepData();
  }

  @override
  void initState() {
    var size = SizeConfig();
    super.initState();
    init();
    WidgetsBinding.instance?.addObserver(this);
    // double kal = totalKal - Database.calculateKcal(_nofSteps);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('isFirstLaunch') != true) {
        await Navigator.of(context).pushNamed('/tutorial');
      }
    });

    Future.delayed(Duration(seconds: 5), () {
      changeWidget(_bornCalVisible, _consumeCalVisible);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // アプリがバックグラウンドに行ったとき
    } else if (state == AppLifecycleState.resumed) {
      // アプリが復帰したとき
      int nowSteps = await fetchStepData();
      print("nowSteps: $nowSteps");
      final int backgroundSteps = nowSteps - _nofSteps;
      print("backgroundSteps: $backgroundSteps");
      final defaultKcal = await list.calculateDefaultKcal();
      print("defaultKcal: $defaultKcal");
      final tagetSteps = await list.calculateTargetSteps();
      print("tagetSteps: $tagetSteps");

      // 目標を達成してるかどうかの判定処理
      if (tagetSteps - nowSteps <= 0) {
        // 目標達成処理
        showGoalAchievementDialog(nowSteps, backgroundSteps, defaultKcal);
      } else if (tagetSteps - nowSteps > 0) {
        // バックグラウンド起動中にどれだけ歩いたか表示
        showStepsDialog(nowSteps, backgroundSteps, defaultKcal, tagetSteps);
      }
    } else if (state == AppLifecycleState.inactive) {
      // アプリの停止時
    } else if (state == AppLifecycleState.detached) {
      // アプリが終了したとき
    }
  }

  void changeWidget(bool bornCalVisible, bool consumeCalVisible) {
    // print(visible);
    setState(() {
      _bornCalVisible = !bornCalVisible;
      _consumeCalVisible = !consumeCalVisible;
    });
    Future.delayed(Duration(seconds: 5), () {
      changeWidget(_bornCalVisible, _consumeCalVisible);
    });
  }

  void showStepsDialog(
      int nowSteps, int backgroundSteps, int defaultKcal, int tagetSteps) {
    print("run shoeStepsDialog");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: CheckCalDialog(
            name: "にの",
            backgroundSteps: backgroundSteps,
            nowSteps: nowSteps,
            tagetSteps: tagetSteps,
          ),
        );
      },
    );
  }

  void showGoalAchievementDialog(
      int nowSteps, int backgroundSteps, int defaultKcal) {
    print("run showGoalAchievement");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: GoalAchievementDialog(
            name: "にの",
            backgroundSteps: backgroundSteps,
            nowSteps: nowSteps,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    size.init(context);
    List<Widget> showWidget = [
      TodaysBornCalories(
        list: list,
        totalSteps: _nofSteps,
        defaultKcal: defaultKcal,
      ),
      TodaysConsumedCalories(list: list),
    ];

    return Scaffold(
      appBar: AppBar(
        // AppBarを隠す
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bgimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 28),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "経験値  ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Lv.$level",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.orange,
                              ),
                              width: expPoint,
                              height: 27,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                border: Border.all(width: 3),
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.transparent,
                              ),
                              width: 200,
                              height: 27,
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   width: size.deviceWidth * 0.4,
                        //   child: Image.asset('assets/shelf.png'),
                        // ),
                      ],
                    ),
                    // Visibility(
                    //   visible: _visible,
                    //   child: showWidget[widgetIndex],
                    // ),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: _bornCalVisible ? 0.0 : 1.0,
                              duration: Duration(milliseconds: 300),
                              child: showWidget[0],
                            ),
                            AnimatedOpacity(
                              opacity: _consumeCalVisible ? 0.0 : 1.0,
                              duration: Duration(milliseconds: 300),
                              child: showWidget[1],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.deviceWidth * 0.4,
                          child: Image.asset('assets/shelf.png'),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "今日の歩数",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$_nofSteps歩",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: size.deviceWidth * 0.4,
                          child: Image.asset('assets/shelf.png'),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 70),
                    // SizedBox(height: 90),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        width: 180,
                        child: Image.asset("assets/titlelist_frame.png"),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  const AvatarButton(),
                  // 白い背景：#F2F2F2
                  // クリーム入り背景：#FFF1BC
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GrowthButton(),
                      TrophyButton(
                        onSave: (newTitle) {
                          setState(() {
                            title = newTitle;
                          });
                        },
                      ),
                      BattleButton(),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodaysConsumedCalories extends StatelessWidget {
  const TodaysConsumedCalories({
    Key? key,
    required this.list,
  }) : super(key: key);

  final Calorie list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "今日の摂取カロリー",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        FutureBuilder(
          future: list.callist(),
          builder: (context, snapshot) {
            return GestureDetector(
              // onTap: () {
              //   setState(() {});
              // },
              child: Text(
                "${(list.homecal ~/ 1).toString()}kcal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class TodaysBornCalories extends StatelessWidget {
  const TodaysBornCalories({
    Key? key,
    required this.list,
    required this.totalSteps,
    required this.defaultKcal,
  }) : super(key: key);

  final Calorie list;
  final int totalSteps;
  final int defaultKcal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "今日の残り消費カロリー",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        FutureBuilder(
          future: list.callist(),
          builder: (context, snapshot) {
            return GestureDetector(
              // onTap: () {
              //   setState(() {});
              // },
              child: Text(
                "${defaultKcal}kcal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CheckCalDialog extends StatefulWidget {
  CheckCalDialog({
    Key? key,
    required this.name,
    required this.backgroundSteps,
    required this.nowSteps,
    required this.tagetSteps,
  }) : super(key: key);

  String name;
  int backgroundSteps;
  int nowSteps;
  int tagetSteps;

  @override
  State<CheckCalDialog> createState() => _CheckCalDialogState();
}

class _CheckCalDialogState extends State<CheckCalDialog> {
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
                  "${widget.name}さんがアプリを起動していない間に${widget.backgroundSteps}歩きました!\n残り${widget.tagetSteps - widget.nowSteps}歩です!",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    // ホーム画面の変数に反映する
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
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

class GoalAchievementDialog extends StatefulWidget {
  GoalAchievementDialog({
    Key? key,
    required this.name,
    required this.backgroundSteps,
    required this.nowSteps,
  }) : super(key: key);

  String name;
  int backgroundSteps;
  int nowSteps;

  @override
  State<GoalAchievementDialog> createState() => _GoalAchievementDialogState();
}

class _GoalAchievementDialogState extends State<GoalAchievementDialog> {
  int targetSteps = 3000;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.deviceWidth * 0.9,
      height: size.deviceHeight * 0.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/check_cal_dialog.png"),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.deviceWidth * 0.8,
                child: Text(
                  "今日の目標消費カロリーを達成しました！\n報酬として、昨日食べた食品の栄養素\nタンパク質：104.4g\n脂質：45.2g\n炭水化物：221.9g\nビタミン：34.9g\nミネラル：11309.4g\nが${widget.name}さんに付与されます。",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    // ホーム画面の変数に反映する
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
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
