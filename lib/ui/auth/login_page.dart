import 'package:blog_app/blocs/auth/auth_bloc.dart';
import 'package:blog_app/firebase/my_firebase_auth.dart';
import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/state/AuthStateContainer.dart';
import 'package:blog_app/ui/auth/signUp_page.dart';
import 'package:blog_app/ui/dialog/loading_dialog.dart';
import 'package:blog_app/ui/dialog/msg_dialog.dart';
import 'package:blog_app/utils/constants.dart';
import 'package:blog_app/utils/enums.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  AuthBloc _authBloc = new AuthBloc();
  bool _formIsValid = false;
  AuthState _authState;
  Map<String, String> _data;

  // Constants
  final _emailKey = 'email';
  final _passwordKey = 'password';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController.addListener(() {
      _validate();
    });
    _passwordController.addListener(() {
      _validate();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _authState = AuthStateContainer.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _passwordController.dispose();
    _authBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.loginPageTitle),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.minHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    _buildLogo(),
                    _buildForm()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return CircleAvatar(
      backgroundImage: AssetImage(Constants.appIcon),
      radius: 80,
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Form(
        child: Column(
          children: <Widget>[
            _buildTextField(Strings.emailTfLabel, TextInputType.emailAddress,
                false, _emailController, _authBloc.emailStream),
            SizedBox(height: 10),
            _buildTextField(Strings.passwordTfLabel, TextInputType.text, true,
                _passwordController, _authBloc.passwordStream),
            SizedBox(height: 20),
            _buildLoginBtn(),
            SizedBox(height: 10),
            _buildSignUpQuestion()
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextInputType keyboardType,
      bool obscureText, TextEditingController controller, Stream stream) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            labelText: labelText,
            errorText: snapshot.hasError ? snapshot.error.toString() : null),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: ElevatedButton(
          onPressed: () => _loginBtnOnPressed(),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepPurple),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.only(top: 12, bottom: 12))),
          child: Text(
            Strings.loginBtn,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buildSignUpQuestion() {
    return RichText(
      text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black),
          children: <TextSpan>[
            TextSpan(text: "Not have an account?"),
            TextSpan(
                text: " Create Account?",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = _createAccountButtonOnTap)
          ]),
    );
  }

  void _validate() {
    String email = _emailController.text;
    String password = _passwordController.text;
    _data = {_emailKey: email, _passwordKey: password};
    this._formIsValid = _authBloc.formLoginIsValid(email, password);
  }

  void _loginBtnOnPressed() {
    if (!_formIsValid) {
      return;
    }
    LoadingDialog.show(context, null);
    MyFirebaseAuth.instance.login(_data[_emailKey], _data[_passwordKey],
        (MyUser user) {
      LoadingDialog.dismiss(context);
      _handleLoginSuccess(user);
    }, (msg) {
      LoadingDialog.dismiss(context);
      MsgDialog.show(context, msg);
    });
  }

  void _handleLoginSuccess(MyUser user) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(Constants.USER_ID_KEY, user.id);
      _authState.updateAuthStatus(AuthStatus.loggedIn);
    });
  }

  void _createAccountButtonOnTap() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
