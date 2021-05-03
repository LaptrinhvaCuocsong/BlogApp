import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/utils/constants.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/extensions/IntExtension.dart';

class UserInfoPage extends StatefulWidget {
  final MyUser _user;

  UserInfoPage(this._user);

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(Strings.userInfoPageTitle)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        _buildAvatar(),
        ListTile(
          leading: Icon(Icons.email),
          title: Text(widget._user.email, style: TextStyle(fontSize: 16)),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(widget._user.phoneNumber, style: TextStyle(fontSize: 16)),
        )
      ],
    );
  }

  Widget _buildAvatar() {
    double avatarHeight = 120.scaleH(context);

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: 160.scaleH(context),
        child: Center(
          child: Hero(
            tag: Constants.avatarHeroTag,
            child: Container(
              width: avatarHeight,
              height: avatarHeight,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
