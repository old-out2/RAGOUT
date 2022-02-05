import 'package:app/importer.dart';
import 'package:app/screens/manualinput_screen.dart';

class GrowthButton extends StatelessWidget {
  const GrowthButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = SizeConfig();
    size.init(context);
    return SizedBox(
      width: size.deviceWidth * 0.33,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManualInputScreen()),
          );
        },
        child: Image.asset(
          'assets/growth.png',
        ),
      ),
    );
  }
}
