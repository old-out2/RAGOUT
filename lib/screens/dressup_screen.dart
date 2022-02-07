import 'package:app/importer.dart';
import 'package:app/widgets/dressup_submit_button.dart';
import 'package:app/widgets/status_chart.dart';

class TopsClotheData {
  final int index;
  final String topsClothe;
  final String clothingType;

  TopsClotheData({
    required this.index,
    required this.topsClothe,
    required this.clothingType,
  });
}

class BottomsClotheData {
  final int index;
  final String bottomsClothe;

  BottomsClotheData({
    required this.index,
    required this.bottomsClothe,
  });
}

final tops = <String>[
  "dressup_clothe1.png",
  "dressup_clothe2.png",
  "dressup_clothe3.png",
  "dressup_clothe4.png",
  "dressup_clothe5.png",
  "dressup_clothe6.png",
  "dressup_clothe7.png",
  "dressup_clothe8.png",
];
final bottoms = <String>[
  "dressup_clothe9.png",
  "dressup_clothe10.png",
  "dressup_clothe11.png",
];

class DressupScreen extends StatefulWidget {
  DressupScreen({Key? key}) : super(key: key);

  @override
  _DressupScreenState createState() => _DressupScreenState();
}

var size = SizeConfig();

class _DressupScreenState extends State<DressupScreen> {
  int _selectedIndex = 0;

  final List<TopsClotheData> topsClothes = [
    for (int i = 0; i < tops.length; i++)
      TopsClotheData(index: i, topsClothe: tops[i], clothingType: "tops")
  ];

  final List<BottomsClotheData> bottomsClothes = [
    for (int i = 0; i < bottoms.length; i++)
      BottomsClotheData(index: i, bottomsClothe: bottoms[i])
  ];

  @override
  Widget build(BuildContext context) {
    size.init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgimage_dressup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: size.deviceWidth * 0.45,
                    child: Image.asset(
                      'assets/dressup_avatar.png',
                    ),
                  ),
                ),
                DragTarget<int>(
                  builder: (context, _, __) {
                    return Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 210, left: 5, bottom: 5, right: 5),
                              // color: Colors.black.withOpacity(0.3),
                              width: 58,
                              height: 70,
                              child: Image.asset("assets/dressup_clothe11.png"),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 198, left: 5, bottom: 5, right: 5),
                              // color: Colors.black.withOpacity(0.3),
                              width: 58,
                              height: 60,
                              child: Image.asset("assets/dressup_clothe9.png"),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 148, left: 5, bottom: 0, right: 5),
                              // color: Colors.black.withOpacity(0.3),
                              width: 70,
                              height: 70,
                              child: Image.asset(
                                  "assets/${topsClothes[_selectedIndex].topsClothe}"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onAccept: (data) {
                    setState(() {
                      _selectedIndex = data;
                    });
                  },
                ),
              ],
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
                        for (var clothe in topsClothes)
                          TopsClothing(data: clothe),
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
                        for (var clothe in bottomsClothes)
                          BottomsClothing(data: clothe),
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
    );
  }
}

class TopsClothing extends StatelessWidget {
  const TopsClothing({
    Key? key,
    required this.data,
  }) : super(key: key);

  final TopsClotheData data;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: data.index,
      child: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.topsClothe}"),
      ),
      feedback: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.topsClothe}"),
      ),
      childWhenDragging: Container(
        margin: EdgeInsets.all(5),
        color: Colors.black.withOpacity(0.3),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.topsClothe}"),
      ),
    );
  }
}

class BottomsClothing extends StatelessWidget {
  const BottomsClothing({
    Key? key,
    required this.data,
  }) : super(key: key);

  final BottomsClotheData data;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: data.index,
      child: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.bottomsClothe}"),
      ),
      feedback: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.bottomsClothe}"),
      ),
      childWhenDragging: Container(
        margin: EdgeInsets.all(5),
        color: Colors.black.withOpacity(0.3),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.bottomsClothe}"),
      ),
    );
  }
}
