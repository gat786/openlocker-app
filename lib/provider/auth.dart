import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:open_locker_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import "../models/user.dart";

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User _userData = User();

  AuthProvider() {
    setup();
  }

  User get UserData => _userData;
  bool get LoggedIn => _isLoggedIn;

  set LoggedIn(bool newValue) {
    _isLoggedIn = newValue;
    notifyListeners();
  }

  set UserData(User user){
    _userData = user;
    notifyListeners();
  }

  void loginUser(String userName, String password) async {
    var uri = Uri.parse(API_ENDPOINT + "user/login");
    var jsonBody = jsonEncode({ 'username' : userName, 'password' : password});
    var response = await http.post(uri,headers: { 'Content-Type' : 'application/json'}, body: jsonBody);
    print(response.body);
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? username = prefs.getString(USERNAME_KEY);
    String? emailAddress = prefs.getString(EMAILADDRESS_KEY);
    if (username != null && emailAddress != null) {
      UserData = User(userName: username, emailAddress: emailAddress);
    }
  }
}
