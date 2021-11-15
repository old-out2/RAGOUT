import 'package:app/importer.dart';

class StatusScreen extends StatefulWidget {
  StatusScreen({Key? key}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("ステータス"),
      ),
    );
  }
}
