import 'package:app/importer.dart';
import 'package:app/widgets/manualinput_barcode_button.dart';
import 'package:app/widgets/manualinput_regist_button.dart';
import 'package:app/widgets/manualinput_search.dart';
import 'package:app/widgets/manualinput_slidar.dart';
import 'package:intl/intl.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  List<dynamic> _list = [];
  List<Map<String, String>> eatfood = [];
  late double totalcal = 0;

  @override
  Widget build(BuildContext context) {
    var size = SizeConfig();
    var weekdays = {
      1: "月",
      2: "火",
      3: "水",
      4: "木",
      5: "金",
      6: "土",
      7: "日",
    };
    DateTime nowDate = DateTime.now();
    String date = DateFormat('yyyy年MM月dd日(').format(nowDate) +
        weekdays[nowDate.weekday].toString() +
        "" +
        DateFormat(') HH:mm').format(nowDate);
    size.init(context);

    // final InputKey = GlobalObjectKey<_ManualInputSearchState>(context);

    void addFunction(Map<String, String> suggestion) {
      setState(() {
        totalcal += double.parse(suggestion['cal'].toString());
        _list.add(suggestion);
        eatfood.add({
          "date": DateFormat('yyyy/MM/dd').format(nowDate),
          "foodid": suggestion["id"].toString(),
          "barcode": null.toString(),
        });
      });
    }

    void deleteFuntion(int index) {
      setState(() {
        totalcal -= double.parse(_list[index]["cal"]);
        _list.remove(_list[index]);
        eatfood.removeAt(index);
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(254, 241, 188, 1),
      appBar: AppBar(
        // AppBarを隠す
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: EdgeInsets.all(size.deviceHeight * 0.06)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(4),
              ),
              height: size.deviceHeight * 0.7,
              width: size.deviceWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Image.asset('assets/manualinput_title.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ManualInputSearch(
                      nowDate: DateFormat('yyyy/MM/dd').format(nowDate),
                      list: _list,
                      eatfood: eatfood,
                      totalcal: totalcal,
                      stateFunction: addFunction,
                    ),
                  ),
                  SizedBox(
                    height: size.deviceHeight * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    width: size.deviceWidth * 0.6,
                    height: size.deviceHeight * 0.06,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                    ),
                    child: const Text(
                      "領   収   証",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "品名",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(width: size.deviceHeight * 0.10),
                      const Text(
                        "カロリー",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //_listタイル形式
                      children: [
                        //一連の流れ これを関数化させる
                        Expanded(
                          child: SizedBox(
                            child: Container(
                                child: SlidarCard(
                              list: _list,
                              eatfood: eatfood,
                              totalcal: totalcal,
                              stateFunction: deleteFuntion,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: const Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "合計",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      textcal(total: totalcal)
                    ],
                  ),
                ],
              ),
            ),
            ManualInputRegistButton(totalcal: totalcal, eatfood: eatfood),
            const ManualInputBarcodeButton(),
            Padding(padding: EdgeInsets.all(size.deviceHeight * 0.02)),
          ],
        ),
      ),
    );
  }
}

class textcal extends StatelessWidget {
  late double total;
  textcal({Key? key, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${total}kcal",
      style: const TextStyle(
        fontSize: 24,
      ),
    );
  }
}
