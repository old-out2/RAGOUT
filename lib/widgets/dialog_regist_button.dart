import 'package:app/importer.dart';
import 'package:app/main.dart';
import 'package:app/models/return.dart';
import 'package:app/screens/manualinput_screen.dart';

class DialogRegistButton extends StatelessWidget {
  const DialogRegistButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = SizeConfig();
    size.init(context);
    return SizedBox(
        width: size.deviceWidth * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              await Eat.insertEat(eatfood);
              Calorie().totalcal();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(title: 'RAGOUT')),
              );
            },
            child: Image.asset('assets/dialog_regist.png'),
          ),
        ));
  }
}