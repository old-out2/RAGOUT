import 'package:app/importer.dart';
// import 'package:app/screens/barcode_screen.dart';

class BarcodeButton extends StatelessWidget {
  const BarcodeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GrowthScreen()),
          );
        },
        child: Image.asset(
          'assets/barcode.png',
        ),
      ),
    );
  }
}
