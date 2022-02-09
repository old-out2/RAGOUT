import 'package:app/importer.dart';
import 'package:intl/intl.dart';

class EatList extends StatefulWidget {
  @override
  _EatListState createState() => _EatListState();
}

class _EatListState extends State<EatList> {
  List<Map<String, dynamic>> list = [];
  @override
  // void initState() {
  //   Future(() async {
  //     list = await Eat.getEat(DateFormat('yyyy/MM/dd').format(DateTime.now()));
  //   });
  //   super.initState();
  // }

  Future _loadData() async {
    //Future.delay()を使用して擬似的に非同期処理を表現
    await Future.delayed(Duration(seconds: 2));
    list = await Eat.getEat(DateFormat('yyyy/MM/dd').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder(
            future: _loadData(),
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      child: ListTile(title: Text(list[index].toString())),
                    );
                  });
            }));
  }
}
