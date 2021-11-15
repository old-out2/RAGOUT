import 'package:app/importer.dart';

class BattleScreen extends StatefulWidget {
  BattleScreen({Key? key}) : super(key: key);

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("冒険する"),
      ),
    );
  }
}
