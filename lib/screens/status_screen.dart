import 'package:app/importer.dart';
import 'package:app/widgets/status_chart.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  int _counter = 5;
  List<double> values1 = [0.4, 0.8, 0.65, 0.8, 1];
  List<double> values2 = [0.5, 0.3, 0.85, 0.8, 1];
  late List<PreferredSizeWidget> vertices2;
  late PreferredSizeWidget _vertex;

  @override
  void initState() {
    super.initState();
    const double radius = 5;
    _vertex = const PreferredSize(
      preferredSize: Size.square(2 * radius),
      child: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        radius: radius,
      ),
    );

    vertices2 = [_vertex, _vertex, _vertex, _vertex, _vertex];
  }

  void _incrementCounter() {
    final random = Random.secure();
    setState(() {
      _counter++;
      values1.add(random.nextDouble());
      values2.add(random.nextDouble());
      vertices2.add(_vertex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBarを隠す
        backgroundColor: Color.fromRGBO(242, 242, 242, 1.0),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgimage_status.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: StatusRadarChart(),
            ),
            DressupButton(),
          ],
        ),
      ),
    );
  }
}
