import 'package:flutter/material.dart';
import 'package:firebaseApp/res/style.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final Function onClick;

  const ButtonWidget(
      {@required this.buttonText, @required this.onClick, Key key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45.0,
      child: FlatButton(
        onPressed: onClick,
        child: Text(
          buttonText,
          style: styleButtonText,
          textAlign: TextAlign.start,
        ),
        color: Theme.of(context).primaryColorDark,
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
