import 'package:app/importer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidarCard extends StatelessWidget {
  final List<dynamic> list;
  final List<Map<String, String>> eatfood;
  late double totalcal;
  late Function stateFunction;
  SlidarCard(
      {Key? key,
      required this.list,
      required this.eatfood,
      required this.totalcal,
      required this.stateFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        // shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, index) {
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    stateFunction(index);
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  // icon: Icons.delete,
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
                    list[index]['name'].toString(),
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  list[index]['cal'].toString(),
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
