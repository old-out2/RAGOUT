import 'package:app/importer.dart';
import 'package:flutter/material.dart';

class TrophyButton extends StatelessWidget {
  const TrophyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrophyScreen()),
          );
        },
        child: Image.asset(
          'assets/trophy.png',
        ),
      ),
    );
  }
}
