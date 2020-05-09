import 'package:flutter/material.dart';
import 'package:myapps/pages/home_page.dart';
import 'package:myapps/pages/login.dart';
import 'package:myapps/shared_preferences_helper.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {

  RootPage();

  @override
  State<StatefulWidget> createState() {
    return new _RootPageState();
  }

}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    var user = await SharedPreferencesHelper.getUser();

    setState(() {
      authStatus = user != null ? AuthStatus.LOGGED_IN : AuthStatus.NOT_LOGGED_IN;
    });
  }

  void loginCallback() {
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;

      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          loginCallback: loginCallback,
        );
        break;

      case AuthStatus.LOGGED_IN:
        return new HomePage(
          logoutCallback: logoutCallback,
        );
        break;

      default:
        return buildWaitingScreen();
        break;
    }
  }

}