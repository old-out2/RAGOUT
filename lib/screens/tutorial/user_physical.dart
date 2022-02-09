import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:app/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserphysicalPage extends StatefulWidget {
  final int page;
  final ValueNotifier<double> notifier;

  const UserphysicalPage(this.page, this.notifier, {Key? key})
      : super(key: key);

  @override
  State<UserphysicalPage> createState() => _UserphysicalPageState();
}

class _UserphysicalPageState extends State<UserphysicalPage> {
  var size = SizeConfig();
  String dropdownValue = "男性";
  List<String> list = ['男性', '女性', 'その他'];

  @override
  void initState() {
    super.initState();
    gendar();
  }

  void gendar() async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt('gender', list.lastIndexOf(dropdownValue));
  }

  @override
  Widget build(BuildContext context) {
    size.init(context);

    return SlidingPage(
      page: widget.page,
      notifier: widget.notifier,
      child: Column(
        children: <Widget>[
          //名前
          const SizedBox(height: 75),
          Center(
              child: Column(children: [
            const Text(
              "ニックネーム",
              style: TextStyle(fontSize: 20),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: size.deviceWidth * 0.45,
                  maxHeight: (size.deviceHeight) * 0.06),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  final pref = await SharedPreferences.getInstance();
                  pref.setString('name', value);
                },
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ])),

          //身長
          const SizedBox(height: 50),
          Center(
              child: Column(children: [
            const Text(
              "身長",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: size.deviceWidth * 0.2,
                      maxHeight: (size.deviceHeight) * 0.06),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) async {
                      final pref = await SharedPreferences.getInstance();
                      pref.setString('height', value);
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                  ),
                ),
                const Text(
                  "cm",
                  style: TextStyle(fontSize: 20),
                )
              ],
            )
          ])),

          //体重
          const SizedBox(height: 50),
          Center(
              child: Column(children: [
            const Text(
              "体重",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: size.deviceWidth * 0.2,
                      maxHeight: (size.deviceHeight) * 0.06),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) async {
                      final pref = await SharedPreferences.getInstance();
                      pref.setString('weight', value);
                    },
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                  ),
                ),
                const Text(
                  "Kg",
                  style: TextStyle(fontSize: 20),
                )
              ],
            )
          ])),

          //身体的性別
          const SizedBox(height: 65),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Center(
                child: Text(
              "身体的性別",
              style: TextStyle(fontSize: 20),
            )),
            Tooltip(
                message: 'その他にすると正しい計算が出来ません', //表示するメッセージ
                height: 100, //吹き出しの高さ
                preferBelow: false, //メッセージを子widgetの上に出すか下に出すか
                textStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold), //メッセージの文字スタイル
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius:
                        BorderRadius.all(Radius.circular(100))), //吹き出しの形や色の調整
                waitDuration: const Duration(
                    seconds: 3), //ホバーしてからどれくらいでtoolTipが見えるか(スマホでは使用することはない)
                showDuration: const Duration(
                    milliseconds: 1500), //何秒間メッセージを見せるか(タップを終えた後から)
                triggerMode: TooltipTriggerMode
                    .tap, //どのような条件でメッセージを表示するか(ここではタップした際にしている)
                child: const Icon(
                  CupertinoIcons.question_circle,
                  color: Colors.blue,
                  size: 30,
                )),
          ]),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            dropdownColor: Color.fromRGBO(254, 241, 188, 1),
            onChanged: (String? newValue) async {
              setState(() {
                dropdownValue = newValue!;
              });
              final pref = await SharedPreferences.getInstance();
              pref.setInt('gender', list.lastIndexOf(dropdownValue));
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
