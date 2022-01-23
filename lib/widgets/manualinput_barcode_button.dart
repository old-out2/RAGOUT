import 'package:app/importer.dart';

class ManualInputBarcodeButton extends StatelessWidget {
  const ManualInputBarcodeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GrowthScreen()),
          );
        },
        child: Image.asset(
          'assets/manualinput_barcode.png',
        ),
      ),
    );
  }
}
