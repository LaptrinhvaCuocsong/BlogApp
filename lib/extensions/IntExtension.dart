import 'package:blog_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';

extension IntExtension on int {
  double scaleW(BuildContext context) {
    return (this / Constants.standardSize.width) * MediaQuery.of(context).size.width;
  }

  double scaleH(BuildContext context) {
    return (this / Constants.standardSize.height) * MediaQuery.of(context).size.height;
  }
}