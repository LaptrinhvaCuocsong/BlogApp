import 'package:blog_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MsgDialog {
  static void show(BuildContext context, String msg) {
    if (msg == null) {
      return;
    }
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              content: Text(msg, style: TextStyle(fontWeight: FontWeight.w400)),
              actions: <Widget>[
                CupertinoButton(
                  onPressed: () {
                    dismiss(context);
                  },
                  child: Text(Strings.okBtn, style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ));
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop(MsgDialog);
  }
}
