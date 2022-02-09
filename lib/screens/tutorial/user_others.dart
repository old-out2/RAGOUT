import 'package:app/importer.dart';
import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserothersPage extends StatefulWidget {
  final int page;
  final ValueNotifier<double> notifier;

  const UserothersPage(this.page, this.notifier, {Key? key}) : super(key: key);

  @override
  State<UserothersPage> createState() => _UserothersPageState();
}

class _UserothersPageState extends State<UserothersPage> {
  var size = SizeConfig();
  String dropdownValue = "運動しない";
  List<String> list = ['運動しない', '少し運動する', '良く運動する'];
  late DateTime _date = new DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    super.initState();
    activeLevel();
  }

  void activeLevel() async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt('ActiveLevel', list.lastIndexOf(dropdownValue));
  }

  //チュートリアルを行った判定を保存
  void _showTutorial(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isFirstLaunch', true);
  }

  @override
  Widget build(BuildContext context) {
    size.init(context);

    // ボタンを押したらDatePcikerを起動して値を保存する
    void onPressedRaisedButton() async {
      final DateTime? picked = await showDatePicker(
          locale: const Locale("ja"),
          context: context,
          initialDate: _date,
          firstDate: new DateTime(1960),
          lastDate: new DateTime.now().add(new Duration(days: 360)));

      if (picked != null) {
        setState(() => _date = picked);
        final pref = await SharedPreferences.getInstance();
        pref.setString('birthday', outputFormat.format(picked));
      }
    }

    return SlidingPage(
      page: widget.page,
      notifier: widget.notifier,
      child: Column(
        children: <Widget>[
          // 生年月日
          const SizedBox(height: 100),
          Center(
              child: Column(children: [
            Text(
              '生年月日',
              style: TextStyle(fontSize: 20),
            ),
            ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: size.deviceWidth * 0.45,
                    maxHeight: (size.deviceHeight) * 0.06),
                child: ElevatedButton(
                  child: Text(
                    '日付選択',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    onPressedRaisedButton();
                  },
                )),
            Text(
              outputFormat.format(_date),
              style: TextStyle(fontSize: 20),
            ),
          ])),

          // 目標体重
          const SizedBox(height: 75),
          Center(
              child: Column(children: [
            const Text(
              "目標体重",
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
                      pref.setString('Target_Weight', value);
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
                  "Kg",
                  style: TextStyle(fontSize: 20),
                )
              ],
            )
          ])),

          // 身体活動レベル
          const SizedBox(height: 75),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Center(
                child: Text(
              "身体活動レベル",
              style: TextStyle(fontSize: 20),
            )),
            Tooltip(
                message:
                    '運動しない:普段から座っていることが多い\n少し運動する:通勤や買い物・家事、軽いスポーツ等のいずれかを含む\n良く運動する:移動が多い、スポーツや運動習慣を良く行っている場合', //表示するメッセージ
                height: 150, //吹き出しの高さ
                preferBelow: false, //メッセージを子widgetの上に出すか下に出すか
                textStyle: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold), //メッセージの文字スタイル
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
              pref.setInt('ActiveLevel', list.lastIndexOf(dropdownValue));
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // ホームに移動する為のボタン
          const SizedBox(height: 50),
          Center(
            child: ElevatedButton(
                child: const Text('決定'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  _showTutorial(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(title: 'RAGOUT')),
                  );
                }),
          )
        ],
      ),
    );
  }
}
