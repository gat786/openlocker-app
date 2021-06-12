import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/models/login_response.dart';
import 'package:open_locker_app/models/standard_response.dart';
import 'package:open_locker_app/services/shared_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:open_locker_app/services/common.service.dart';
import "../models/user.dart";

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isProcessing = false;
  User _userData = User();

  AuthProvider() {
    setup();
  }

  User get UserData => _userData;

  bool get LoggedIn => _isLoggedIn;

  bool get isProcessing => _isProcessing;

  set LoggedIn(bool newValue) {
    _isLoggedIn = newValue;
    notifyListeners();
  }

  set isProcessing(bool newValue){
    _isProcessing = newValue;
    notifyListeners();
  }

  set UserData(User user) {
    _userData = user;
    notifyListeners();
  }

  void loginUser({required String userName, required String password}) async {
    isProcessing = true;
    var uri = API_ENDPOINT + "user/login";
    var jsonBody = jsonEncode({'username': userName, 'password': password});
    var commonService = await CommonService.getInstance();
    var response = await commonService.post(url: uri, body: jsonBody);
    var standardResponse = StandardResponse.fromJson(
        Map<String, dynamic>.from(jsonDecode(response.toString())));

    if (standardResponse.success == true) {
      LoggedIn = true;
      var login_response = LoginResponse.fromJson(Map.from(standardResponse.data));
      var user = new User(
          userName: login_response.username,
          emailAddress: login_response.emailAddress,
          refreshToken: login_response.refreshToken?.token ?? "");
      updateSharedUserPreferences(user);
      UserData = user;
    }
    isProcessing = false;
  }

  void signupUser(
      {required String userName,
      required String emailAddress,
      required String password}) async {
    isProcessing = true;
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
      var login_response = LoginResponse.fromJson(Map.from(standardResponse.data));
      var user = new User(
          userName: login_response.username,
          emailAddress: login_response.emailAddress,
          refreshToken: login_response.refreshToken?.token ?? "");
      updateSharedUserPreferences(user);
      UserData = user;
    }
    isProcessing = false;
  }

  void getAccessToken() async {
    isProcessing = true;
    var uri = API_ENDPOINT + "user/get-new-tokens";
    CommonService commonService = await CommonService.getInstance();
    var response = await commonService.post(url: uri);
    isProcessing = false;
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? username = prefs.getString(USERNAME_KEY);
    String? emailAddress = prefs.getString(EMAILADDRESS_KEY);
    String? refreshToken = prefs.getString(REFRESHTOKEN_KEY);
    if (username != null && emailAddress != null) {
      UserData = User(userName: username, emailAddress: emailAddress,refreshToken: refreshToken);
    }

  }
}
