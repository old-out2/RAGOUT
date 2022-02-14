import 'package:app/importer.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

var size = SizeConfig();

class TrophyButton extends StatelessWidget {
  const TrophyButton({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  final void Function(String nowTitle) onSave;

  @override
  Widget build(BuildContext context) {
    size.init(context);
    return SizedBox(
      width: size.deviceWidth * 0.33,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  child: TrophyScreen(onSave: onSave),
                );
              },
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => TrophyScreen()),
            // );
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
      ),
    );
  }
}
