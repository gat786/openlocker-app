import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_locker_app/pages/LoginPage.dart';
import 'package:open_locker_app/pages/SignupPage.dart';

class Routes{
  static const String LoginPage = "/login";
  static const String SignupPage = "/register";
  static const String DrivePage = "/drive";
}

class RoutesGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case Routes.LoginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case Routes.SignupPage:
        return MaterialPageRoute(builder: (_) => SignupPage());
      default:
        return MaterialPageRoute(builder: (_) => SignupPage());
    }
  }
}