// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:app/importer.dart';

// const gridColor = Color(0xff68739f);
// const titleColor = Color(0xff8c95db);
// const fashionColor = Color(0xffe15665);
// const artColor = Color(0xff63e7e5);
// const boxingColor = Color(0xff83dea7);
// const entertainmentColor = Colors.white70;
// const offRoadColor = Color(0xFFFFF59D);

class StatusRadarChart extends StatefulWidget {
  const StatusRadarChart({Key? key}) : super(key: key);

  @override
  _StatusRadarChartState createState() => _StatusRadarChartState();
}

var size = SizeConfig();

class _StatusRadarChartState extends State<StatusRadarChart> {
  int selectedDataSetIndex = -1;

  @override
  Widget build(BuildContext context) {
    size.init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.deviceHeight * 0.4,
          //Radar Chart
          child: RadarChart(
            values: [1, 2, 4, 7, 9],
            labels: ["", "", "", "", ""],
            maxValue: 50,
            fillColor: Colors.blue,
            chartRadiusFactor: 0.7,
          ),
        ),
      ],
    );
  }

  // List<RadarDataSet> showingDataSets() {
  //   return rawDataSets().asMap().entries.map((entry) {
  //     var index = entry.key;
  //     var rawDataSet = entry.value;

  //     final isSelected = index == selectedDataSetIndex
  //         ? true
  //         : selectedDataSetIndex == -1
  //             ? true
  //             : false;

  //     return RadarDataSet(
  //       fillColor: isSelected
  //           ? rawDataSet.color.withOpacity(0.2)
  //           : rawDataSet.color.withOpacity(0.05),
  //       borderColor:
  //           isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
  //       entryRadius: isSelected ? 3 : 2,
  //       dataEntries:
  //           rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
  //       borderWidth: isSelected ? 2.3 : 2,
  //     );
  //   }).toList();
  // }

  // List<RawDataSet> rawDataSets() {
  //   return [
  //     RawDataSet(
  //       title: 'nutrients',
  //       color: fashionColor,
  //       values: [
  //         300,
  //         230,
  //         250,
  //         180,
  //         210,
  //       ],
  //     ),
  //   ];
  // }
}

class RawDataSet {
  final String title;
  final Color color;
  final List<double> values;

  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });
}
