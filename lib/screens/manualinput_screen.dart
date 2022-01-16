import 'package:app/importer.dart';
import 'package:app/models/manualinput_search_model.dart';
import 'package:app/widgets/manualinput_barcode_button.dart';
import 'package:app/widgets/manualinput_regist_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ManualInputScreen extends StatelessWidget {
  const ManualInputScreen({
    Key? key,
  }) : super(key: key);

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

    return Scaffold(
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
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset('assets/manualinput_title.png'),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ManualInputSearch(),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "ハンバーグ",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            const Text(
                              "548kal",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: const Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "合計",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "548kal",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const ManualInputRegistButton(),
            const ManualInputBarcodeButton(),
            Padding(padding: EdgeInsets.all(size.deviceHeight * 0.02)),
          ],
        ),
      ),
    );
  }
}

class ManualInputSearch extends StatelessWidget {
  const ManualInputSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManualInputSearchModel>(
      create: (_) => ManualInputSearchModel(),
      child: Consumer<ManualInputSearchModel>(builder: (context, model, child) {
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(),
                // labelText: '',
                hintText: "食べたものを検索",
              ),
              onChanged: (text) {
                model.text = text; // <= modelのtext変数に値を渡す
                model.search();
              },
            ),
          ],
        );
      }),
    );
  }
}
