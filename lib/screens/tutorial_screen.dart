import 'package:app/importer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dots_indicator/dots_indicator.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<TutorialScreen> {
  late List<Widget> _pageItems;
  final _controller = PageController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _pageItems = [];
    for (var i = 0; i < 7; i++) {
      Widget item = Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[Colors.blueGrey, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Text("$i", style: const TextStyle(fontSize: 30.0)),
      );
      _pageItems.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height * 0.6;
    double buttonHeight = MediaQuery.of(context).size.height * 0.1;
    //double _postion = 0.0;

    void _showTutorial(BuildContext context) async {
      final pref = await SharedPreferences.getInstance();
      pref.setBool('isFirstLaunch', true);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("チュートリアル風画面"),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: pageHeight,
                child: PageView(
                  children: _pageItems,
                  controller: _controller,
                ),
              ),
              ButtonTheme(
                height: buttonHeight,
                child: TextButton(
                  child: const Text("スキップ"),
                  onPressed: () {
                    _showTutorial(context);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: DotsIndicator(
                    // controller: _controller,
                    dotsCount: _pageItems.length,
                    decorator: const DotsDecorator(
                      color: Colors.black,
                      activeColor: Colors.red,
                    ),
                    // position: 2.0
                    // onPageSelected: (_) {},
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
