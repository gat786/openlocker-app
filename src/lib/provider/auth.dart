import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/models/login_response.dart';
import 'package:open_locker_app/models/standard_response.dart';
import 'package:open_locker_app/services/shared_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:open_locker_app/services/common.service.dart';
import "../models/user.dart";

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User _userData = User();
  String _accessToken = "";

  AuthProvider() {
    setup();
  }

  User get userData => _userData;

  bool get isLoggedIn => _isLoggedIn;

  String get accessToken => _accessToken;

  set isLoggedIn(bool newValue) {
    _isLoggedIn = newValue;
    notifyListeners();
  }

  set userData(User user) {
    _userData = user;
    notifyListeners();
  }

  set accessToken(String newToken) {
    _accessToken = newToken;
    notifyListeners();
  }

  Future logoutUser() async {
    await deleteSharedUserPreferences();
    CommonService.deleteCookies();
    isLoggedIn = false;
    accessToken = "";
    userData = User();
  }

  Future loginUser({required String userName, required String password}) async {
    var uri = API_ENDPOINT + "user/login";
    var jsonBody = jsonEncode({'username': userName, 'password': password});
    var commonService = await CommonService.getInstance();
    Response? response = await commonService.post(url: uri, body: jsonBody);
    if (response != null && response.data != null) {
      var standardResponse = StandardResponse.fromJson(
          Map<String, dynamic>.from(jsonDecode(response.toString())));

      print(standardResponse.data);

      if (standardResponse.success == true) {
        isLoggedIn = true;
        var login_response =
            LoginResponse.fromJson(Map.from(standardResponse.data));
        var user = new User(
            userName: login_response.username,
            emailAddress: login_response.emailAddress,
            refreshToken: login_response.refreshToken?.token ?? "");
        updateSharedUserPreferences(user);
        userData = user;
        accessToken = login_response.accessToken ?? "";
        Fluttertoast.showToast(msg: "Successfully logged in");
      } else {
        throw Exception(standardResponse.message);
      }
    } else {
      Fluttertoast.showToast(msg: "Username and password combination is wrong");
    }
  }

  Future<User?> signupUser(
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
    Response? response = await commonService.post(url: uri, body: jsonBody);
    if (response != null && response.data != null) {
      var standardResponse = StandardResponse.fromJson(
          Map<String, dynamic>.from(jsonDecode(response.toString())));

      isLoggedIn = true;
      var login_response = LoginResponse.fromJson(
          Map<String, dynamic>.from(standardResponse.data));
      var user = new User(
          userName: login_response.username,
          emailAddress: login_response.emailAddress,
          refreshToken: login_response.refreshToken?.token ?? "");
      updateSharedUserPreferences(user);
      userData = user;
      accessToken = login_response.accessToken ?? "";
      return user;
    }
    return null;
  }

  Future getAccessToken() async {
    if (userData.refreshToken != null && userData.refreshToken != "") {
      var uri = API_ENDPOINT + "user/get-new-tokens";
      CommonService commonService = await CommonService.getInstance();
      var response = await commonService.post(url: uri);
      var standardResponse = StandardResponse.fromJson(
          Map<String, dynamic>.from(jsonDecode(response.toString())));
      if (standardResponse.success == true) {
        isLoggedIn = true;
        var login_response =
            LoginResponse.fromJson(Map.from(standardResponse.data));
        var user = new User(
            userName: login_response.username,
            emailAddress: login_response.emailAddress,
            refreshToken: login_response.refreshToken?.token ?? "");
        updateSharedUserPreferences(user);
        userData = user;
        accessToken = login_response.accessToken ?? "";
      } else {
        print("Login failed");
      }
    }
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString(USERNAME_KEY) ?? "";
    String emailAddress = prefs.getString(EMAILADDRESS_KEY) ?? "";
    String refreshToken = prefs.getString(REFRESHTOKEN_KEY) ?? "";

    if (username != "" && emailAddress != "" && refreshToken != "") {
      userData = User(
          userName: username,
          emailAddress: emailAddress,
          refreshToken: refreshToken);
      await getAccessToken();
    }
  }
}
