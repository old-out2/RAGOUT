import 'package:app/importer.dart';

import '../ModelOverlay.dart';
import '../widgets/barcode_regist_button.dart';
import '../widgets/dialog_cancel_button.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({Key? key}) : super(key: key);

  @override
  _GrowthScreenState createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  Barcode? result; //バーコードの取得
  bool _isQRscanned = false;
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
    //barcodeを読みこんだ場合のコールバック処理
    controller.scannedDataStream.listen((scanData) {
      String test = "1203842309";
      Map<String, dynamic> map;
      Future((() async {
        map = await Eat.getbarcode(test);
        print(map);
        // setState(() {
        //   result = scanData;
        // });
        barcodeDialog(map);
      }));
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  barcodeDialog(Map<String, dynamic> result) {
    if (!_isQRscanned) {
      controller?.pauseCamera();
      _isQRscanned = true;
      Navigator.push(
          context,
          ModalOverlay(Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/check_cal_dialog.png",
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                      height: size.deviceHeight * 0.35,
                      child: Center(
                          child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(height: (size.deviceHeight * 0.01)),
                            /*
                             * タイトル
                             */
                            Text(
                              result["name"].toString(),
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                locale: Locale("ja", "JP"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${result["cal"].toString()}Kcal",
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                locale: Locale("ja", "JP"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            /*
                             * メッセージ
                             */
                            const Text(
                              "登録しますか？",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                locale: Locale("ja", "JP"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            /*
                           * OKボタン
                           */
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DialogCancelButton(),
                                SizedBox(width: 45),
                                BarcodeRegistButton(
                                    code: result["barcode"].toString())
                              ],
                            )
                          ],
                        ),
                      )))
                ],
              ),
            ],
          )))).then((value) {
        controller?.resumeCamera();
        _isQRscanned = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
