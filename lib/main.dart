import 'package:app/importer.dart';
import 'package:app/screens/tutorial_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // void _showTutorial(BuildContext context) async {
  //   final pref = await SharedPreferences.getInstance();

  //   if (pref.getBool('isAlreadyFirstLaunch') != true) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const TutorialScreen(),
  //         fullscreenDialog: true,
  //       ),
  //     );
  //     pref.setBool('isAlreadyFirstLaunch', true);
  //   }
  // }

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
        });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var prefs = await SharedPreferences.getInstance();
      debugPrint("${prefs.getBool('isFirstLaunch')}");
      if (prefs.getBool('isFirstLaunch') != true) {
        await Navigator.of(context).pushNamed('/tutorial');
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(left: 28),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "経験値",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.orange,
                      ),
                      width: 160,
                      height: 30,
                      child: SizedBox(),
                    ),
                    const SizedBox(height: 70),
                    const Text(
                      "1,234kal",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 90),
                  ],
                ),
              ),

              const AvatarButton(),
              // Container(
              //   width: 120,
              //   height: 120,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8.0),
              //     image: DecorationImage(
              //       image: AssetImage('assets/growth.png'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              //   child: Material(
              //     color: Colors.transparent,
              //     child: InkWell(
              //       borderRadius: BorderRadius.circular(8.0),
              //       onTap: () {},
              //     ),
              //   ),
              // ),
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
        ),
      ),
    );
  }
}
