import 'package:app/importer.dart';

class GrowthButton extends StatelessWidget {
  const GrowthButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GrowthScreen()),
          );
        },
        child: Image.asset(
          'assets/growth.png',
        ),
      ),
    );
  }
}
