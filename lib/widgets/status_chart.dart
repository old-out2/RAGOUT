// import 'package:fl_chart/fl_chart.dart';
import 'package:app/models/return.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:app/importer.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    var date = DateFormat('yyyy/MM/dd').format(DateTime.now());
    Future getvalue() async {
      List AmountList = await Calorie().requiredAmount(date);

      List<double> maps = [];

      for (var element in AmountList) {
        maps.add(element);
      }

      return maps;
    }

    Future getchara() async {
      var status = await Status.getStatus();
      List<double> list = [];

      list.addAll([
        status.power, //力
        status.physical, //体力
        status.speed, //賢さ
        status.wisdom, //素早さ
        status.luck //運
      ]);

      return list;
    }

    final pages = <Widget>[
      FiveMajorNutrientsChart(
        stateFunction: getvalue(),
      ),
      FiveStatusChart(stateFunction: getchara()),
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

//今日の食べた栄養素グラフ
class FiveMajorNutrientsChart extends StatelessWidget {
  final Future stateFunction;
  const FiveMajorNutrientsChart({Key? key, required this.stateFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> data = [0.0, 0.0, 0.0, 0.0, 0.0];
    stateFunction.then((news) {
      if (news.isNotEmpty) {
        data.clear();
        data.addAll(news);
      }
      print(data);
    });

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
          //ここの値を変更する
          values: data,
          labels: ["", "", "", "", ""],
          maxValue: 100,
          fillColor: Colors.blue,
          chartRadiusFactor: 0.7,
        ),
      ],
    );
  }
}

//現在のキャラステータス
class FiveStatusChart extends StatelessWidget {
  final Future stateFunction;
  const FiveStatusChart({Key? key, required this.stateFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> data = [0.0, 0.0, 0.0, 0.0, 0.0];
    stateFunction.then((status) {
      data.clear();
      data.addAll(status);
      print(data);
    });

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/power.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 33, bottom: 70),
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/physical.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 70, bottom: 40),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/wisdom.png",
              height: size.deviceHeight * 0.036,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 70, bottom: 40),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              "assets/speed.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30, bottom: 70),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              "assets/luck.png",
              height: size.deviceHeight * 0.04,
            ),
          ),
        ),
        RadarChart(
          //ここの値を変更する
          values: data,
          labels: ["", "", "", "", ""],
          maxValue: 100,
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
