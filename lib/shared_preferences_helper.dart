import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesHelper {

  static final String _kUserCode = "user_key";

  static saveUser(user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (user == null) {
      prefs.remove(_kUserCode);
      return;
    }

    prefs.setString(_kUserCode, json.encode(user));
  }

  static getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userStr = prefs.get(_kUserCode);

    return userStr != null ? json.decode(userStr) : userStr;
  }

}