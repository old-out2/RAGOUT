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
      supportedLocales: [
        const Locale("en"),
        const Locale("ja"),
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
  var list = calorie();
  int showSection = 1;
  int _nofSteps = 0;
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

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
      });
    } else {
      print("Authorization not granted");
    }
  }

  @override
  void initState() {
    var size = SizeConfig();
    super.initState();
    fetchStepData();
    WidgetsBinding.instance?.addObserver(this);
    // double kal = totalKal - Database.calculateKal(_nofSteps);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // アプリがバックグラウンドに行ったとき
    } else if (state == AppLifecycleState.resumed) {
      // アプリが復帰したとき
      fetchStepData();

      // 目標を達成してるかどうかの判定処理
      // code ...

    } else if (state == AppLifecycleState.inactive) {
      // アプリの停止時
    } else if (state == AppLifecycleState.detached) {
      // アプリが終了したとき
    }
  }

  @override
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

  @override
  Widget build(BuildContext context) {
    size.init(context);
    List<Widget> showWidget = [
      TodaysBornCalories(list: list),
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

  final calorie list;

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
                "${(list.homecal ~/ 1).toString()}kal",
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
  }) : super(key: key);

  final calorie list;

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
                "1303kal",
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
