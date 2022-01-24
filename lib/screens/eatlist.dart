import 'package:app/importer.dart';

class EatList extends StatefulWidget {
  @override
  _EatListState createState() => _EatListState();
}

class _EatListState extends State<EatList> {
  List<Map<String, dynamic>> list = [];
  @override
  void initState() {
    Future(() async {
      list = await Eat.getEat();
    });
    super.initState();
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
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: ListTile(title: Text(list[index].toString())),
              );
            }));
  }
}
