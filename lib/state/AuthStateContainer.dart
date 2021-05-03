import 'package:blog_app/utils/constants.dart';
import 'package:blog_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStateContainer extends StatefulWidget {
  final Widget child;

  AuthStateContainer({Key key, @required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AuthState();

  static AuthState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AuthInheritedWidget>()
        .state;
  }
}

class AuthState extends State<AuthStateContainer> {
  AuthStatus authStatus = AuthStatus.notLogin;
  SharedPreferences _prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadValue();
  }

  void _loadValue() async {
    _prefs = await SharedPreferences.getInstance();
    var value = _prefs.getInt(Constants.AUTH_KEY);
    if (value == null) {
      value = 0;
    }
    setState(() {
      authStatus = value == AuthStatus.notLogin.index
          ? AuthStatus.notLogin
          : AuthStatus.loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _AuthInheritedWidget(
      state: this,
      child: widget.child,
    );
  }

  void updateAuthStatus(AuthStatus status) async {
    await _prefs.setInt(Constants.AUTH_KEY, status.index);
    setState(() {
      authStatus = status;
    });
  }
}

class _AuthInheritedWidget extends InheritedWidget {
  final AuthState state;

  _AuthInheritedWidget({Key key, @required this.state, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
