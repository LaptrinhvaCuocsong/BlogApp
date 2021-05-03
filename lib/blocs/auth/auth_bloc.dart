import 'dart:async';

import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/utils/strings.dart';

class AuthBloc {
  StreamController _emailController = StreamController();
  StreamController _passwordController = StreamController();
  StreamController _phoneNumberController = StreamController();
  StreamController _genderController = StreamController();

  Stream get emailStream => _emailController.stream;
  Stream get passwordStream => _passwordController.stream;
  Stream get phoneNumberStream => _phoneNumberController.stream;
  Stream get genderStream => _genderController.stream;

  bool formLoginIsValid(String email, String password) {
    bool isValid = true;
    if (email == null || email.trim().isEmpty) {
      _emailController.sink.addError(Strings.emailIsRequired);
      isValid = false;
    } else {
      _emailController.sink.add('');
    }
    if (password == null || password.trim().isEmpty) {
      _passwordController.sink.addError(Strings.passwordIsRequired);
      isValid = false;
    } else {
      _passwordController.sink.add('');
    }
    return isValid;
  }

  bool formSignUpIsValid(MyUser user) {
    if (user == null) {
      return false;
    }
    bool isValid = true;
    if (user.email == null || user.email.trim().isEmpty) {
      _emailController.sink.addError(Strings.emailIsRequired);
      isValid = false;
    } else {
      _emailController.sink.add('');
    }
    if (user.password == null || user.password.trim().isEmpty) {
      _passwordController.sink.addError(Strings.passwordIsRequired);
      isValid = false;
    } else {
      _passwordController.sink.add('');
    }
    if (user.phoneNumber == null || user.phoneNumber.trim().isEmpty) {
      _phoneNumberController.sink.addError(Strings.phoneNumberIsRequired);
      isValid = false;
    } else {
      _phoneNumberController.sink.add('');
    }
    if (user.gender == null) {
      _genderController.sink.addError(Strings.genderIsRequired);
      isValid = false;
    } else {
      _genderController.sink.add('');
    }
    return isValid;
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _phoneNumberController.close();
    _genderController.close();
  }
}