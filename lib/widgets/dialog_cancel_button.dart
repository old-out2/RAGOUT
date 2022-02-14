import 'package:app/importer.dart';

class DialogCancelButton extends StatelessWidget {
  const DialogCancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = SizeConfig();
    size.init(context);

    /*
    * 非表示
    */
    void hideCustomDialog() {
      Navigator.of(context).pop();
    }

    return SizedBox(
        width: size.deviceWidth * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              hideCustomDialog();
            },
            child: Image.asset('assets/dialog_cancel.png'),
          ),
        ));
  }
}
