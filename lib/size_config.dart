import 'package:app/importer.dart';

class SizeConfig {
  late MediaQueryData? _mediaQueryData;
  late double deviceHeight;
  late double deviceWidth;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    deviceHeight = _mediaQueryData!.size.height;
    deviceWidth = _mediaQueryData!.size.width;
  }
}
