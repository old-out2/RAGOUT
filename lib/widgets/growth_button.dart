import 'package:app/importer.dart';
import 'package:app/screens/manualinput_screen.dart';

// var size = SizeConfig();

class GrowthButton extends StatelessWidget {
  const GrowthButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // size.init(context);
    return SizedBox(
      width: size.deviceWidth * 0.33,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ManualInputScreen()),
            );
          },
          child: Image.asset(
            'assets/growth.png',
          ),
        ),
      ),
    );
  }
}
