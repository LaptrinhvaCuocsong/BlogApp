import 'package:blog_app/blocs/home/setting/setting_bloc.dart';
import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/state/AuthStateContainer.dart';
import 'package:blog_app/ui/dialog/loading_dialog.dart';
import 'package:blog_app/ui/dialog/msg_dialog.dart';
import 'package:blog_app/utils/constants.dart';
import 'package:blog_app/utils/enums.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/extensions/IntExtension.dart';
import 'package:blog_app/ui/home/setting/user_info/user_info_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingBloc _settingBloc = SettingBloc();
  MyUser _user;
  AuthState _authState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _settingBloc.fetchUser();
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
    _settingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settingPageTitle),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder(
      stream: _settingBloc.settingStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildEmptyWidget();
        } else if (snapshot.hasData) {
          _user = snapshot.data;
          return _buildSettingWidget();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Text(Strings.getBlogsIsFailed),
    );
  }

  Widget _buildSettingWidget() {
    double avatarHeight = 60.scaleH(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Hero(
              tag: Constants.avatarHeroTag,
              child: Container(
                  width: avatarHeight,
                  height: avatarHeight,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
            ),
            title: GestureDetector(
              onTap: _onTapUsernameBtn,
              child: Text(_user.email, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: GestureDetector(
              onTap: _onTapLogoutBtn,
              child: Text(
                Strings.logoutBtn,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onTapUsernameBtn() {
    if (_user == null) {
      return;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserInfoPage(_user)));
  }

  void _onTapLogoutBtn() {
    if (_user == null) {
      return;
    }
    LoadingDialog.show(context, null);
    _settingBloc.logout(() {
      LoadingDialog.dismiss(context);
      _handleLogoutSuccess();
    }, (msg) {
      LoadingDialog.dismiss(context);
      MsgDialog.show(context, msg);
    });
  }

  void _handleLogoutSuccess() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(Constants.USER_ID_KEY);
      _authState.updateAuthStatus(AuthStatus.notLogin);
    });
  }
}
