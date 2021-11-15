import 'package:app/importer.dart';

class GrowthScreen extends StatefulWidget {
  GrowthScreen({Key? key}) : super(key: key);

  @override
  _GrowthScreenState createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("成長させる"),
      ),
    );
  }
}
