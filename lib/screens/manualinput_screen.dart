import 'package:app/importer.dart';

class ManualInputScreen extends StatelessWidget {
  const ManualInputScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // AppBarを隠す
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/receipt.png'),
              fit: BoxFit.cover,
            ),
          ),
          // child: Center(
          //   child: Column(
          //     children: const <Widget>[
          //       BarcodeButton()
          //       ],
          //   ),
          // )
        ));
  }
}
