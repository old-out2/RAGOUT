import 'package:app/importer.dart';
import 'package:app/widgets/dialog_cancel_button.dart';
import 'package:app/widgets/dialog_regist_button.dart';
import '../ModelOverlay.dart';

class CustomDialog {
  BuildContext context;
  CustomDialog(this.context) : super();
  var size = SizeConfig();

  void showCustomDialog(double totalcal) {
    size.init(context);
    Navigator.push(
      context,
      ModalOverlay(
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  "assets/dialog.png",
                  fit: BoxFit.fitWidth,
                ),
                Container(
                    height: 200.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          /*
                             * タイトル
                             */
                          Text(
                            totalcal.toString() + "Kcal",
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              locale: Locale("ja", "JP"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          /*
                             * メッセージ
                             */
                          const Text(
                            "登録しますか？",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              locale: Locale("ja", "JP"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          /*
                           * OKボタン
                           */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              DialogCancelButton(),
                              SizedBox(width: 45),
                              DialogRegistButton()
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ],
        )),
        isAndroidBackEnable: false,
      ),
    );
  }
}
