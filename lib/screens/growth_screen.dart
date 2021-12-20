import 'package:app/importer.dart';
import "dart:developer";

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({Key? key}) : super(key: key);

  @override
  _GrowthScreenState createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // ホットリロードを機能させるには、プラットフォームがAndroidの場合はカメラを一時停止するか、
  // プラットフォームがiOSの場合はカメラを再開する必要がある

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  var size = SizeConfig();
  @override
  Widget build(BuildContext context) {
    size.init(context);

    return Scaffold(
        appBar: AppBar(
          // AppBarを隠す
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        extendBodyBehindAppBar: true,
        body: SizedBox.expand(
            child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/qr_back.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(top: size.deviceHeight * 0.15),
          child: Column(
            children: <Widget>[
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: size.deviceWidth * 0.7,
                      maxHeight: (size.deviceHeight) * 0.6),
                  child: _buildQrView(context)),
              const ManualInputButton()
            ],
          ),
        )));
  }

  Widget _buildQrView(BuildContext context) {
    size.init(context);
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = 200.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          // borderRadius: 30,
          borderLength: size.deviceHeight * 0.02,
          // cutOutBottomOffset: 10,
          borderWidth: size.deviceWidth * 0.02,
          cutOutHeight: size.deviceHeight * 0.15,
          cutOutWidth: size.deviceWidth * 0.55),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
