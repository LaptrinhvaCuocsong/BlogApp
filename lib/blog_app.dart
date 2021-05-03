import 'package:blog_app/firebase/my_firebase.dart';
import 'package:blog_app/state/AuthStateContainer.dart';
import 'package:blog_app/ui/auth/login_page.dart';
import 'package:blog_app/ui/error/error_page.dart';
import 'package:blog_app/ui/home/home_page.dart';
import 'package:blog_app/ui/splash/splash_page.dart';
import 'package:blog_app/utils/enums.dart';
import 'package:flutter/material.dart';

class BlogApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlogAppState();
}

class _BlogAppState extends State<BlogApp> {
  AuthState _authState;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _authState = AuthStateContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder(
      future: MyFirebase.instance.firebaseApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return _authState.authStatus == AuthStatus.notLogin
              ? LoginPage()
              : HomePage();
        }
        return SplashPage();
      },
    );
  }
}
