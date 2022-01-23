import 'package:app/importer.dart';
import 'package:app/widgets/dressup_submit_button.dart';
import 'package:app/widgets/status_chart.dart';

class DressupScreen extends StatefulWidget {
  DressupScreen({Key? key}) : super(key: key);

  @override
  _DressupScreenState createState() => _DressupScreenState();
}

var size = SizeConfig();

class _DressupScreenState extends State<DressupScreen> {
  @override
  Widget build(BuildContext context) {
    size.init(context);
    final tops = <String>[
      "dressup_clothe1.png",
      "dressup_clothe2.png",
      "dressup_clothe3.png",
      "dressup_clothe4.png",
      "dressup_clothe4.png",
    ];
    final pants = <String>[
      "dressup_clothe1.png",
      "dressup_clothe2.png",
      "dressup_clothe3.png",
      "dressup_clothe4.png",
      "dressup_clothe4.png",
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgimage_dressup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: size.deviceWidth * 0.45,
                child: Image.asset(
                  'assets/dressup_avatar.png',
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                width: size.deviceWidth * 0.95,
                height: size.deviceHeight * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var t in tops)
                            Card(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.asset("assets/$t"),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 5,
                      color: Colors.black38,
                      indent: 10,
                      endIndent: 10,
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var p in pants)
                            Card(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.asset("assets/$p"),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const DressupSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
