import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/models/standard_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:open_locker_app/services/common.service.dart';
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

  set UserData(User user) {
    _userData = user;
    notifyListeners();
  }

  void loginUser({required String userName, required String password}) async {
    var uri = API_ENDPOINT + "user/login";
    var jsonBody = jsonEncode({'username': userName, 'password': password});
    var commonService = await CommonService.getInstance();
    var response = await commonService.post(url: uri, body: jsonBody);
    var standardResponse = StandardResponse.fromJson(
        Map<String, dynamic>.from(jsonDecode(response.toString())));

    if (standardResponse.success == true) {
      LoggedIn = true;
      var user = new User(
          userName: standardResponse.data["username"],
          emailAddress: standardResponse.data["emailAddress"],
          refreshToken: standardResponse.data["refreshToken"]["token"]);
      UserData = user;
    }
  }

  void signupUser(
      {required String userName,
      required String emailAddress,
      required String password}) async {

    var uri = API_ENDPOINT + "user/register";

    var jsonBody = jsonEncode({
      'username': userName,
      'emailAddress': emailAddress,
      'password': password
    });

    CommonService commonService = await CommonService.getInstance();
    var response = await commonService.post(url: uri, body: jsonBody);
    var standardResponse = StandardResponse.fromJson(
        Map<String, dynamic>.from(jsonDecode(response.toString())));
    if(standardResponse.success == true){
      print("User registration successful");
    }
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
