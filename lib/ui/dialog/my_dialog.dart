import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog {
  static void show(BuildContext context, String msg, List<String> btnTitles, List<Function> btnOnTaps) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          content: Text(msg, style: TextStyle(fontWeight: FontWeight.w400)),
          actions: _buildListAction(context, btnTitles, btnOnTaps),
        ));
  }

  static List<Widget> _buildListAction(BuildContext context, List<String> btnTitles, List<Function> btnOnTaps) {
    List<Widget> btns = [];
    for (int i=0; i<btnTitles.length; i++) {
      btns.add(CupertinoButton(
        onPressed: () {
          dismiss(context);
          if (i < btnOnTaps.length) {
            btnOnTaps[i]();
          }
        },
        child: Text(btnTitles[i], style: TextStyle(fontWeight: FontWeight.bold)),
      ));
    }
    return btns;
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop(MyDialog);
  }
}