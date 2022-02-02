import 'package:app/importer.dart';
import 'package:app/screens/tutorial/sliding_tutorial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> notifier = ValueNotifier(0);
    final _pageCtrl = PageController();
    int pageCount = 2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Stack(
        children: <Widget>[
          /// [StatefulWidget] with [PageView] and [AnimatedBackgroundColor].
          FutureBuilder(
              future: Future.value(true),
              builder: (BuildContext context, AsyncSnapshot<void> snap) {
                if (!snap.hasData) {
                  return Container();
                }
                return SlidingTutorial(
                  controller: _pageCtrl,
                  pageCount: pageCount,
                  notifier: notifier,
                );
              }),

          /// Separator.
          Align(
            alignment: Alignment(0, 0.85),
            child: Container(
              width: double.infinity,
              height: 0.5,
              color: Colors.white,
            ),
          ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.arrow_back_ios_rounded,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       _pageCtrl.previousPage(
          //         duration: Duration(milliseconds: 600),
          //         curve: Curves.linear,
          //       );
          //     },
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.arrow_back_ios_rounded,
          //       color: Colors.white,
          //       textDirection: TextDirection.rtl,
          //     ),
          //     onPressed: () {
          //       _pageCtrl.nextPage(
          //         duration: Duration(milliseconds: 600),
          //         curve: Curves.linear,
          //       );
          // },
          // ),
          // ),

          /// [SlidingIndicator] for [PageView] in [SlidingTutorial].
          Align(
            alignment: Alignment(0, 0.94),
            child: SlidingIndicator(
              indicatorCount: pageCount,
              notifier: notifier,
              activeIndicator: Icon(
                Icons.check_box,
                color: Color(0xFF29B6F6),
              ),
              inActiveIndicator: Icon(
                Icons.check_box,
                color: Colors.white,
              ),
              // inActiveIndicator: SvgPicture.asset(
              //   "assets/hollow_circle.svg",
              // ),
              margin: 8,
              inactiveIndicatorSize: 20,
              activeIndicatorSize: 20,
            ),
          )
        ],
      )),
    );
  }
}
