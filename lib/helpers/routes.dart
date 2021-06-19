import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_locker_app/pages/drive_page.dart';
import 'package:open_locker_app/pages/image_preview_page.dart';
import 'package:open_locker_app/pages/login_page.dart';
import 'package:open_locker_app/pages/signup_page.dart';

class Routes{
  static const String LoginPage = "/login";
  static const String SignupPage = "/register";
  static const String DrivePage = "/drive";
  static const String ImageViewer = "/view";
}

class RoutesGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final dynamic args = settings.arguments;

    switch(settings.name){
      case Routes.LoginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case Routes.SignupPage:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case Routes.ImageViewer:
        return MaterialPageRoute(builder: (_) => ImagePreview(imageUrl: args?.imageUrl));
      default:
        return MaterialPageRoute(builder: (_) => DrivePage());
    }
  }
}