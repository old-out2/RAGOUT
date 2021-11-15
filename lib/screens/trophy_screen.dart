import 'package:app/importer.dart';

class TrophyScreen extends StatefulWidget {
  TrophyScreen({Key? key}) : super(key: key);

  @override
  _TrophyScreenState createState() => _TrophyScreenState();
}

class _TrophyScreenState extends State<TrophyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("称号一覧"),
      ),
    );
  }
}
