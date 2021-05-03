import 'package:flutter/material.dart';

class Helper {
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}