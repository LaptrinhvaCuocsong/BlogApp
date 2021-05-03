import 'package:blog_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(Constants.appIcon),
        ),
      ),
    );
  }
}
