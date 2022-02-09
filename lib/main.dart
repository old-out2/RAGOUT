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
  var list = calorie();
  int _nofSteps = 0;
  double expPoint = 120;
  // DBから取ってくるようにする
  int level = 1;
  // 歩数取得用
  HealthFactory health = HealthFactory();

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
    WidgetsBinding.instance?.addObserver(this);
    fetchStepData();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var prefs = await SharedPreferences.getInstance();
      debugPrint("${prefs.getBool('isFirstLaunch')}");
      if (prefs.getBool('isFirstLaunch') != true) {
        await Navigator.of(context).pushNamed('/tutorial');
      }
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
  Widget build(BuildContext context) {
    size.init(context);

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
                margin: EdgeInsets.only(left: 28),
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
                    Column(
                      children: [
                        FutureBuilder(
                            future: list.callist(),
                            builder: (context, snapshot) {
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  child: Text(
                                    list.homecal.toString() + "kal",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ));
                            }),
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
                  const AvatarButton(),
                  // 白い背景：#F2F2F2
                  // クリーム入り背景：#FFF1BC
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      GrowthButton(),
                      TrophyButton(),
                      BattleButton(),
                    ],
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
