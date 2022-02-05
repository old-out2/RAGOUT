import 'dart:developer';

import 'package:app/importer.dart';
import 'package:app/models/manualinput_search_model.dart';
import 'package:app/widgets/manualinput_barcode_button.dart';
import 'package:app/widgets/manualinput_regist_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

List<Slidable> _list = [];
List<Map<String, String>> eatfood = [];
double totalcal = 0;

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

    final InputKey = GlobalObjectKey<_ManualInputSearchState>(context);

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
                        nowDate: DateFormat('yyyy/MM//dd').format(nowDate)),
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
                  // SizedBox(
                  //   height: size.deviceHeight * 0.18,
                  //   child: ListView.builder(
                  //     // shrinkWrap: true,
                  //     itemCount: _list.length,
                  //     itemBuilder: (BuildContext context, index) {
                  //       print(_list.length);
                  //       return _list[index];
                  //     },
                  //   ),
                  // ),
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
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                // shrinkWrap: true,
                                itemCount: _list.length,
                                itemBuilder: (BuildContext context, index) {
                                  return _list[index];
                                },
                              ),
                            ),
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
                          "${totalcal}kcal",
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

class ManualInputSearch extends StatefulWidget {
  final String nowDate;
  const ManualInputSearch({Key? key, required this.nowDate}) : super(key: key);

  @override
  State<ManualInputSearch> createState() => _ManualInputSearchState();
}

class _ManualInputSearchState extends State<ManualInputSearch> {
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManualInputSearchModel>(
      create: (_) => ManualInputSearchModel(),
      child: Consumer<ManualInputSearchModel>(builder: (context, model, child) {
        return Column(
          children: [
            TypeAheadField(
              // getImmediateSuggestions: true,
              textFieldConfiguration: TextFieldConfiguration(
                controller: this._typeAheadController,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    border: UnderlineInputBorder(),
                    labelText: '食べたものを検索'),
                onChanged: (text) {
                  model.text = text; // <= modelのtext変数に値を渡す
                  model.search();
                  // debugPrint(model.searchResultList.toString());
                },
              ),
              suggestionsCallback: (pattern) {
                // model.text = pattern;
                // model.search();
                return model.searchResultList;
              },
              itemBuilder: (context, Map<String, String> suggestion) {
                // debugPrint(model.searchResultList.toString());
                return Card(
                    child: ListTile(
                  title: Text(suggestion['name'].toString()),
                ));
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (Map<String, String> suggestion) {
                this._typeAheadController.text = suggestion['name'].toString();
                totalcal += double.parse(suggestion['cal'].toString());
                eatfood.add({
                  "date": widget.nowDate,
                  "foodid": suggestion["id"].toString(),
                  "eiyo": "",
                });
                debugPrint(eatfood.toString());
                // debugPrint(suggestion.toString());
                _list.add(
                  Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _list.remove(suggestion);
                            eatfood.remove(suggestion);
                            // _list.remove(value)
                            // suggestion.clear();
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.deviceWidth * 0.55,
                          child: Text(
                            suggestion['name'].toString(),
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          suggestion['cal'].toString(),
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return 'Please select a city';
              //   }
              // },
            ),
          ],
        );
      }),
    );
  }
}
