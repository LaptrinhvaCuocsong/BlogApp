import 'package:blog_app/firebase/my_firebase_firestore.dart';
import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorCode {
  // SignUp

  static const String weakPassword = 'weak-password';
  static const String emailAlready = 'email-already-in-use';
  static const String userIsNotFound = 'user-not-found';
  static const String passwordIsWrong = 'wrong-password';
}

class MyFirebaseAuth {
  static final instance = MyFirebaseAuth._();

  final _firebaseAuth = FirebaseAuth.instance;

  MyFirebaseAuth._();

  // SignUp

  void signUp(
      MyUser user, Function onSuccess, Function(String) onSignUpFailed) {
    if (user.email == null || user.password == null) {
      return;
    }
    _firebaseAuth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((_user) {
      user.id = _user.user.uid;
      _createUser(user, onSuccess, onSignUpFailed);
    }).catchError((Object e) {
      if (e is FirebaseAuthException) {
        _signUpError(e.code, onSignUpFailed);
      }
    });
  }

  void _createUser(
      MyUser user, Function onSuccess, Function(String) onCreateUserFailed) {
    MyFirebaseFirestore.instance
        .createUser(user, onSuccess, onCreateUserFailed);
  }

  void _signUpError(String signUpErrorCode, Function(String) onSignUpError) {
    if (signUpErrorCode == FirebaseAuthErrorCode.emailAlready) {
      onSignUpError(Strings.emailIsAlready);
    } else if (signUpErrorCode == FirebaseAuthErrorCode.weakPassword) {
      onSignUpError(Strings.passwordIsTooWeak);
    } else {
      onSignUpError(Strings.signUpIsFailed);
    }
  }

  // Login

  void login(String email, String password, Function(MyUser) onSuccess,
      Function(String) onLoginFailed) {
    if (email == null || password == null) {
      return;
    }
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((_user) {
      _getUser(_user.user.uid, onSuccess, onLoginFailed);
    }).catchError((Object e) {
      if (e is FirebaseAuthException) {
        _loginError(e.code, onLoginFailed);
      }
    });
  }

  void _getUser(
      String userId, Function(MyUser) onSuccess, Function onGetUserFailed) {
    MyFirebaseFirestore.instance.getUser(userId, onSuccess, onGetUserFailed);
  }

  void _loginError(String loginErrorCode, Function(String) onLoginFailed) {
    if (loginErrorCode == FirebaseAuthErrorCode.userIsNotFound) {
      onLoginFailed(Strings.userIsNotFound);
    } else if (loginErrorCode == FirebaseAuthErrorCode.passwordIsWrong) {
      onLoginFailed(Strings.passwordIsWrong);
    } else {
      onLoginFailed(Strings.loginIsFailed);
    }
  }

  // Logout

  void logout(Function onSuccess, Function(String) onLogoutFailed) {
    _firebaseAuth.signOut().then((value) {
      onSuccess();
    }).catchError((Object e) {
      onLogoutFailed(Strings.logoutIsFailed);
    });
  }
}
