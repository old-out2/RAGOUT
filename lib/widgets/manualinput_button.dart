import 'package:app/importer.dart';
import 'package:app/screens/manualinput_screen.dart';

class ManualInputButton extends StatelessWidget {
  const ManualInputButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig();
    size.init(context);

    return Container(
        padding: EdgeInsets.only(top: size.deviceHeight * 0.09),
        child: SizedBox(
          height: size.deviceHeight * 0.1,
          width: size.deviceWidth * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const ManualInputScreen()),
                // );

                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/manualinput2.png',
              ),
            ),
          ),
        ));
  }
}
