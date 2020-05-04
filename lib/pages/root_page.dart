import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");// message: {notification: {title: '', body: ''}, data: {}}
      },
//      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });

    checkLogin();
  }

  checkLogin() async {
    var user = await SharedPreferencesHelper.getUser();

    setState(() {
      authStatus = user != null ? AuthStatus.LOGGED_IN : AuthStatus.NOT_LOGGED_IN;
    });
  }

//  myBackgroundMessageHandler(Map<String, dynamic> message) {
//    print("_backgroundMessageHandler");
//    if (message.containsKey('data')) {
//      // Handle data message
//      final dynamic data = message['data'];
//      print("_backgroundMessageHandler data: ${data}");
//    }
//
//    if (message.containsKey('notification')) {
//      // Handle notification message
//      final dynamic notification = message['notification'];
//      print("_backgroundMessageHandler notification: ${notification}");
//    }
//  }

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

//  myBackgroundMessageHandler(Map<String, dynamic> message) {
//    if (message.containsKey('data')) {
//      // Handle data message
//      final dynamic data = message['data'];
//    }
//
//    if (message.containsKey('notification')) {
//      // Handle notification message
//      final dynamic notification = message['notification'];
//    }
//
//    // Or do other work.
//  }

}