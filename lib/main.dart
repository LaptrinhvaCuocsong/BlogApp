import 'package:blog_app/blog_app.dart';
import 'package:blog_app/state/AuthStateContainer.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    ThemeData theme = ThemeData(
      primarySwatch: Colors.deepPurple,
    );


    return MaterialApp(
      title: Strings.appTitle,
      theme: theme,
      darkTheme: theme,
      home: AuthStateContainer(
        child: BlogApp(),
      ),
    );
  }
}