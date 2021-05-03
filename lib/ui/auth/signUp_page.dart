import 'dart:ffi';

import 'package:blog_app/blocs/auth/auth_bloc.dart';
import 'package:blog_app/firebase/my_firebase_auth.dart';
import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/ui/dialog/loading_dialog.dart';
import 'package:blog_app/ui/dialog/msg_dialog.dart';
import 'package:blog_app/ui/dialog/my_dialog.dart';
import 'package:blog_app/utils/constants.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  AuthBloc _authBloc = new AuthBloc();
  bool _formIsValid = false;
  Gender _genderSelected;
  MyUser _userSignUp;

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
    _phoneNumberController.addListener(() {
      _validate();
    });
    _genderController.addListener(() {
      _validate();
    });
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
        title: Text(Strings.signUpPageTitle),
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
            SizedBox(height: 10),
            _buildTextField(Strings.phoneNumberTfLabel, TextInputType.phone,
                false, _phoneNumberController, _authBloc.phoneNumberStream),
            SizedBox(height: 10),
            _buildPickerTextField(Strings.genderTfLabel, _genderController,
                _authBloc.genderStream, _showGenderPickerWidget),
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
              errorText: snapshot.hasError ? snapshot.error.toString() : null)),
    );
  }

  Widget _buildPickerTextField(String labelText,
      TextEditingController controller, Stream stream, Function onTap) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                labelText: labelText,
                errorText:
                    snapshot.hasError ? snapshot.error.toString() : null),
          ),
        ),
      ),
    );
  }

  void _showGenderPickerWidget() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 200,
              child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: _genderSelected == null
                          ? 0
                          : MyUser.genderToInt(_genderSelected)),
                  itemExtent: 50,
                  onSelectedItemChanged: (index) {
                    _onSelectedGenderItemChanged(index);
                  },
                  children: _buildListGenderWidget()),
            ));
  }

  void _onSelectedGenderItemChanged(int index) {
    Gender gender = MyUser.intToGender(index);
    _genderSelected = gender;
    _genderController.text = MyUser.genderToString(gender);
    _validate();
  }

  List<Widget> _buildListGenderWidget() {
    List<Gender> genders = [Gender.female, Gender.male, Gender.other];
    List<Widget> genderTexts = [];
    for (Gender gender in genders) {
      genderTexts.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(MyUser.genderToString(gender),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.normal))
        ],
      ));
    }
    return genderTexts;
  }

  Widget _buildLoginBtn() {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: ElevatedButton(
          onPressed: () => _signUpButtonOnPressed(),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepPurple),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.only(top: 12, bottom: 12))),
          child: Text(
            Strings.signUpBtn,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buildSignUpQuestion() {
    return RichText(
      text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black),
          children: <TextSpan>[
            TextSpan(text: "Already an account?"),
            TextSpan(
                text: " Login now?",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = _loginNowButtonOnTap)
          ]),
    );
  }

  void _validate() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String phoneNumber = _phoneNumberController.text;
    MyUser user = MyUser(null, email, password, phoneNumber, _genderSelected);
    _userSignUp = user;
    this._formIsValid = _authBloc.formSignUpIsValid(user);
  }

  void _signUpButtonOnPressed() {
    if (!_formIsValid) {
      return;
    }
    LoadingDialog.show(context, null);
    MyFirebaseAuth.instance.signUp(_userSignUp, () {
      LoadingDialog.dismiss(context);
      _handleSignUpSuccess();
    }, (msg) {
      LoadingDialog.dismiss(context);
      MsgDialog.show(context, msg);
    });
  }

  void _handleSignUpSuccess() {
    List<Function> btnOnTaps = <Function>[_loginNowButtonOnTap, () {}];

    MyDialog.show(context, Strings.signUpSuccess,
        [Strings.loginNowBtn, Strings.cancelBtn], btnOnTaps);
  }

  void _loginNowButtonOnTap() {
    Navigator.pop(context);
  }
}
