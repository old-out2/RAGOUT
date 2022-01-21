// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:app/importer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  final controller = PageController(viewportFraction: 1.0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      FiveMajorNutrientsChart(),
      FiveMajorNutrientsChart(),
    ];

    size.init(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: SizedBox(
              height: size.deviceHeight * 0.4,
              child: Container(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
            ),
          ),
          Container(
            child: SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: const JumpingDotEffect(
                  dotHeight: 16,
                  dotWidth: 16,
                  jumpScale: .7,
                  verticalOffset: 15,
                  activeDotColor: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

class FiveMajorNutrientsChart extends StatelessWidget {
  const FiveMajorNutrientsChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/protein.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 33, bottom: 70),
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/lipids.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 70, bottom: 40),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/mineral.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 70, bottom: 40),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              "assets/vitamin.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30, bottom: 70),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              "assets/sugar.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        RadarChart(
          values: [1, 2, 4, 7, 9],
          labels: ["", "", "", "", ""],
          maxValue: 50,
          fillColor: Colors.blue,
          chartRadiusFactor: 0.7,
        ),
      ],
    );
  }
}

class FiveStatusChart extends StatelessWidget {
  const FiveStatusChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/protein.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 33, bottom: 70),
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/lipids.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 70, bottom: 40),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/mineral.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 70, bottom: 40),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              "assets/vitamin.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30, bottom: 70),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              "assets/sugar.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        RadarChart(
          values: [1, 2, 4, 7, 9],
          labels: ["", "", "", "", ""],
          maxValue: 50,
          fillColor: Colors.blue,
          chartRadiusFactor: 0.7,
        ),
      ],
    );
  }
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
