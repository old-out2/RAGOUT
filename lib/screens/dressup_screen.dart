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

class OutersClotheData {
  final int index;
  final String outersClothe;

  OutersClotheData({
    required this.index,
    required this.outersClothe,
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

class ShoesClotheData {
  final int index;
  final String shoesClothe;

  ShoesClotheData({
    required this.index,
    required this.shoesClothe,
  });
}

final tops = <String>[
  "dressup_clothe1.png",
  "dressup_clothe2.png",
  "dressup_clothe3.png",
  "dressup_clothe5.png",
  "dressup_clothe6.png",
];
final outers = <String>[
  "dressup_clothe4.png",
  "dressup_clothe7.png",
  "dressup_clothe8.png",
];
final bottoms = <String>[
  "dressup_clothe9.png",
  "dressup_clothe10.png",
];
final shoes = <String>[
  "dressup_clothe11.png",
];

class DressupScreen extends StatefulWidget {
  DressupScreen({Key? key}) : super(key: key);

  @override
  _DressupScreenState createState() => _DressupScreenState();
}

var size = SizeConfig();

class _DressupScreenState extends State<DressupScreen> {
  int _selectedTopsIndex = 0;
  int _selectedOutersIndex = 0;
  int _selectedBottomsIndex = 0;
  int _selectedShoesIndex = 0;

  final List<TopsClotheData> topsClothes = [
    for (int i = 0; i < tops.length; i++)
      TopsClotheData(index: i, topsClothe: tops[i], clothingType: "tops")
  ];

  final List<OutersClotheData> outersClothes = [
    for (int i = 0; i < tops.length; i++)
      OutersClotheData(index: i, outersClothe: outers[i])
  ];

  final List<BottomsClotheData> bottomsClothes = [
    for (int i = 0; i < bottoms.length; i++)
      BottomsClotheData(index: i, bottomsClothe: bottoms[i])
  ];

  final List<ShoesClotheData> shoesClothe = [
    for (int i = 0; i < shoes.length; i++)
      ShoesClotheData(index: i, shoesClothe: shoes[i])
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
                              child: Image.asset(
                                  "assets/${shoesClothe[_selectedShoesIndex].shoesClothe}"),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 198, left: 5, bottom: 5, right: 5),
                              // color: Colors.black.withOpacity(0.3),
                              width: 58,
                              height: 60,
                              child: Image.asset(
                                  "assets/${bottomsClothes[_selectedBottomsIndex].bottomsClothe}"),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: (_selectedTopsIndex == 4) ? 133 : 148,
                                  left: 5,
                                  bottom: 0,
                                  right: 5),
                              // color: Colors.black.withOpacity(0.3),
                              width: (_selectedTopsIndex == 4) ? 80 : 70,
                              height: (_selectedTopsIndex == 4) ? 100 : 70,
                              child: Image.asset(
                                  "assets/${topsClothes[_selectedTopsIndex].topsClothe}"),
                            ),
                          ),
                          // Center(
                          //   child: Container(
                          //     margin: EdgeInsets.only(
                          //         top: (_selectedTopsIndex == 4) ? 133 : 148,
                          //         left: 5,
                          //         bottom: 0,
                          //         right: 5),
                          //     // color: Colors.black.withOpacity(0.3),
                          //     width: (_selectedOutersIndex == 4) ? 80 : 70,
                          //     height: (_selectedOutersIndex == 4) ? 100 : 70,
                          //     child: Image.asset(
                          //         "assets/${outersClothes[_selectedOutersIndex].outersClothe}"),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  },
                  onAccept: (data) {
                    setState(() {
                      // ifで条件分岐
                      if (data % 10 == 1) {
                        _selectedTopsIndex = (data - 1) ~/ 10;
                      } else if (data % 10 == 2) {
                        _selectedBottomsIndex = ((data - 2) ~/ 10);
                      } else if (data % 10 == 3) {
                        _selectedShoesIndex = ((data - 3) ~/ 10);
                      }
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
                        // for (var clothe in outersClothes)
                        //   OutersClothing(data: clothe),
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
                        for (var clothe in shoesClothe)
                          ShoesClothing(data: clothe),
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
      data: data.index * 10 + 1,
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

class OutersClothing extends StatelessWidget {
  const OutersClothing({
    Key? key,
    required this.data,
  }) : super(key: key);

  final OutersClotheData data;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: data.index * 10 + 1,
      child: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.outersClothe}"),
      ),
      feedback: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.outersClothe}"),
      ),
      childWhenDragging: Container(
        margin: EdgeInsets.all(5),
        color: Colors.black.withOpacity(0.3),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.outersClothe}"),
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
      data: data.index * 10 + 2,
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

class ShoesClothing extends StatelessWidget {
  const ShoesClothing({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ShoesClotheData data;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: data.index * 10 + 3,
      child: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.shoesClothe}"),
      ),
      feedback: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.shoesClothe}"),
      ),
      childWhenDragging: Container(
        margin: EdgeInsets.all(5),
        color: Colors.black.withOpacity(0.3),
        width: 70,
        height: 70,
        child: Image.asset("assets/${data.shoesClothe}"),
      ),
    );
  }
}
