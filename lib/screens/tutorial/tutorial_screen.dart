import 'package:app/importer.dart';
import 'package:app/screens/tutorial/sliding_tutorial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../main.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<TutorialScreen> {
  String dropdownSexValue = "男性";
  var size = SizeConfig();
  final ValueNotifier<double> notifier = ValueNotifier(0);
  List<String> sexList = ['男性', '女性', 'その他'];
  DateTime targetday = DateTime.now();
  String dropdownzExerciseValue = "運動しない";
  List<String> exerciseList = ['運動しない', '少し運動する', '良く運動する'];

  @override
  void initState() {
    gendar();
    Food.insertFood();
    Food.insert();
    super.initState();
  }

  void gendar() async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt('gender', sexList.lastIndexOf(dropdownSexValue));
    pref.setInt(
        'ActiveLevel', exerciseList.lastIndexOf(dropdownzExerciseValue));
  }

  @override
  Widget build(BuildContext context) {
    size.init(context);
    DateTime nowDate = DateTime.now();
    String date = DateFormat('yyyy年MM月dd日').format(nowDate);

    //チュートリアルを行った判定を保存
    void _doneTutorial(BuildContext context) async {
      print("run doneTutorial");
      final pref = await SharedPreferences.getInstance();
      pref.setBool('isFirstLaunch', true);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.deviceHeight,
          color: Colors.white,
          // margin: EdgeInsets.only(top: 60, bottom: 60),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 40,
                child: Image.asset("assets/icon.png"),
              ),
              const Text(
                "入会申込書",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "この度は健康管理アプリ「RAGOUT(ラグー)」をインストールしていただき、誠にありがとうございます。当アプリをご利用していただくにあたってお客様の身体情報が必要になります。お手数ですが、以下の入力欄からご記入のほどよろしくお願いいたします。",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Text("入会日"),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(date),
                  ),
                  const SizedBox(width: 1.5),
                ],
              ),
              const SizedBox(height: 5),
              Form(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputItem(size, "ニックネーム"),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: size.deviceWidth * 0.62,
                          height: size.deviceHeight * 0.05,
                          child: TextField(
                            onChanged: (value) async {
                              final pref =
                                  await SharedPreferences.getInstance();
                              pref.setString('name', value);
                            },
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputItem(size, "身長"),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              width: size.deviceWidth * 0.62,
                              height: size.deviceHeight * 0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      onChanged: (value) async {
                                        final pref = await SharedPreferences
                                            .getInstance();
                                        pref.setString('height', value);
                                      },
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      // style: TextStyle(fontSize: 20),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3)
                                      ],
                                    ),
                                  ),
                                  const Text("cm")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputItem(size, "体重"),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: size.deviceWidth * 0.62,
                          height: size.deviceHeight * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  onChanged: (value) async {
                                    final pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString('weight', value);
                                  },
                                  // style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                ),
                              ),
                              const Text("kg"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputItem(size, "身体的性別"),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: size.deviceWidth * 0.62,
                          height: size.deviceHeight * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              sexTooltip(),
                              DropdownButton<String>(
                                value: dropdownSexValue,
                                icon: const Icon(Icons.arrow_downward),
                                underline: const SizedBox(height: 0),
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    dropdownSexValue = newValue!;
                                  });
                                  final pref =
                                      await SharedPreferences.getInstance();
                                  pref.setInt('gender',
                                      sexList.lastIndexOf(dropdownSexValue));
                                },
                                items: sexList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputItem(size, "生年月日"),
                        Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            width: size.deviceWidth * 0.62,
                            height: size.deviceHeight * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat('yyyy年MM月dd日')
                                    .format(targetday)),
                                IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(1900, 1, 1),
                                      maxTime:
                                          DateTime(DateTime.now().year, 12, 31),
                                      onConfirm: (date) async {
                                        setState(() {
                                          targetday = date;
                                        });
                                        final pref = await SharedPreferences
                                            .getInstance();
                                        pref.setString(
                                            'birthday',
                                            DateFormat('yyyy/MM/dd')
                                                .format(date));
                                      },
                                      currentTime: targetday,
                                      locale: LocaleType.jp,
                                    );
                                  },
                                ),
                              ],
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputItem(size, "目標体重"),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: size.deviceWidth * 0.62,
                          height: size.deviceHeight * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  onChanged: (value) async {
                                    final pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString('Target_Weight', value);
                                  },
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                ),
                              ),
                              const Text("kg"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputItem(size, "身体活動レベル"),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: size.deviceWidth * 0.62,
                          height: size.deviceHeight * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              exerciseTooltip(),
                              DropdownButton<String>(
                                value: dropdownzExerciseValue,
                                icon: const Icon(Icons.arrow_downward),
                                underline: const SizedBox(height: 0),
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    dropdownzExerciseValue = newValue!;
                                  });
                                  final pref =
                                      await SharedPreferences.getInstance();
                                  pref.setInt(
                                      'ActiveLevel',
                                      exerciseList
                                          .lastIndexOf(dropdownzExerciseValue));
                                },
                                items: exerciseList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 10),
                    Text(
                      "以下の内容について、同意をお願いします。",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      "☑ このアプリは完全無料です。金銭を請求することは一切ありません。",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "☑ 過度な運動、危険な行為はご遠慮下さい。",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      "☑ このアプリを使って健康になってください。お願いします。",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // ホームに移動する為のボタン
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    child: const Text('提出'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      _doneTutorial(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HomeScreen(title: "RAGOUT")),
                          (_) => false);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Tooltip exerciseTooltip() {
    return Tooltip(
      message:
          '運動しない:普段から座っていることが多い\n少し運動する:通勤や買い物・家事、軽いスポーツ等のいずれかを含む\n良く運動する:移動が多い、スポーツや運動習慣を良く行っている場合', //表示するメッセージ
      height: 150, //吹き出しの高さ
      preferBelow: false, //メッセージを子widgetの上に出すか下に出すか
      textStyle: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold), //メッセージの文字スタイル
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(100))), //吹き出しの形や色の調整
      waitDuration: const Duration(
          seconds: 3), //ホバーしてからどれくらいでtoolTipが見えるか(スマホでは使用することはない)
      showDuration:
          const Duration(milliseconds: 1500), //何秒間メッセージを見せるか(タップを終えた後から)
      triggerMode:
          TooltipTriggerMode.tap, //どのような条件でメッセージを表示するか(ここではタップした際にしている)
      child: const Icon(
        CupertinoIcons.question_circle,
        color: Colors.blue,
        size: 20,
      ),
    );
  }

  Container inputItem(SizeConfig size, String inputItemName) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(color: Colors.black),
      ),
      height: size.deviceHeight * 0.05,
      width: size.deviceWidth * 0.32,
      child: Align(child: Text(inputItemName)),
    );
  }

  Tooltip sexTooltip() {
    return Tooltip(
      message: 'その他にすると正しい計算が出来ません', //表示するメッセージ
      height: 100, //吹き出しの高さ
      preferBelow: false, //メッセージを子widgetの上に出すか下に出すか
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold), //メッセージの文字スタイル
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ), //吹き出しの形や色の調整
      waitDuration: const Duration(
          seconds: 3), //ホバーしてからどれくらいでtoolTipが見えるか(スマホでは使用することはない)
      showDuration:
          const Duration(milliseconds: 1500), //何秒間メッセージを見せるか(タップを終えた後から)
      triggerMode:
          TooltipTriggerMode.tap, //どのような条件でメッセージを表示するか(ここではタップした際にしている)
      child: const Icon(
        CupertinoIcons.question_circle,
        color: Colors.blue,
        size: 20,
      ),
    );
  }
}
