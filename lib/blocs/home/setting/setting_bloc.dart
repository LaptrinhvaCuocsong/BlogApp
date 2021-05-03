import 'dart:async';

import 'package:blog_app/firebase/my_firebase_auth.dart';
import 'package:blog_app/firebase/my_firebase_firestore.dart';
import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/utils/constants.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc {
  StreamController _settingController = StreamController();
  MyUser _user;

  Stream get settingStream => _settingController.stream;
  
  void dispose() {
    _settingController.close();
  }

  void fetchUser() {
    if (_user != null) {
      _settingController.add(_user);
      return;
    }

    SharedPreferences.getInstance().then((prefs) {
      String userId = prefs.getString(Constants.USER_ID_KEY);
      MyFirebaseFirestore.instance.getUser(userId, (user) {
        _user = user;
        _settingController.add(user);
      }, (msg) {
        print(msg);
        _settingController.addError(Strings.getUserIsFailed);
      });
    });
  }

  void logout(Function onSuccess, Function(String) onLogoutFailed) {
    MyFirebaseAuth.instance.logout(onSuccess, onLogoutFailed);
  }
}