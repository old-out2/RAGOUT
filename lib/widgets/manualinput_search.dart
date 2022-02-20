import 'package:app/importer.dart';
import 'package:app/models/manualinput_search_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class ManualInputSearch extends StatefulWidget {
  final String nowDate;
  final List<dynamic> list;
  final List<Map<String, String>> eatfood;
  late double totalcal;
  final Function stateFunction;
  ManualInputSearch(
      {Key? key,
      required this.nowDate,
      required this.list,
      required this.eatfood,
      required this.totalcal,
      required this.stateFunction})
      : super(key: key);

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
                controller: _typeAheadController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    border: UnderlineInputBorder(),
                    labelText: '食べたものを検索'),
                onChanged: (text) {
                  model.text = text; // <= modelのtext変数に値を渡す
                  model.search();
                },
              ),
              suggestionsCallback: (pattern) {
                return model.searchResultList;
              },
              itemBuilder: (context, Map<String, String> suggestion) {
                return Card(
                    child: ListTile(
                  title: Text(suggestion['name'].toString()),
                ));
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (Map<String, String> suggestion) {
                _typeAheadController.text = suggestion['name'].toString();
                widget.stateFunction(suggestion);
                // print(widget.totalcal);
              },
            ),
          ],
        );
      }),
    );
  }
}
