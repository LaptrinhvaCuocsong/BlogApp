import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context, String msg) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        msg != null
                            ? Column(children: <Widget>[
                                SizedBox(height: 16),
                                Text(msg,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400))
                              ])
                            : Container(width: 100)
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
