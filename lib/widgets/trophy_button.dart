import 'package:app/importer.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

var size = SizeConfig();

class TrophyButton extends StatelessWidget {
  const TrophyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size.init(context);
    return SizedBox(
      width: size.deviceWidth * 0.33,
      child: TextButton(
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       content: SizedBox(
          //         width: size.deviceWidth * 1,
          //         height: size.deviceHeight * 0.7,
          //         child: TrophyScreen(),
          //       ),
          //     );
          //   },
          // );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrophyScreen()),
          );
          // showModalBottomSheet(
          //     backgroundColor: Colors.transparent,
          //     isScrollControlled: true,
          //     context: context,
          //     builder: (BuildContext context) {
          //       return TrophyScreen();
          //     });
        },
        child: Image.asset(
          'assets/trophy.png',
        ),
      ),
    );
  }
}
