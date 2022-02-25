import 'package:app/importer.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class TrophyScreen extends StatefulWidget {
  TrophyScreen({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  void Function(String nowTitle) onSave;

  @override
  _TrophyScreenState createState() => _TrophyScreenState();
}

class _TrophyScreenState extends State<TrophyScreen> {
  var nowTitle = "新人戦士";

  @override
  Widget build(BuildContext context) {
    // DBから取ってくる

    // List<String> titles = [];
    init() async {
      var titles = await trophy.getTrophy();
      return titles;
    }

    @override
    void initState() {
      init();
    }

    return Center(
      child: Container(
        height: size.deviceHeight * 0.9,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/titlelist_menu.png'),
            // fit: BoxFit.cover,
          ),
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.deviceHeight * 0.03),
              SizedBox(
                width: size.deviceWidth * 0.9,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset("assets/titlelist_frame.png"),
                    Text(
                      nowTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.deviceHeight * 0.01),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 74, 42, 3),
                      width: 10,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 124, 84, 36),
                  ),
                  width: size.deviceWidth * 0.8,
                  height: size.deviceHeight * 0.45,
                  child: FutureBuilder(
                      future: init(),
                      builder: (context, AsyncSnapshot<List<String>> snapshot) {
                        List<String>? titles = snapshot.data ?? [];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var title in titles)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      nowTitle = title;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        bottom: 0,
                                        right: 20),
                                    width: size.deviceWidth * 0.7,
                                    height: size.deviceHeight * 0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 5,
                                        color:
                                            Color.fromARGB(255, 214, 189, 44),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromARGB(255, 255, 251, 234),
                                    ),
                                    child: Center(
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      })),
              SizedBox(
                height: size.deviceHeight * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: size.deviceWidth * 0.35,
                      child: Image.asset("assets/titlelist_back.png"),
                    ),
                  ),
                  SizedBox(
                    width: size.deviceWidth * 0.01,
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onSave(nowTitle);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: size.deviceWidth * 0.35,
                      child: Image.asset("assets/titlelist_submit.png"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
