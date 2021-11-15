import 'package:app/importer.dart';

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
      ),
      home: const HomeScreen(title: 'RAGOUT'),
    );
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
              image: AssetImage('assets/home.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
              Row(
                children: [
                  const GrowthButton(),
                  const TrophyButton(),
                  const BattleButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
